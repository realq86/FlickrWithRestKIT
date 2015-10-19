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
#define kNUMBER_PER_PAGE_DEFAULT @"10"
#define kSEARCH_TERMS @"Cats"
#define kPHOTO_SIZE_DEFAULT @"m"
#define kPHOTO_SIZE_THUMBNAIL @"t"

@interface FlickrServer()
@property (nonatomic, strong) NSString *apiKey;
@property (nonatomic, strong) NSMutableArray *photosObjectArray;
@property (nonatomic, strong) NSMutableDictionary *uiImageDictionary;
@property (nonatomic, strong) NSString *perPageSize;
@property (nonatomic, strong) NSString *pageIndex;
@end

@implementation FlickrServer

//Let FlickrServer act like a Singleton
+ (FlickrServer *)sharedInstance{
    
    static FlickrServer *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[FlickrServer alloc] init];
    });
    return _sharedInstance;
    
}

- (instancetype)init{
    self = [super init];
    
    //Set default API Key and PageSize
    [self setFlickrAPIKey:kCLIENTID];
    [self setValidPageSize:kNUMBER_PER_PAGE_DEFAULT];

    return self;
}

- (NSString *)setFlickrAPIKey:(NSString *)apiKey{
    
    if(apiKey){
        self.apiKey = apiKey;
        return self.apiKey;
    }
    else{
        self.apiKey = kCLIENTID;
        return @"Default API Key is used";
    }
}

+ (NSString *)checkValidPhotoSizes:(NSString *)photoSize{
    //Check if PhotoSizes paramater is valid or set default
    NSArray* validPhotoSizes = [NSArray arrayWithObjects: @"s", @"m", @"z",@"t", nil];
    if(![validPhotoSizes containsObject:photoSize]){
        photoSize = kPHOTO_SIZE_DEFAULT;
    }
    return photoSize;
}


- (void)setValidPageSize:(NSString *)pageSize{
    
    //Check if pageSize is valid or set default
    if(pageSize.intValue>100 || !pageSize){
        pageSize=kNUMBER_PER_PAGE_DEFAULT;
    }
    
    self.perPageSize = pageSize;

}

- (void)setValidPageIndex:(NSString *)pageIndexInput{
    if(!pageIndexInput)
        pageIndexInput = @"1";
    
    self.pageIndex = pageIndexInput;
    
}

//Public API for Flickr API method: flickr.interesting.getList
- (void)flickrInterestingnessGetListAtSize:(NSString *)photoSize withBlock:(void(^)(NSError *error, NSArray *photoObjectsArray))block{
    
    NSLog(@"ClientID is %@", self.apiKey);
    //Check if PhotoSizes paramater is valid or set default
    photoSize = [FlickrServer checkValidPhotoSizes:photoSize];

    
    //Query with method flickr.interestingness.getList
    NSString *queryURL = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.interestingness.getList&api_key=%@&per_page=%@&page=%@&format=json&nojsoncallback=1", self.apiKey, self.perPageSize, self.pageIndex];
    
    [self queryWith:(NSString *)queryURL WithPhotoSize:photoSize withBlock:^(NSError *error, NSArray *photoObjectsArray) {
        if(!error){
            block(nil, photoObjectsArray);
        }
        else{
            block(error, nil);
        }
    }];

}

//Public API for Flickr API method: flackr.photos.recent
- (void)flickrPhotosRecentAtSize:(NSString *)photoSize withBlock:(void(^)(NSError *error, NSArray *photoObjectsArray))block{
    
    //Check if PhotoSizes paramater is valid or set default
    photoSize = [FlickrServer checkValidPhotoSizes:photoSize];
    
    //Query with method flickr.photos.getRecent
    NSString *queryURL = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=%@&per_page=%@&page=%@&format=json&nojsoncallback=1", self.apiKey, self.perPageSize, self.pageIndex];

    [self queryWith:(NSString *)queryURL WithPhotoSize:photoSize withBlock:^(NSError *error, NSArray *photoObjectsArray) {
        if(!error){
            block(nil, photoObjectsArray);
        }
        else{
            block(error, nil);
        }
    }];
    
}


