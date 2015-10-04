//
//  RecentViewController.m
//  FlickrWithRestKit
//
//  Created by Michael on 10/3/15.
//  Copyright (c) 2015 Michael. All rights reserved.
//

#import "RecentViewController.h"

@interface RecentViewController ()

@end

@implementation RecentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.uiImageDictionary = [[NSMutableDictionary alloc] init];
    
    FlickrServer *flickrServer = [FlickrServer sharedInstance];
    
    [flickrServer setValidPageSize:@"10"];
    
    [flickrServer flickrPhotosRecentAtSize:@"t" withBlock:^(NSError *error, NSArray *photoObjectsArray) {
        
        [flickrServer downLoadPhotos:photoObjectsArray WithCompletionBlock:^(NSMutableDictionary *uiImageDictionary) {
            
            self.uiImageDictionary = uiImageDictionary;
            [self.tableView reloadData];

            NSLog(@"uiImageDictinary = %@", self.uiImageDictionary.description);
            
        }];
        
        
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecentTableViewCellID" forIndexPath:indexPath];
    
    // Configure the cell...
    
    cell.imageView.image = [self.uiImageDictionary objectForKey:@(indexPath.row)];
    
    return cell;
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
