//
//  CollectionViewController.m
//  Convenient Calculator
//
//  Created by xinye lei on 16/1/19.
//  Copyright © 2016年 xinye lei. All rights reserved.
//

#import "CollectionViewController.h"
#import "CollectionViewCell.h"
#import "TableViewController.h"
@interface CollectionViewController () <UICollectionViewDataSource, UIBarPositioningDelegate, UICollectionViewDelegateFlowLayout>

@end

@implementation CollectionViewController

static NSString * const reuseIdentifier = @"Cell";
static NSString * const keyForSavedPlaces = @"savedPlaces";
static NSString * const keyForSavedId = @"savedId";

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:keyForSavedPlaces]) {
        NSArray *placesArray = @[@"", @"", @""];
        NSArray *savedId = @[@"", @"", @""];
        [defaults setObject:placesArray forKey:keyForSavedPlaces];
        [defaults setObject:savedId forKey:keyForSavedId];
    }
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(refreshAction:) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:refresh];
    self.collectionView.alwaysBounceHorizontal = YES;
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    //[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}

- (void)refreshAction: (UIRefreshControl *)refresh {
    dispatch_queue_t fetchQ = dispatch_queue_create("fetch", NULL);
    dispatch_async(fetchQ, ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        [self.collectionView reloadData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            [refresh endRefreshing];
        });
    });
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *placeArray = [defaults objectForKey:keyForSavedPlaces];
    NSArray *idArray = [defaults objectForKey:keyForSavedId];
    if ([placeArray[indexPath.row] isEqualToString:@""]) {
        cell.displayLocation = @"";
        cell.Woeid = 0;
    }
    else {
        cell.displayLocation = placeArray[indexPath.row];
        cell.Woeid = [idArray[indexPath.row] integerValue];
    }
    // Configure the cell
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = self.view.bounds.size;
    size.height *= 0.25;
    return size;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGSize size = self.view.bounds.size;
    size.height *= 0.1;
    return size;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIButton *settingButton = (UIButton *)sender;
    UICollectionViewCell *View = (UICollectionViewCell *)[[settingButton superview] superview]; //button's
                                                                            //superview is cell.contentview
    NSIndexPath *path = [self.collectionView indexPathForCell:View];
    TableViewController *tvc = (TableViewController *)[segue destinationViewController];
    tvc.index = path;
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
