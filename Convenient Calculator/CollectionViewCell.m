//
//  CollectionViewCell.m
//  Convenient Calculator
//
//  Created by xinye lei on 16/1/19.
//  Copyright © 2016年 xinye lei. All rights reserved.
//

#import "CollectionViewCell.h"
#import "Yahoo.h"
@interface CollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *dayNightView;
@property (weak, nonatomic) IBOutlet UILabel *WeatherLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *WeatherForecastLabels;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *WeatherForecastImages;

@end

@implementation CollectionViewCell

static NSString * const keyForSavedPlaces = @"savedPlaces";



- (void)setWoeid:(NSInteger)Woeid {
    _Woeid = Woeid;
    NSString *woeidS = [NSString stringWithFormat:@"%ld", (long)Woeid];
    self.WeatherLabel.text = [self fetchWeatherWithWoeid:woeidS];
    //[self sendSubviewToBack:self.dayNightView];
    
}

- (void)setDisplayLocation:(NSString *)displayLocation {
    _displayLocation = displayLocation;
    self.locationLabel.text = displayLocation;
}

- (NSInteger)convertTemp: (NSInteger)tInF {
    double TinC = (double)(tInF - 32) / 1.8;
    return (NSInteger)TinC;
}

- (NSString *)fetchWeatherWithWoeid: (NSString *)woeid {
    NSString *WeatherDesc = nil;
    if (self.Woeid) {
        NSURL *weatherURL = [Yahoo URLForWeatherWithWoeid:woeid];
        NSDictionary *res = [Yahoo getDictByURL:weatherURL];
        if (res) {
            NSString *timeText = [res valueForKeyPath:WEATHER_PUB_DATE];
            self.timeLabel.text = [res valueForKeyPath:WEATHER_PUB_DATE];
            NSArray *split = [timeText componentsSeparatedByString:@" "];
            NSString *time;
            NSInteger intTime = 0;
            for (NSString *string in split) {
                if ([string containsString:@":"]) {
                    NSArray *s = [string componentsSeparatedByString:@":"];
                    time = s[0];
                    intTime = [time integerValue];
                }
                if ([string containsString:@"pm"]) {
                    intTime += 12;
                }
            }
            if (intTime < 6 || intTime > 18) {
                self.dayNightView.image = [UIImage imageNamed:@"night"];
                self.WeatherLabel.textColor = [UIColor whiteColor];
                self.locationLabel.textColor = [UIColor whiteColor];
                self.timeLabel.textColor = [UIColor whiteColor];
            }
            else {
                self.dayNightView.image = [UIImage imageNamed:@"day"];
                self.WeatherLabel.textColor = [UIColor blackColor];
                self.locationLabel.textColor = [UIColor blackColor];
                self.timeLabel.textColor = [UIColor blackColor];
            }
            self.dayNightView.contentMode = UIViewContentModeScaleToFill;
            NSDictionary *forca = [res valueForKeyPath:WEATHER_CONDITION];
            NSString *temp = [forca valueForKeyPath:WEATHER_CONDITION_TEMP];
            NSInteger tInC = [self convertTemp:[temp integerValue]];
            temp = [NSString stringWithFormat:@"%ld", (long)tInC];
            NSString *text = [forca valueForKeyPath:WEATHER_CONDITION_TEXT];
            WeatherDesc = [NSString stringWithFormat:@"%@°C  %@", temp, text];
            NSArray *forecast = [res valueForKeyPath:WEATHER_FORECAST];
            for (int i = 0; i < 5; i++) {
                NSDictionary *forcForADay = forecast[i];
                NSString *day = [forcForADay valueForKeyPath:WEATHER_FORECAST_DAY];
                NSString *high = [forcForADay valueForKeyPath:WEATHER_FORECAST_HIGH];
                NSString *low = [forcForADay valueForKeyPath:WEATHER_FORECAST_LOW];
                NSString *text = [forcForADay valueForKeyPath:WEATHER_FORECAST_TEXT];
                NSInteger highInC = [self convertTemp:[high integerValue]];
                NSInteger lonwInC = [self convertTemp:[low integerValue]];
                high = [NSString stringWithFormat:@"%ld", (long)highInC];
                low = [NSString stringWithFormat:@"%ld", (long)lonwInC];
                UILabel *forcLabel = self.WeatherForecastLabels[i];
                forcLabel.textColor = [UIColor orangeColor];
                forcLabel.highlighted = YES;
                forcLabel.textAlignment = NSTextAlignmentCenter;
                forcLabel.numberOfLines = 3;
                forcLabel.text = [NSString stringWithFormat:@"%@\n%@°C-%@°C\n%@", day, low, high, text];
                UIImageView *view = self.WeatherForecastImages[i];
                view.alpha = 0.5;
                if ([text containsString:@"Sunny"] || [text containsString:@"Fair"] || [text containsString:@"Clear"]) {
                    view.image = [UIImage imageNamed:@"sunny"];
                }
                if ([text containsString:@"Cloudy"]) {
                    view.image = [UIImage imageNamed:@"overcast"];
                }
                if ([text containsString:@"Partly Cloudy"]) {
                    view.image = [UIImage imageNamed:@"partly cloudy"];
                }
                if ([text containsString:@"ain"] || [text containsString:@"hower"]) {
                    view.image = [UIImage imageNamed:@"rain"];
                }
                if ([text containsString:@"now"]) {
                    view.image = [UIImage imageNamed:@"snow"];
                }
                if ([text containsString:@"hunder"]) {
                    view.image = [UIImage imageNamed:@"thunder"];
                }
                if ([text containsString:@"fog"] || [text containsString:@"haze"]) {
                    view.image = [UIImage imageNamed:@"haze"];
                }
            }
        }
    }
    return WeatherDesc;
}






@end
