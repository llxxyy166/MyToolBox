//
//  Yahoo.h
//  Convenient Calculator
//
//  Created by xinye lei on 16/1/19.
//  Copyright © 2016年 xinye lei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YahooKey.h"

#define PATH @"places.place"

@interface Yahoo : NSObject

#define PLACES_COUNT @"places.count"   // string   NSNumber
#define PLACES_ARRAY @"places.place"  // Here return the array of place
#define ADMIN1 @"admin1"   // keypath for the cell of place array  NSString
#define ADMIN2 @"admin2"   // keypath for the cell of place array  NSString
#define ADMIN3 @"admin3"   // keypath for the cell of place array  NSString
#define NAME @"name"
#define COUNTRY @"country" // keypath for the cell of place array  NSString
#define PLACE_WOEID @"woeid" // keypath for the cell of place array  NSNumber
+ (NSURL *)URLForPlaces: (NSString *)place;


#define WEATHER_ASTRONOMY @"query.results.channel.astronomy" //sunrise, sunset, dict
#define WEATHER_ATMOSPHERE @"query.results.channel.atmosphere" //dict
#define WEATHER_LOGO @"query.results.channel.image" //dict

#define WEATHER_CONDITION @"query.results.channel.item.condition"  //dict
#define WEATHER_CONDITION_TEMP @"temp"
#define WEATHER_CONDITION_TEXT @"text"

#define WEATHER_PUB_DATE @"query.results.channel.item.pubDate"

#define WEATHER_FORECAST @"query.results.channel.item.forecast" //array of dict
#define WEATHER_FORECAST_DAY @"day"
#define WEATHER_FORECAST_HIGH @"high"
#define WEATHER_FORECAST_LOW @"low"
#define WEATHER_FORECAST_TEXT @"text"

#define WEATHER_WIND @"query.results.channel.wind" //dict
+ (NSURL *)URLForWeatherWithWoeid: (NSString *)woeid;

+ (NSDictionary *)getDictByURL: (NSURL *)url;
@end
