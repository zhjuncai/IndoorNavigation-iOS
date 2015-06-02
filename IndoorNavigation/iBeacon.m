//
//  iBeacon.m
//  CalPositionByDistance
//
//  Created by Lc on 15/3/8.
//  Copyright (c) 2015年 Lc. All rights reserved.
//


#import "iBeacon.h"

@implementation iBeacon

- (id)initWithLocation:(NSString*)x y:(NSString*)y idStr:(NSString*)str
{
    self = [super init];
    
    if (self) {
        self.x = x;
        self.y = y;
        self.idStr = str;
    }
    
    return self;
}

-(NSString*)getIdStr{
    return self.idStr;
}

-(NSString*)getX{
    return self.x;
}

-(NSString*)getY{
    return self.y;
}
@end
