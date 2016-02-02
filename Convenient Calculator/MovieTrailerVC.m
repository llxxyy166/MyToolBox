//
//  MovieTrailerVC.m
//  Convenient Calculator
//
//  Created by xinye lei on 16/2/1.
//  Copyright © 2016年 xinye lei. All rights reserved.
//

#import "MovieTrailerVC.h"

@interface MovieTrailerVC ()
@property (weak, nonatomic) IBOutlet UIWebView *movieWebView;

@end

@implementation MovieTrailerVC

#define videoBasePath @"https://www.youtube.com/watch?v="

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *fullURL = [NSString stringWithFormat:@"%@%@", videoBasePath, self.videoKey];
    [fullURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.movieWebView loadRequest:requestObj];
}


@end
