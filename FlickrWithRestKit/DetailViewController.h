//
//  DetailViewController.h
//  FlickrWithRestKit
//
//  Created by Michael on 10/17/15.
//  Copyright © 2015 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"

@interface DetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *fullScreenImage;
@property (nonatomic) Photo *photoObject;

@end
