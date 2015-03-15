//
//  iBeacon.h
//  CalPositionByDistance
//
//  Created by Lc on 15/3/8.
//  Copyright (c) 2015年 Lc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iBeacon : NSObject

@property (strong, nonatomic) NSString *x;
@property (strong, nonatomic) NSString *y;
@property (strong, nonatomic) NSString *uuid;


-(void)setX:(NSString *)x;
-(void)setY:(NSString *)y;


@end
