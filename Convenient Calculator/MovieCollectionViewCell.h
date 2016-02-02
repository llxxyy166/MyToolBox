//
//  MovieCollectionViewCell.h
//  Convenient Calculator
//
//  Created by xinye lei on 16/1/30.
//  Copyright © 2016年 xinye lei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *Title;
@property (weak, nonatomic) IBOutlet UILabel *date_language;
@property (weak, nonatomic) IBOutlet UILabel *rate;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *movieID;
@end
