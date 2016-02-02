//
//  MovieCollectionVC.h
//  Convenient Calculator
//
//  Created by xinye lei on 16/1/30.
//  Copyright © 2016年 xinye lei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCollectionVC : UICollectionViewController
@property (strong, nonatomic) NSString *genreID;
@property (nonatomic) BOOL displayUpcoming;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSMutableDictionary *imageCache;
@end
