//
//  TableViewController.m
//  Convenient Calculator
//
//  Created by xinye lei on 16/1/19.
//  Copyright © 2016年 xinye lei. All rights reserved.
//

#import "TableViewController.h"
#import "Yahoo.h"
#import "CollectionViewCell.h"
#import "CollectionViewController.h"

@interface TableViewController () <UISearchBarDelegate, UISearchControllerDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *SearchBar;
@property (strong, nonatomic) NSArray *list;
@end

@implementation TableViewController

static NSString * const keyForSavedPlaces = @"savedPlaces";
static NSString * const keyForSavedId = @"savedId";

- (void)setList:(NSArray *)list {
    _list = list;
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.SearchBar.delegate = self;
    self.SearchBar.placeholder = @"type city name";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (NSArray *)queryPlaces: (NSString *)place {
    NSURL *url = [Yahoo URLForPlaces:place];
    NSDictionary *res = [Yahoo getDictByURL:url];
    NSArray *list = nil;
    if (res) {
        list = [res valueForKeyPath:PLACES_ARRAY];
    }
    return list;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.list) {
        return 0;
    }
    return [self.list count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSString *admin1 = [self.list[indexPath.row] valueForKeyPath:ADMIN1];
    NSString *name = [self.list[indexPath.row] valueForKeyPath:NAME];
    NSString *country = [self.list[indexPath.row] valueForKeyPath:COUNTRY];
    NSString *dis = [NSString stringWithFormat:@"%@, %@, %@", name, admin1, country];
    cell.textLabel.text = dis;
    // Configure the cell...
    
    return cell;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    dispatch_queue_t fetchQ = dispatch_queue_create("fetch", NULL);
    dispatch_async(fetchQ, ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        NSArray *newList = [self queryPlaces:searchText];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.list = newList;
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        });
    });
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewController *collectionViewController = self.navigationController.viewControllers[0];
    UICollectionView *view = (UICollectionView *)collectionViewController.collectionView;
    CollectionViewCell *cell = (CollectionViewCell *)[view cellForItemAtIndexPath:self.index];
    NSInteger woeid = [[self.list[indexPath.row] valueForKeyPath:PLACE_WOEID] integerValue];
    cell.Woeid = woeid;
    UITableViewCell *tvcell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.displayLocation = tvcell.textLabel.text;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *placeArray = [defaults objectForKey:keyForSavedPlaces];
    NSArray *idArray = [defaults objectForKey:keyForSavedId];
    NSMutableArray *mutPlaceArray = placeArray.mutableCopy;
    NSMutableArray *mutId = idArray.mutableCopy;
    [mutPlaceArray replaceObjectAtIndex:self.index.row withObject:cell.displayLocation];
    [mutId replaceObjectAtIndex:self.index.row withObject:[NSString stringWithFormat:@"%ld", (long)cell.Woeid]];
    [defaults setObject:mutPlaceArray forKey:keyForSavedPlaces];
    [defaults setObject:mutId forKey:keyForSavedId];
    
    [self.navigationController popViewControllerAnimated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}


@end
