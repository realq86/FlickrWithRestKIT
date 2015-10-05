//
//  RecentCollectionViewController.m
//  FlickrWithRestKit
//
//  Created by Michael on 10/4/15.
//  Copyright (c) 2015 Michael. All rights reserved.
//

#import "RecentCollectionViewController.h"
#import "ParentCollectionViewCell.h"
#define kCLIENTID @"d5c7df3552b89d13fe311eb42715b510"


@interface RecentCollectionViewController ()

@end

@implementation RecentCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Set UI of Navigationbar.
    self.navigationItem.title = @"getRecent";
    self.navigationController.navigationBar.backgroundColor = [UIColor redColor];

}

- (void)viewWillAppear:(BOOL)animated{
    
    //Instanciate FlickrServer instance, and load 20 photos at the designated photoSize
    FlickrServer *flickrServer = [FlickrServer sharedInstance];
    [flickrServer setFlickrAPIKey:kCLIENTID];
    [flickrServer setValidPageSize:@"20"];
    [flickrServer setValidPageIndex:self.pageIndex];
    [flickrServer flickrPhotosRecentAtSize:self.photoSize withBlock:^(NSError *error, NSArray *photoObjectsArray) {
        [flickrServer downLoadPhotos:photoObjectsArray WithCompletionBlock:^(NSMutableDictionary *uiImageDictionary) {
            self.uiImageDictionary = uiImageDictionary;
            [self.collectionView reloadData];
        }];
    }];}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (ParentCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ParentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ParentCollectionViewCellID" forIndexPath:indexPath];
    
    // Set the uiImage inside the cell from the uiImageDictionary
    UIImage *image = [self.uiImageDictionary objectForKey:@(indexPath.row)];
    cell.imageView.image = image;
    
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
