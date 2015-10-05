//
//  ParentCollectionViewController.h
//  FlickrWithRestKit
//
//  Created by Michael on 10/4/15.
//  Copyright (c) 2015 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickrServer.h"

@interface ParentCollectionViewController : UICollectionViewController <UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableDictionary *uiImageDictionary;

@property (nonatomic) NSString *photoSize;
@property (nonatomic) NSString *pageIndex;
@end
