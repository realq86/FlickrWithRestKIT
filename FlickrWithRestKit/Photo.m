//
//  Photo.m
//  FoursquareExcercise
//
//  Created by Michael on 10/1/15.
//  Copyright (c) 2015 Michael. All rights reserved.
//

#import "Photo.h"

@implementation Photo

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.title forKey:@"bookMarkName"];
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super init];
    
    if(self){
        
        _title = [aDecoder decodeObjectForKey:@"bookMarkName"];
        
    }
    
    return self;
    
}

@end
