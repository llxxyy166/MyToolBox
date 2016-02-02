//
//  MovieData+CoreDataProperties.h
//  Convenient Calculator
//
//  Created by xinye lei on 16/2/1.
//  Copyright © 2016年 xinye lei. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MovieData.h"

NS_ASSUME_NONNULL_BEGIN

@interface MovieData (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *idNumber;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *timeAndLan;
@property (nullable, nonatomic, retain) NSString *rate;
@property (nullable, nonatomic, retain) NSData *posterImage;

@end

NS_ASSUME_NONNULL_END
