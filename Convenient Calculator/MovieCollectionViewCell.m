//
//  MovieCollectionViewCell.m
//  Convenient Calculator
//
//  Created by xinye lei on 16/1/30.
//  Copyright © 2016年 xinye lei. All rights reserved.
//

#import "MovieCollectionViewCell.h"
@interface MovieCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *poster;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@end

@implementation MovieCollectionViewCell


- (void)setImage:(UIImage *)Image {
    self.poster.image = Image;
    if (Image) {
        [self.spinner stopAnimating];
    }
    else {
        [self.spinner startAnimating];
    }
    [self setNeedsDisplay];
}



@end
