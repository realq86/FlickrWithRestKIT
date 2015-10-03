//
//  Photo.h
//  FoursquareExcercise
//
//  Created by Michael on 10/1/15.
//  Copyright (c) 2015 Michael. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Photo : NSObject <NSCoding>

@property (nonatomic, strong) NSString *title;
@property (nonatomic) NSInteger farm;
@property (nonatomic) NSInteger server;
@property (nonatomic) long long photoID;
@property (nonatomic, strong) NSString *secret;

@end
