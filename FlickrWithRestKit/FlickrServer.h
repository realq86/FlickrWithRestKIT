//
//  FlickrServer.h
//  FlickrWithRestKit
//
//  Created by Michael on 10/2/15.
//  Copyright (c) 2015 Michael. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlickrServer : NSObject


//setFlickrAPI to desired APIKey after init. A system default API key will be set at time of [Flickr init].
- (NSString *) setFlickrAPIKey:(NSString *)string;

/*API call to Query for a Dictionary of Photos with Flickr API Method:flickr.interestingness.getList
A default photo size of "m" medium will be set if photoSize is nil.  Default pagesize is 10 if pageSize is nil or greater than 100.
Use Block to access the array of JSON Photo class object with photoOjbectArray after thread completes.*/
- (void)methodFlickrInterestingnessGetListAtSize:(NSString *)photoSize perPageSize:(NSString *)pageSize withBlock:(void(^)(NSError *error, NSArray *photoObjectsArray))block;

/*API call to Query for a Dictionary of Photos with Flickr API Method:flickr.photos.recent
A default photo size of "m" medium will be set if photoSize is nil.  Default pagesize is 10 if pageSize is nil or greater than 100.
Use Block to access the array of JSON Photo class object with photoOjbectArray after thread completes.*/
- (void)methodFlickrPhotosRecentAtSize:(NSString *)photoSize perPageSize:(NSString *)pageSize withBlock:(void(^)(NSError *error, NSArray *photoObjectsArray))block;


/*Method that downloads the photo data from the URL obtained from the Query method above and create a Dictionary of UIImage to be returned in the block after thread completes.*/
- (void)downLoadPhotos:(NSArray *)photosObjectsArray WithCompletionBlock:(void(^)(NSMutableDictionary *uiImageDictionary))completionBlock;

//This methods use RESTKit framework and is not completed.
- (void) queryPhotosWithCompletionBlock:(void (^)(NSArray *photosObjectArray))completionBlock;

@end
