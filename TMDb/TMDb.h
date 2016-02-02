//
//  TMDb.h
//  Convenient Calculator
//
//  Created by xinye lei on 16/1/28.
//  Copyright © 2016年 xinye lei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TMDb : NSObject

#define CONFIG_CHANGE_KEYS @"change_keys"
#define CONFIG_IMAGES @"images"
#define IMAGE_BASE_URL @"http://image.tmdb.org/t/p/"
#define IMAGE_POSTER_SIZE @"original"
+ (NSURL *)configuration;

#define GENRE @"genres"
#define GENRE_ID @"id"
#define GENRE_NAME @"name"
+ (NSURL *)genreList;
//This return an dictionary of array of dictionary  ({id = xx; name = xx}, {id = xx; name = xx},...)

#define MOVIE_GENRE_ID @"id"
#define MOVIE_GENRE_PAGE @"page"
#define MOVIE_GENRE_RESULTS @"results"
#define MOVIE_GENRE_POSTERPATH @"poster_path"
#define MOVIE_GENRE_TITTLE @"original_title"
#define MOVIE_GENRE_VOTE_AVERAGE @"vote_average"
#define MOVIE_GENRE_VOTE_COUNT @"vote_count"
#define MOVIE_GENRE_LANGUAGE @"original_language"
#define MOVIE_GENRE_DATE @"release_date"
+ (NSURL *)listOfMoviesWithGenreId: (NSString *)ID
                  withNumberOfPage: (NSUInteger)number;

//This return an dictionary: {id = xx; page = xx; resutls = (array)}
//where each element in the array is a dictionary

+ (NSURL *)similarMoviesToMovieWithId: (NSString *)ID
                      forNumberOfPage: (NSUInteger)page;

#define MOVIE_DETAIL_OVERVIEW @"overview"
#define MOVIE_DETAIL_COMPANIES @"production_companies"
#define MOVIE_DETAIL_COUNTRIES @"production_countries"
#define MOVIE_DETAIL_VIDEO @"videos"
+ (NSURL *)getMovieDetailById: (NSString *)ID;

+ (NSURL *)upComingMovieListWithNumberOfPages: (NSUInteger)number;

@end
