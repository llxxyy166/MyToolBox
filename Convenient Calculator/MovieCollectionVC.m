//
//  MovieCollectionVC.m
//  Convenient Calculator
//
//  Created by xinye lei on 16/1/30.
//  Copyright © 2016年 xinye lei. All rights reserved.
//

#import "MovieCollectionVC.h"
#import "TMDb.h"
#import "MovieCollectionViewCell.h"
#import "MovieDetailViewController.h"
#import "MovieData.h"
#import "MovieCollectionHistoryVC.h"
@interface MovieCollectionVC()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) NSArray *movieList;
@end

@implementation MovieCollectionVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.delegate = self;
    if (self.genreID) {
        [self downLoadMovieDataWithGenreID:self.genreID];
    }
    if (self.displayUpcoming) {
        [self downLoadMovieDataWithUpcoming];
    }
}


- (NSMutableDictionary *)imageCache {
    if (!_imageCache) {
        _imageCache = [[NSMutableDictionary alloc] init];
    }
    return _imageCache;
}


- (void)setMovieList:(NSArray *)movieList {
    _movieList = movieList;
    [self.collectionView reloadData];
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.movieList count];
}

- (void)downLoadMovieDataWithGenreID: (NSString *)genreId {
    NSURL *url = [TMDb listOfMoviesWithGenreId:genreId withNumberOfPage:10];
    dispatch_queue_t fechQueue = dispatch_queue_create("fetch", NULL);
    dispatch_sync(fechQueue, ^{
        NSData *jsonRes = [NSData dataWithContentsOfURL:url];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonRes options:0 error:NULL];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.movieList = dic[MOVIE_GENRE_RESULTS];
        });
    });
}

- (void)downLoadMovieDataWithUpcoming {
    NSURL *url = [TMDb upComingMovieListWithNumberOfPages:1];
    dispatch_queue_t fechQueue = dispatch_queue_create("fetch", NULL);
    dispatch_sync(fechQueue, ^{
        NSData *jsonRes = [NSData dataWithContentsOfURL:url];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonRes options:0 error:NULL];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.movieList = dic[MOVIE_GENRE_RESULTS];
        });
    });
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    MovieCollectionViewCell *mCell = (MovieCollectionViewCell *)cell;
    NSDictionary *movie = self.movieList[indexPath.row];
    NSString *movieId = [[self.movieList[indexPath.row] valueForKey:MOVIE_GENRE_ID] stringValue];
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
     MovieCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"movieCell" forIndexPath:indexPath];
    cell.image = nil;
    NSDictionary *movie = self.movieList[indexPath.row];
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
    NSString *ID = [[self.movieList[indexPath.row] valueForKey:MOVIE_GENRE_ID] stringValue];
    cell.movieID = ID;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = self.collectionView.frame.size.width;
    CGFloat height = self.collectionView.frame.size.height / 4;
    return CGSizeMake(width, height);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([sender isKindOfClass:[MovieCollectionViewCell class]]) {
        NSIndexPath *path = [self.collectionView indexPathForCell:sender];
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
