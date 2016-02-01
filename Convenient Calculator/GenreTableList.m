//
//  GenreTableList.m
//  Convenient Calculator
//
//  Created by xinye lei on 16/1/30.
//  Copyright © 2016年 xinye lei. All rights reserved.
//

#import "GenreTableList.h"
#import "TMDb.h"
#import "MovieCollectionVC.h"
@interface GenreTableList ()

@property (strong, nonatomic) NSArray *genreArray;

@end

@implementation GenreTableList

- (NSArray *)genreArray {
    if (!_genreArray) {
        NSURL *url = [TMDb genreList];
        NSData *jsonData = [NSData dataWithContentsOfURL:url];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:NULL];
        _genreArray = dic[GENRE];
    }
    return _genreArray;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.genreArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"genreCell"];
    NSString *name = [self.genreArray[indexPath.row] valueForKey:GENRE_NAME];
    cell.textLabel.text = name;
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *path = [self.tableView indexPathForCell:sender];
        if (path) {
            if ([[segue destinationViewController] isKindOfClass:[MovieCollectionVC class]]) {
                MovieCollectionVC *vc = (MovieCollectionVC *)[segue destinationViewController];
                vc.genreID = [self.genreArray[path.row] valueForKey:GENRE_ID];
            }
        }
    }
}

@end
