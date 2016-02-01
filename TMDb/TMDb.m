//
//  TMDb.m
//  Convenient Calculator
//
//  Created by xinye lei on 16/1/28.
//  Copyright © 2016年 xinye lei. All rights reserved.
//

#import "TMDb.h"
#import "TMDbKey.h"
@implementation TMDb

+ (NSURL *)configuration {
        NSString *urlString = [NSString stringWithFormat:@"http://api.themoviedb.org/3/configuration?api_key=%@",KEY];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return [NSURL URLWithString:urlString];
}

+ (NSURL *)genreList {
    NSString *urlString = [NSString stringWithFormat:@"http://api.themoviedb.org/3/genre/movie/list?api_key=%@",KEY];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return [NSURL URLWithString:urlString];
}

+ (NSURL *)listOfMoviesWithGenreId:(NSString *)ID
                  withNumberOfPage:(NSUInteger)number {
    NSString *pageNumber = [NSString stringWithFormat:@"%lu", (unsigned long)number];
    NSString *urlString = [NSString stringWithFormat:@"http://api.themoviedb.org/3/genre/%@/movies?api_key=%@&page=%@&sort_by=release_date.desc", ID, KEY, pageNumber];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return [NSURL URLWithString:urlString];
}

+ (NSURL *)similarMoviesToMovieWithId:(NSString *)ID {
        NSString *urlString = [NSString stringWithFormat:@"http://api.themoviedb.org/3/movie/%@/similar?api_key=%@", ID, KEY];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return [NSURL URLWithString:urlString];
}

+ (NSURL *)getMovieDetailById:(NSString *)ID {
    NSString *urlString = [NSString stringWithFormat:@"http://api.themoviedb.org/3/movie/%@?api_key=%@&append_to_response=videos", ID, KEY];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return [NSURL URLWithString:urlString];
}

@end
