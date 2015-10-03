//
//  TestTableViewController.m
//  FlickrWithRestKit
//
//  Created by Michael on 10/2/15.
//  Copyright (c) 2015 Michael. All rights reserved.
//

#import "TestTableViewController.h"
#import "FlickrServer.h"

@interface TestTableViewController ()

@property (nonatomic, strong) NSArray *photosObjectArray;
@property (nonatomic, strong) NSMutableDictionary *uiImageDictionary;

@end

@implementation TestTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.uiImageDictionary = [[NSMutableDictionary alloc] init];

    FlickrServer *flickrServer = [[FlickrServer alloc] init];
    
    [flickrServer queryPhotosWithCompletionBlock:^(NSArray *photosObjectArray){
        self.photosObjectArray = photosObjectArray;
        
        [flickrServer downLoadPhotos:self.photosObjectArray WithCompletionBlock:^(NSMutableDictionary *uiImageDictionary) {
            NSLog(@"uiImageDictionary is %@", uiImageDictionary.description);
            self.uiImageDictionary = uiImageDictionary;
            [self.tableView reloadData];
        }];

    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.uiImageDictionary.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TestTableViewCellID" forIndexPath:indexPath];
    
    // Configure the cell...
    
    cell.imageView.image = [self.uiImageDictionary objectForKey:@(indexPath.row)];
    
    return cell;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
