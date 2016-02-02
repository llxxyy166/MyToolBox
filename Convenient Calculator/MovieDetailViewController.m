//
//  MovieDetailViewController.m
//  Convenient Calculator
//
//  Created by xinye lei on 16/1/29.
//  Copyright © 2016年 xinye lei. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "TMDb.h"
#import "MovieTrailerVC.h"
#import "MovieCollectionViewCell.h"
#import "MovieData.h"

@interface MovieDetailViewController() <UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) NSString *overview;
@property (strong, nonatomic) NSArray *companies;
@property (strong, nonatomic) NSArray *countries;
@property (strong, nonatomic) NSString *videoKey;
@property (weak, nonatomic) IBOutlet UITextView *overviewTextView;
@property (weak, nonatomic) IBOutlet UILabel *movieCountryLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieCompanyLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieTittleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *moviePosterImageView;
@property (weak, nonatomic) IBOutlet UICollectionView *similarMoviesCollectionView;
@property (strong, nonatomic) NSArray *similarMovieList;
@end

@implementation MovieDetailViewController

#define videoBasePath @"https://www.youtube.com/watch?v="

- (void)setMovieId:(NSString *)movieId {
    _movieId = movieId;
    NSData *jsonRes = [NSData dataWithContentsOfURL:[TMDb getMovieDetailById:movieId]];
    NSDictionary *res= [NSJSONSerialization JSONObjectWithData:jsonRes options:0 error:NULL];
    self.overview = res[MOVIE_DETAIL_OVERVIEW];
    self.companies = res[MOVIE_DETAIL_COMPANIES];
    self.countries = res[MOVIE_DETAIL_COUNTRIES];
    NSArray *videos = res[MOVIE_DETAIL_VIDEO][@"results"];
    if ([videos count]) {
        self.videoKey = videos[0][@"key"];
    }
}

- (void)setSimilarMovieList:(NSArray *)similarMovieList {
    _similarMovieList = similarMovieList;
    [self.similarMoviesCollectionView reloadData];
}

- (NSMutableDictionary *)imageCache {
    if (!_imageCache) {
        _imageCache = [[NSMutableDictionary alloc] init];
    }
    return _imageCache;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.overviewTextView.text= self.overview;
    self.movieTittleLabel.text = self.movieTittle;
    self.moviePosterImageView.image = self.posterImage;
    self.similarMoviesCollectionView.dataSource = self;
    self.similarMoviesCollectionView.delegate = self;
    [self downLoadSimilarMovieList];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([sender isKindOfClass:[MovieCollectionViewCell class]]) {
        NSIndexPath *path = [self.similarMoviesCollectionView indexPathForCell:sender];
        if (path) {
            MovieDetailViewController *vc = [segue destinationViewController];
            MovieCollectionViewCell *cell = sender;
            vc.movieId = cell.movieID;
            vc.movieTittle = cell.Title.text;
            vc.posterImage = self.imageCache[vc.movieId];
            vc.managedObjectContext = self.managedObjectContext;
            if (![self fetchWithId:cell.movieID]) {
                NSManagedObjectContext *contex = self.managedObjectContext;
                MovieData *movie = [NSEntityDescription insertNewObjectForEntityForName:@"MovieData" inManagedObjectContext:contex];
                movie.name = vc.movieTittle;
                movie.idNumber = cell.movieID;
                movie.rate = cell.date_language.text;
                movie.timeAndLan = cell.rate.text;
                movie.posterImage = UIImagePNGRepresentation(self.imageCache[vc.movieId]);
                [contex save: NULL];
                //NSLog(@"%@", movie);
            }
        }
    }
    else {
        MovieTrailerVC *vc = (MovieTrailerVC *)[segue destinationViewController];
        vc.videoKey = self.videoKey;
    }
}

- (void)downLoadSimilarMovieList {
    NSURL *url = [TMDb similarMoviesToMovieWithId:self.movieId forNumberOfPage:1];
    dispatch_queue_t fechQueue = dispatch_queue_create("fetch", NULL);
    dispatch_sync(fechQueue, ^{
        NSData *jsonRes = [NSData dataWithContentsOfURL:url];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonRes options:0 error:NULL];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.similarMovieList = dic[MOVIE_GENRE_RESULTS];
        });
    });
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.similarMovieList count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = self.similarMoviesCollectionView.frame.size.width / 3;
    CGFloat height = self.similarMoviesCollectionView.frame.size.height;
    return CGSizeMake(width, height);
}


- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    MovieCollectionViewCell *mCell = (MovieCollectionViewCell *)cell;
    NSDictionary *movie = self.similarMovieList[indexPath.row];
    NSString *movieId = [[self.similarMovieList[indexPath.row] valueForKey:MOVIE_GENRE_ID] stringValue];
    NSString *posterUrlString = [NSString stringWithFormat:@"%@%@%@", IMAGE_BASE_URL, IMAGE_POSTER_SIZE, movie[MOVIE_GENRE_POSTERPATH]];
    NSURL *imageUrl = [NSURL URLWithString:posterUrlString];
    
    if (self.imageCache[movieId]) {
        mCell.image = self.imageCache[movieId];
    }
    else {
        dispatch_queue_t downloadQueue = dispatch_queue_create("download", NULL);
        dispatch_sync(downloadQueue, ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            NSURLRequest *request = [NSURLRequest requestWithURL:imageUrl];
            NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
            NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
            NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                NSData *imageData = [NSData dataWithContentsOfURL:location];
                UIImage *image = [UIImage imageWithData:imageData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (image) {
                        self.imageCache[movieId] = image;
                        mCell.image = image;
                    }
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                });
            }];
            [task resume];
        });
    }
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MovieCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.image = nil;
    NSDictionary *movie = self.similarMovieList[indexPath.row];
    NSString *date, *lan, *rate, *count;
    cell.Title.text = movie[MOVIE_GENRE_TITTLE];
    date = movie[MOVIE_GENRE_DATE];
    lan = movie[MOVIE_GENRE_LANGUAGE];
    NSString *date_lan = [NSString stringWithFormat:@"%@  language: %@", date, lan];
    rate = movie[MOVIE_GENRE_VOTE_AVERAGE];
    count = movie[MOVIE_GENRE_VOTE_COUNT];
    NSString *vote = [NSString stringWithFormat:@"Rate: %@ among %@ users", rate, count];
    cell.date_language.text = date_lan;
    cell.rate.text = vote;
    NSString *ID = [[self.similarMovieList[indexPath.row] valueForKey:MOVIE_GENRE_ID] stringValue];
    cell.movieID = ID;
    return cell;
}

- (MovieData *)fetchWithId: (NSString *)ID {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"MovieData"];
    request.predicate = [NSPredicate predicateWithFormat:@"idNumber = %@", ID];
    NSManagedObjectContext *context = self.managedObjectContext;
    NSArray *res = [context executeFetchRequest:request error:NULL];
    if (!res || ![res count]) {
        return nil;
    }
    return [res firstObject];
}




@end
