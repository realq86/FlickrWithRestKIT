//
//  InterestingCollectionViewController.m
//  FlickrWithRestKit
//
//  Created by Michael on 10/4/15.
//  Copyright (c) 2015 Michael. All rights reserved.
//

#import "InterestingCollectionViewController.h"
#import "ParentCollectionViewCell.h"



@interface InterestingCollectionViewController ()

@end

@implementation InterestingCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Set UI of Navigationbar.
    self.navigationItem.title = @"Interesting";
    self.navigationController.navigationBar.backgroundColor = [UIColor blueColor];

    
}

- (void)viewWillAppear:(BOOL)animated{
    
    //Instanciate FlickrServer instance, and load 20 photos at the designated photoSize
    FlickrServer *flickrServer = [FlickrServer sharedInstance];
    [flickrServer setValidPageSize:@"20"];
    [flickrServer setValidPageIndex:self.pageIndex];
    [flickrServer flickrInterestingnessGetListAtSize:self.photoSize withBlock:^(NSError *error, NSArray *photoObjectsArray)
    {
        [flickrServer downLoadPhotos:photoObjectsArray WithCompletionBlock:^(NSMutableDictionary *uiImageDictionary) {
            self.uiImageDictionary = uiImageDictionary;
            [self.collectionView reloadData];
        }];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
