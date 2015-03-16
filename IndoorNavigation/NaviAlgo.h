//
//  NSObject+NaviAlgo.h
//  Navi
//
//  Created by Chen on 15/3/14.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NaviAlgo:NSObject{
    int myGraph[42][42];
    NSMutableArray* pathForEachTwoPoints[42][42];
    int shortestLength;
    NSMutableArray* bestPath;
}


-(NSMutableArray *) getBestPathForGraph:(int[42][42])graph withDestinations:(NSMutableArray *)destinationArray;
-(int) getShortestLength;

@end
