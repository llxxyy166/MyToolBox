//
//  MovieCollectionHistoryVC.m
//  Convenient Calculator
//
//  Created by xinye lei on 16/2/1.
//  Copyright © 2016年 xinye lei. All rights reserved.
//

#import "MovieCollectionHistoryVC.h"
#import "MovieData.h"
#import "MovieCollectionViewCell.h"

@interface MovieCollectionHistoryVC ()
@property (strong, nonatomic) NSArray *list;
@end

@implementation MovieCollectionHistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSManagedObjectContext *context = self.managedObjectContext;
    NSFetchRequest *requet = [[NSFetchRequest alloc] initWithEntityName:@"MovieData"];
    requet.predicate = nil;
    self.list = [context executeFetchRequest:requet error:NULL];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.list count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MovieCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"movieCell" forIndexPath:indexPath];
    MovieData *movieData = self.list[indexPath.row];
    NSString *tittle = movieData.name;
    NSString *timelan = movieData.timeAndLan;
    NSString *rate = movieData.rate;
    NSData *posterData = movieData.posterImage;
    UIImage *image = [UIImage imageWithData:posterData];
    cell.Title.text = tittle;
    cell.date_language.text = timelan;
    cell.rate.text = rate;
    cell.image = image;
    cell.movieID = movieData.idNumber;
    self.imageCache[cell.movieID] = image;
    return cell;
}

- (IBAction)clearHistoryAction:(id)sender {
    if (!self.list) {
        return;
    }
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    for (MovieData *data  in self.list) {
        [managedObjectContext deleteObject:data];
    }
    self.list = nil;
    [self.collectionView reloadData];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
