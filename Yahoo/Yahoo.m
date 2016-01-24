//
//  Yahoo.m
//  Convenient Calculator
//
//  Created by xinye lei on 16/1/19.
//  Copyright © 2016年 xinye lei. All rights reserved.
//

#import "Yahoo.h"

@implementation Yahoo


+ (NSURL *)URLForPlaces: (NSString *)place {
    NSString *urlString =[NSString stringWithFormat:@"http://where.yahooapis.com/v1/places(%@);count=0?lang=en&format=json&appid=[%@]", place, KEY];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return [NSURL URLWithString:urlString];
}

+ (NSURL *)URLForWeatherWithWoeid: (NSString *)woeid {
    NSString *string = [NSString stringWithFormat:@"https://query.yahooapis.com/v1/public/yql?q=select * from weather.forecast WHERE woeid=%@&format=json&lang=en", woeid];
    string = [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return [NSURL URLWithString:string];
}

+ (NSDictionary *)getDictByURL: (NSURL *)url {
    NSDictionary *dict = nil;
    NSData *jsonRes = [NSData dataWithContentsOfURL:url];
    if (jsonRes) {
        dict = [NSJSONSerialization JSONObjectWithData:jsonRes options:0 error:NULL];
    }
    return dict;
}

@end
