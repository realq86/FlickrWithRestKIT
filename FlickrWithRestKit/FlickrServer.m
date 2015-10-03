//
//  FlickrServer.m
//  FlickrWithRestKit
//
//  Created by Michael on 10/2/15.
//  Copyright (c) 2015 Michael. All rights reserved.
//

#import "FlickrServer.h"
#import "Photo.h"
#import <RestKit/RestKit.h>


#define kCLIENTID @"3aef0af22db128b3a378810bc873987a"
#define kCLIENTSECRET @"c1be9c06c4eafb18"
#define kBASE_URL @"https://api.flickr.com/services/rest"
#define kGET_RECENT_METHOD @"?method=flickr.photos.getRecent"
#define KSEARCH_METHOD @"?method=flickr.photos.search"
#define kNUMBER_PER_PAGE @"10"
#define kSEARCH_TERMS @"Cats"
#define kPHOTO_SIZE_M @"m"
#define kPHOTO_SIZE_THUMBNAIL @"t"


@interface FlickrServer()

@property (nonatomic, strong) NSArray *photosObjectArray;
@property (nonatomic, strong) NSMutableDictionary *uiImageDictionary;

@end


@implementation FlickrServer

- (void) configureRestKit {
    
    
    //initialize AFNetworking HTTPClient
    NSURL *baseURL = [NSURL URLWithString:kBASE_URL];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    // initialize RestKit
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    // setup object mappings
    RKObjectMapping *photoMapping = [RKObjectMapping mappingForClass:[Photo class]];
    [photoMapping addAttributeMappingsFromDictionary:@{@"title" : @"title" ,
                                                       @"farm" : @"farm",
                                                       @"server" : @"server",
                                                       @"id" : @"photoID",
                                                       @"secret" : @"secret"}];
    
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:photoMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:@""
                                                keyPath:@"photos.photo"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [objectManager addResponseDescriptor:responseDescriptor];
}


- (void) queryPhotosWithCompletionBlock:(void (^)(NSArray *photosObjectArray))completionBlock{
    [self configureRestKit];
    
    NSString *clientID = kCLIENTID;
    //NSString *clientSecret = kCLIENTSECRET;
    
    NSDictionary *queryParams = @{@"nojsoncallback" : @"1",
                                  @"api_key" : clientID,
                                  @"format" : @"json",
                                  @"per_page" : kNUMBER_PER_PAGE,
                                  @"text" : kSEARCH_TERMS
                                  };
    
    //Send JSON Query to Flickr with CompletionBlock that returns self.photoObjectArray to ViewController
    [[RKObjectManager sharedManager] getObjectsAtPath:KSEARCH_METHOD
                                           parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
                                                  
                                                  self.photosObjectArray = mappingResult.array;
                                                  completionBlock(self.photosObjectArray);
                                              
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"Error =  %@", error);
                                              }];
    //NSLog(@"End of method!!!!");
    
}

//Convert Photo Object created from JSON Query into Flickr image data request URL.
- (NSString *)flickrPhotoURLForFlickrPhoto:(Photo *) flickrPhoto size:(NSString *) size
{
    if(!size)
    {
        size = kPHOTO_SIZE_M;
    }
    return [NSString stringWithFormat:@"http://farm%d.staticflickr.com/%d/%lld_%@_%@.jpg",flickrPhoto.farm,flickrPhoto.server,flickrPhoto.photoID,flickrPhoto.secret,size];
}


//Downloads array of Photo Objects from JSON Query and returns a Dictionary of UIImages in Completion Block
- (void)downLoadPhotos:(NSArray *)photosObjectsArray WithCompletionBlock:(void(^)(NSMutableDictionary *uiImageDictionary))completionBlock{
    if(!photosObjectsArray || photosObjectsArray.count == 0){
        NSLog(@"photosObjectArray in downLoadPhotos:WithCompletionBlock: is nil");
        completionBlock(nil);
    }
    else{
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            
            self.uiImageDictionary = [[NSMutableDictionary alloc] init];
            
            for(int i=0; i<photosObjectsArray.count; i++){
                NSString *fileFromImageURL = [self flickrPhotoURLForFlickrPhoto:photosObjectsArray[i] size:kPHOTO_SIZE_THUMBNAIL];
                NSLog(@"fileFromImageURL = %@", fileFromImageURL.description);
                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileFromImageURL]
                                                          options:0
                                                            error:nil];
                
                UIImage *image = [UIImage imageWithData:imageData];
                
                [self.uiImageDictionary setObject:image forKey:@(i)];
                
            }
            
            dispatch_queue_t mainQueue = dispatch_get_main_queue();
            dispatch_async(mainQueue, ^{
                completionBlock(self.uiImageDictionary);
            });

        });
        
    }
    
}



@end
