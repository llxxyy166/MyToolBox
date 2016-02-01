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
@interface MovieCollectionVC()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) NSArray *movieList;
@property (strong, nonatomic) NSMutableDictionary *imageCache;
@end

@implementation MovieCollectionVC

- (NSMutableDictionary *)imageCache {
    if (!_imageCache) {
        _imageCache = [[NSMutableDictionary alloc] init];
    }
    return _imageCache;
}

- (NSArray *)movieList {
    if (!_movieList) {
        NSURL *url = [TMDb listOfMoviesWithGenreId:self.genreID withNumberOfPage:1];
        NSData *jsonRes = [NSData dataWithContentsOfURL:url];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonRes options:0 error:NULL];
        _movieList = dic[MOVIE_GENRE_RESULTS];
    }
    //NSLog(@"%@", _movieList);
    return _movieList;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.movieList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
     MovieCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"movieCell" forIndexPath:indexPath];
    NSDictionary *movie = self.movieList[indexPath.row];
    NSString *posterUrlString = [NSString stringWithFormat:@"%@%@%@", IMAGE_BASE_URL, IMAGE_POSTER_SIZE, movie[MOVIE_GENRE_POSTERPATH]];
    NSURL *imageUrl = [NSURL URLWithString:posterUrlString];
    if (self.imageCache[imageUrl]) {
        cell.image = self.imageCache[imageUrl];
    }
    else {
        dispatch_queue_t downloadQueue = dispatch_queue_create("download", NULL);
        dispatch_sync(downloadQueue, ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            NSURLRequest *request = [NSURLRequest requestWithURL:imageUrl];
            NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
            NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
            NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSData *imageData = [NSData dataWithContentsOfURL:location];
                    UIImage *image = [UIImage imageWithData:imageData];
                    if (image) {
                        self.imageCache[imageUrl] = image;
                        cell.image = image;
                    }
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                });
            }];
            [task resume];
        });
    }
    cell.Title.text = movie[MOVIE_GENRE_TITTLE];
    NSString *date = movie[MOVIE_GENRE_DATE];
    NSString *lan = movie[MOVIE_GENRE_LANGUAGE];
    NSString *date_lan = [NSString stringWithFormat:@"%@  language: %@", date, lan];
    NSString *rate = movie[MOVIE_GENRE_VOTE_AVERAGE];
    NSString *count = movie[MOVIE_GENRE_VOTE_COUNT];
    NSString *vote = [NSString stringWithFormat:@"Rate: %@ among %@ users", rate, count];
    cell.date_language.text = date_lan;
    cell.rate.text = vote;
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
            vc.movieId = [self.movieList[path.row] valueForKey:MOVIE_GENRE_ID];
        }
    }
}
@end
