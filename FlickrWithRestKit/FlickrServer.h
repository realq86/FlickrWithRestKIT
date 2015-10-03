//
//  FlickrServer.h
//  FlickrWithRestKit
//
//  Created by Michael on 10/2/15.
//  Copyright (c) 2015 Michael. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlickrServer : NSObject


- (void) queryPhotosWithCompletionBlock:(void (^)(NSArray *photosObjectArray))completionBlock;
- (void)downLoadPhotos:(NSArray *)photosObjectsArray WithCompletionBlock:(void(^)(NSMutableDictionary *uiImageDictionary))completionBlock;


@end
