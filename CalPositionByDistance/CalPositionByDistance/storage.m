//
//  UIButton+storage.m
//  CalPositionByDistance
//
//  Created by Lc on 15/3/8.
//  Copyright (c) 2015年 Lc. All rights reserved.
//

#import "storage.h"

@implementation storage

- (id)init:(CGRect)frame angle:(float)angle keyPoint:(int)index name:(NSString*)name{
    
    self = [super init];
    self.frame = frame;
    self.backgroundColor = [UIColor blackColor];
    self.transform = CGAffineTransformMakeRotation(angle);
    self.tag = index;
    [self setTitle:name forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    return self;
}


@end