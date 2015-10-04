//
//  TestTableViewController.h
//  FlickrWithRestKit
//
//  Created by Michael on 10/2/15.
//  Copyright (c) 2015 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickrServer.h"
@interface TestTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *photosObjectArray;
@property (nonatomic, strong) NSMutableDictionary *uiImageDictionary;

@end
