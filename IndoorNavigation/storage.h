//
//  storage.h
//  CalPositionByDistance
//
//  Created by Lc on 15/3/8.
//  Copyright (c) 2015年 Lc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface storage: UIButton
@property  (nonatomic) BOOL isChosen;
@property (nonatomic) NSInteger position;


- (id)init:(CGRect)frame angle:(float)angle keyPoint:(int)index name:(NSString*)name;


@end
