//
//  MovieDetailViewController.m
//  Convenient Calculator
//
//  Created by xinye lei on 16/1/29.
//  Copyright © 2016年 xinye lei. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "TMDb.h"

@interface MovieDetailViewController() <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *movieWebView;
@property (strong, nonatomic) NSString *overview;
@property (strong, nonatomic) NSArray *companies;
@property (strong, nonatomic) NSArray *countries;
@property (strong, nonatomic) NSString *videoKey;
@property (weak, nonatomic) IBOutlet UITextView *overviewTextView;
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


- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *fullURL = [NSString stringWithFormat:@"%@%@", videoBasePath, self.videoKey];
    [fullURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.movieWebView loadRequest:requestObj];
    self.overviewTextView.text= self.overview;
}







@end
