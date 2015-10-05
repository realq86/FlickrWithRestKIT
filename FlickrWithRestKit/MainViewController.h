//
//  MainViewController.h
//  FlickrWithRestKit
//
//  Created by Michael on 10/5/15.
//  Copyright (c) 2015 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISegmentedControl *pageNumberControl;
- (IBAction)pageNumberControlAction:(id)sender;

@end
