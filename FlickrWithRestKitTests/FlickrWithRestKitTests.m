//
//  FlickrWithRestKitTests.m
//  FlickrWithRestKitTests
//
//  Created by Michael on 10/2/15.
//  Copyright (c) 2015 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "TestTableViewController.h"
#import "FlickrServer.h"
#import "Photo.h"

@interface FlickrWithRestKitTests : XCTestCase

@property (nonatomic, strong) TestTableViewController *testTableViewController;
@property (nonatomic, strong) FlickrServer *flickrServer;


@end

@interface FlickrServer (Test)

- (void)downLoadPhotos:(NSArray *)photosObjectsArray WithCompletionBlock:(void(^)(NSMutableDictionary *uiImageDictionary))completionBlock;

@property (nonatomic, strong) NSMutableArray *photosObjectArray;

@end


@implementation FlickrWithRestKitTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.

    self.testTableViewController = [[TestTableViewController alloc] init];
    self.flickrServer = [[FlickrServer alloc] init];
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testRestKitQueryIsValid{
    
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"Starting RestKit and Query photo objects"];
    
    [self.flickrServer queryPhotosWithCompletionBlock:^(NSArray *photosObjectArray) {
        if(photosObjectArray){
            NSLog(@"photosObjectArray = %@", photosObjectArray.description);
            [completionExpectation fulfill];
            
        }
    }];

    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testRestKitQueryReturnedPhotoObject{
    
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"Starting RestKit and Query one photo object"];
    [self.flickrServer queryPhotosWithCompletionBlock:^(NSArray *photosObjectArray) {
        Photo *photoObject = photosObjectArray[0];
        
        if(photoObject.title){
            NSLog(@"photosArray Object in XCTest = %@", photoObject.title);
            [completionExpectation fulfill];
        }
        
    }];

    [self waitForExpectationsWithTimeout:5.0 handler:nil];
    
}


- (void)testRestKitReturnPageIsTen{
    
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"Starting RestKit and Query 10 photo objects"];
    
    [self.flickrServer queryPhotosWithCompletionBlock:^(NSArray *photosObjectArray) {
        int pageLength = (int)photosObjectArray.count;
        
        if(pageLength==10){
            NSLog(@"photosArray size = %d", pageLength);
            [completionExpectation fulfill];
        }
        
    }];
    
    
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
    
}

- (void)testDownloadOnePhotoImageFileExist{
    
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"Starting download 1 photo imageFile"];
    
    __block NSArray *testPhotosObjectArray;
    //NSMutableDictionary *testUIImageDictionary = [[NSMutableDictionary alloc] init];
    [self.flickrServer queryPhotosWithCompletionBlock:^(NSArray *photosObjectArray) {
        testPhotosObjectArray = photosObjectArray;
        
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

- (void)testDownloadOnePhotoImageFileThanCreateUIImageWithFirstPhoto{
    
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"Starting download 1 photo imageFile than create UIImage"];
    
    __block NSArray *testPhotosObjectArray;
    [self.flickrServer queryPhotosWithCompletionBlock:^(NSArray *photosObjectArray) {
        testPhotosObjectArray = photosObjectArray;
        
        [self.flickrServer downLoadPhotos:testPhotosObjectArray WithCompletionBlock:^(NSMutableDictionary *uiImageDictionary) {
            UIImage *image = uiImageDictionary[@0];
            
            if(image){
                NSLog(@"UIImage is %@", image.description);
                [completionExpectation fulfill];
            }
        }];
        
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
    
}


- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
