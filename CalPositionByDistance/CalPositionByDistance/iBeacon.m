//
//  iBeacon.m
//  CalPositionByDistance
//
//  Created by Lc on 15/3/8.
//  Copyright (c) 2015年 Lc. All rights reserved.
//


#import "iBeacon.h"

@implementation iBeacon

- (id)initWithLocation:(NSString*)x y:(NSString*)y
{
    self = [super init];
    
    if (self) {
        self.x = x;
        self.y = y;
    }
    
    return self;
}

@end
