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
    self.isChosen = NO;
    self.backgroundColor = [UIColor blackColor];
    self.transform = CGAffineTransformMakeRotation(angle);
    self.position =index;
    [self setTitle:name forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:@"shelf"] forState:UIControlStateNormal];
    return self;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    
    CGFloat maxX = CGRectGetMaxX(self.bounds);
    CGFloat maxY = CGRectGetMaxY(self.bounds);
    
    CGFloat titleWidth = 40.f;
    CGFloat titleHeight = 15.f;
    
    CGRect frame = CGRectMake(maxX - 45, maxY - 25, titleWidth, titleHeight);
    
    return frame;
}

@end