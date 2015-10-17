//
//  DetailViewController.m
//  FlickrWithRestKit
//
//  Created by Michael on 10/17/15.
//  Copyright © 2015 Michael. All rights reserved.
//

#import "DetailViewController.h"
#import "FlickrServer.h"
@interface DetailViewController ()

@property (nonatomic) NSDictionary *uiImageDictionary;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Instanciate FlickrServer instance, and load 20 photos at the designated photoSize
    FlickrServer *flickrServer = [FlickrServer sharedInstance];

    //Update the photosize to download to "z" = large
    self.photoObject.photoSize = @"z";
    
    //Download photo using the URL in Photo class
    [flickrServer downLoadPhotos:@[self.photoObject] WithCompletionBlock:^(NSMutableDictionary *uiImageDictionary) {
        
        self.uiImageDictionary = uiImageDictionary;
        self.fullScreenImage.image = self.uiImageDictionary[@0];

    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)savePhotoButtonPressed:(id)sender {
    
    //Confirm to user photo will be saved with option to cancel.
    UIAlertController *confirmSave = [UIAlertController alertControllerWithTitle:@"Save photo --"
                                                                         message:@"to camera roll?"
                                                                  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              [self savePhoto];
                                                          }];
    UIAlertAction *refuseAction = [UIAlertAction actionWithTitle:@"NO"
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              
                                                          }];
    [confirmSave addAction:defaultAction];
    [confirmSave addAction:refuseAction];

    [self presentViewController:confirmSave animated:YES completion:nil];
    
}

//Save Photo to camera roll
- (void)savePhoto{
    UIImageWriteToSavedPhotosAlbum(self.fullScreenImage.image, nil, nil, nil);
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
