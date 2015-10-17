//
//  InterestingCollectionViewController.m
//  FlickrWithRestKit
//
//  Created by Michael on 10/4/15.
//  Copyright (c) 2015 Michael. All rights reserved.
//

#import "InterestingCollectionViewController.h"
#import "ParentCollectionViewCell.h"
#import "DetailViewController.h"


@interface InterestingCollectionViewController ()
@property (nonatomic) NSArray *photoObjectsArray;
@property (nonatomic) Photo *selectedPhotoObject;


@end

@implementation InterestingCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Set UI of Navigationbar.
    self.navigationItem.title = @"Interesting";
    self.navigationController.navigationBar.backgroundColor = [UIColor blueColor];
    
    //Instanciate FlickrServer instance, and load 20 photos at the designated photoSize
    FlickrServer *flickrServer = [FlickrServer sharedInstance];
    [flickrServer setValidPageSize:@"20"];
    [flickrServer setValidPageIndex:self.pageIndex];
    
    //Call Flickr API with method Interesting
    [flickrServer flickrInterestingnessGetListAtSize:self.photoSize withBlock:^(NSError *error, NSArray *photoObjectsArray)
     {
         //Store the downloaded Photo Object to notify the next ViewController.
         self.photoObjectsArray = photoObjectsArray;
         
         //Use the result URL from method Interesting to fetch image data
         [flickrServer downLoadPhotos:self.photoObjectsArray WithCompletionBlock:^(NSMutableDictionary *uiImageDictionary) {
 
             //Set the designated data back for tableview.
             self.uiImageDictionary = uiImageDictionary;
             [self.collectionView reloadData];
         }];
     }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
