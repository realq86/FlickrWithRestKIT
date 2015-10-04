//
//  TestFlickrAPINoRESTKit.m
//  FlickrWithRestKit
//
//  Created by Michael on 10/3/15.
//  Copyright (c) 2015 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "FlickrServer.h"

@interface TestFlickrAPINoRESTKit : XCTestCase

@property (nonatomic, strong) FlickrServer *flickrServer;

@end

@interface FlickrServer (Test)

@property (nonatomic, strong) NSString *apiKey;

- (void)methodFlickrPhotosRecentAtSize:(NSString *)photoSize perPageSize:(NSString *)pageSize withBlock:(void(^)(NSError *, NSString *message))block;

@end

@implementation TestFlickrAPINoRESTKit

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.flickrServer = [[FlickrServer alloc] init];
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


//Testing if the FlickrAPIKey is set
- (void)testSetAPIKey{
        
    NSString *defaultAPI = [self.flickrServer setFlickrAPIKey:@"d5c7df3552b89d13fe311eb42715b510"];
    
    XCTAssertEqual(defaultAPI, @"d5c7df3552b89d13fe311eb42715b510", @"API Key is set to default");
}


- (void)testmethodFlickrPhotosRecentAtSizePerPageSizeWithBlock{
    
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"Query for Recent and expect a page of UIImage"];
    
    [self.flickrServer methodFlickrPhotosRecentAtSize:@"t" withBlock:^(NSError *error, NSArray *photoObjectsArray){
        if(!error && photoObjectsArray.count == 10){
            
                NSLog(@"message = %@", [photoObjectsArray description]);
                [completionExpectation fulfill];

            
        }
        else
            NSLog(@"Error is %@", error);
        
        
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testDownloadOnePhotoImageFileExist{
    
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"Starting download 1 photo imageFile"];
        __block NSArray *testPhotosObjectArray;
    [self.flickrServer methodFlickrPhotosRecentAtSize:@"t" withBlock:^(NSError *error, NSArray *photoObjectsArray) {
        
        testPhotosObjectArray = photoObjectsArray;
        
        [self.flickrServer downLoadPhotos:testPhotosObjectArray WithCompletionBlock:^(NSMutableDictionary *uiImageDictionary) {
            if(uiImageDictionary){
                
                NSLog(@"uiImageDictionary is %@", uiImageDictionary.description);
                [completionExpectation fulfill];
            }
            else{
                NSLog(@"uiImageDictionary is nil");
            }
            
        }];

        
    }];
    

    
    
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
    
}



@end
