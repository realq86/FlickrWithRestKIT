//
//  MainViewController.m
//  FlickrWithRestKit
//
//  Created by Michael on 10/5/15.
//  Copyright (c) 2015 Michael. All rights reserved.
//

#import "MainViewController.h"
#import "RecentCollectionViewController.h"
#import "InterestingCollectionViewController.h"

@interface MainViewController ()

@property (nonatomic) NSString *pageNumber;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Set UI of Navigationbar.
    self.navigationController.navigationBar.backgroundColor = [UIColor blueColor];
    self.navigationItem.title = @"Flickr Browser!";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    //Set the photoSize property of the destination ViewController before segue.
    ParentCollectionViewController *viewController = [segue destinationViewController];
    
    if([[segue identifier] isEqualToString:@"segueToRecentLowRes"] || [[segue identifier] isEqualToString:@"segueToInterestingLowRes"]){
        viewController.photoSize = @"m";
        viewController.pageIndex = self.pageNumber;
        NSLog(@"setting size to t");
    }
    
    if([[segue identifier] isEqualToString:@"segueToRecentHiRes"] || [[segue identifier] isEqualToString:@"segueToInterestingHiRes"]){
        viewController.photoSize = @"z";
        viewController.pageIndex = self.pageNumber;

        NSLog(@"setting size to m");
    }
    
    
}


- (IBAction)pageNumberControlAction:(id)sender {
    
        
    self.pageNumber = @(self.pageNumberControl.selectedSegmentIndex+1);
    
    
}








@end