//Method to obtain photos URL into an array of UIImages with respected Query.
- (void)queryWith:(NSString *)queryURL WithPhotoSize:(NSString *)photoSize withBlock:(void(^)(NSError *error, NSArray *photoObjectsArray))block{
    
    //Get a queue thats not the main queue
    dispatch_queue_t queryQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //start downloading the images on the newly created queue asyncly.
    dispatch_async(queryQueue, ^{
        
        //Fetch the JSON data with Query
        NSError *errorFromStringWithContentOfURL = nil;
        NSString *queryResult = [NSString stringWithContentsOfURL:[NSURL URLWithString:queryURL]
                                                         encoding:NSUTF8StringEncoding
                                                            error:&errorFromStringWithContentOfURL];
        if(errorFromStringWithContentOfURL != nil){
            block(errorFromStringWithContentOfURL, nil);
        }
        else{
            
            //Serialize a JSON data into a NSDictionary
            NSError *errorFromJSONSerialization = nil;
            NSData *jsonDataFromQuery = [queryResult dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonObjectsDictionary = [NSJSONSerialization JSONObjectWithData:jsonDataFromQuery
                                                                                  options:kNilOptions
                                                                                    error:&errorFromJSONSerialization];
            
            if(errorFromJSONSerialization != nil){
                block(errorFromJSONSerialization, nil);
            }
            else{
                //Obtain the photos array from a JSON dictionary of a list of photos.
                NSArray *jsonObjectArray = jsonObjectsDictionary[@"photos"][@"photo"];
                NSString *pageNumber = jsonObjectsDictionary[@"photos"][@"page"];
                NSLog(@"pageNumber %@", pageNumber);
                NSLog(@"jsonObjectDictionary = %@", jsonObjectsDictionary.description);
                
                self.photosObjectArray  = [[NSMutableArray alloc] init];
                
                for(NSMutableDictionary *photoObject in jsonObjectArray){
                    
                    //Mapping of JSON object's property to local custom class Photo
                    NSLog(@"photoObject is %@", photoObject.description);
                    Photo *photo = [[Photo alloc] init];
                    photo.title = photoObject[@"title"];
                    photo.farm = [photoObject[@"farm"] intValue];
                    photo.server = [photoObject[@"server"] intValue];
                    photo.photoID = [photoObject[@"id"] longLongValue];
                    photo.server = [photoObject[@"server"] intValue];
                    photo.photoSize = photoSize;
                    photo.owner = photoObject[@"owner"];
                    photo.secret = photoObject[@"secret"];
                    photo.isfamily = [photoObject[@"isfamily"] intValue];
                    photo.isfriend = [photoObject[@"isfriend"] intValue];
                    photo.ispublic = [photoObject[@"ispublic"] intValue];
                    [self.photosObjectArray addObject:photo];
                }
                
                dispatch_queue_t mainQueue = dispatch_get_main_queue();
                dispatch_async(mainQueue, ^{
                    NSLog(@"photoObjectsArray is %@", self.photosObjectArray.description);
                    block(nil, self.photosObjectArray);
                });
                
            }
        }
    });
}

#pragma RESTKitCode
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
                                  @"per_page" : kNUMBER_PER_PAGE_DEFAULT,
                                  @"text" : kSEARCH_TERMS
                                  };
    
    //Send JSON Query to Flickr with CompletionBlock that returns self.photoObjectArray to ViewController
    [[RKObjectManager sharedManager] getObjectsAtPath:KSEARCH_METHOD
                                           parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
                                                  
                                                  self.photosObjectArray = [mappingResult.array mutableCopy];
                                                  completionBlock(self.photosObjectArray);
                                              
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"Error =  %@", error);
                                              }];
    //NSLog(@"End of method!!!!");
    
}


#pragma flickr Download Methods regardless of RESTKit or not.

//Convert Photo Object created from JSON Query into Flickr image data request URL.
- (NSString *)flickrPhotoURLForFlickrPhoto:(Photo *) flickrPhoto size:(NSString *) size
{
    if(!size)
    {
        size = kPHOTO_SIZE_DEFAULT;
    }
    return [NSString stringWithFormat:@"https://farm%d.staticflickr.com/%d/%lld_%@_%@.jpg",flickrPhoto.farm,flickrPhoto.server,flickrPhoto.photoID,flickrPhoto.secret,size];
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
                
                Photo *photo = photosObjectsArray[i];
                
                NSString *fileFromImageURL = [self flickrPhotoURLForFlickrPhoto:photo size:photo.photoSize];
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
