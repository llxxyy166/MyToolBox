//
//  MovieDetailViewController.h
//  Convenient Calculator
//
//  Created by xinye lei on 16/1/29.
//  Copyright © 2016年 xinye lei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieDetailViewController : UIViewController 

@property (strong, nonatomic) NSString *movieId;
@property (strong, nonatomic) NSString *movieTittle;
@property (strong, nonatomic) UIImage *posterImage;
@property (strong, nonatomic) NSMutableDictionary *imageCache;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end
