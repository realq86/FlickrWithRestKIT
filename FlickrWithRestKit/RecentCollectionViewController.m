//
//  RecentCollectionViewController.m
//  FlickrWithRestKit
//
//  Created by Michael on 10/4/15.
//  Copyright (c) 2015 Michael. All rights reserved.
//

#import "RecentCollectionViewController.h"
#import "ParentCollectionViewCell.h"
#import "DetailViewController.h"
#import "Photo.h"

@interface RecentCollectionViewController ()

@property (nonatomic) Photo *selectedPhotoObject;
@property (nonatomic) NSArray *photoObjectsArray;

@end

@implementation RecentCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Set UI of Navigationbar.
    self.navigationItem.title = @"getRecent";
    self.navigationController.navigationBar.backgroundColor = [UIColor redColor];
    
    //Load from Flickr API
    [self callFlickrAPIWithCompletionHandler:^{
        
    }];
    
    //Pull to refresh
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(startRefresh:)
             forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:refreshControl];

}

- (void)startRefresh:(id)sender{
    [self callFlickrAPIWithCompletionHandler:^{
        [sender endRefreshing];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//Flickr API called with completionHandler
- (void)callFlickrAPIWithCompletionHandler:(void(^)(void))completion {
    
    //Instanciate FlickrServer instance, and load 20 photos at the designated photoSize
    FlickrServer *flickrServer = [FlickrServer sharedInstance];
    //[flickrServer setFlickrAPIKey:kCLIENTID];
    [flickrServer setValidPageSize:@"20"];
    [flickrServer setValidPageIndex:self.pageIndex];
    
    //Call Flickr API with method Recent
    [flickrServer flickrPhotosRecentAtSize:self.photoSize withBlock:^(NSError *error, NSArray *photoObjectsArray) {
        
        //Store the downloaded Photo Object to notify the next ViewController.
        self.photoObjectsArray = photoObjectsArray;
        
        //Use the result URL from method Recent to fetch image data
        [flickrServer downLoadPhotos:self.photoObjectsArray WithCompletionBlock:^(NSMutableDictionary *uiImageDictionary) {
            
            //Set the designated data back for tableview.
            self.uiImageDictionary = uiImageDictionary;
            [self.collectionView reloadData];
            completion();
        }];
    }];

    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //User selected a cell determin which is selected and push to next ViewController
    self.selectedPhotoObject = self.photoObjectsArray[indexPath.row];
    [self performSegueWithIdentifier:@"showDetailViewSegueID" sender:nil];
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    //Set the Photo Object to display at the next ViewController
    DetailViewController *detailViewController = [segue destinationViewController];
    detailViewController.photoObject = self.selectedPhotoObject;
    
}


@end
