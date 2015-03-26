//
//  NSObject+NaviAlgo.h
//  Navi
//
//  Created by Chen on 15/3/14.
//  Copyright (c) 2015年 Chen. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface NaviAlgo:NSObject{
    int myGraph[28][28]; //原图经过转换后的完全图，值为最短路径长度
    int myPointsPosition[28][2];
    int MAX ;
    int LEFT;
    int RIGHT;
    int UP;
    int DOWN;
    int spot[28][28];
    int onePath[28];
    NSMutableArray* pathForEachTwoPoints[28][28];//任意两点间的最短路径，值为最短路径经过点
    
    int shortestLength;//寻址后的最短路径长度
    NSMutableArray* bestPath;//寻址后的最短路径经过点
}

-(void) setGraph:(int[28][28])graph;
-(void) setPointMapping:(int[28][2]) pointsPosition;
-(NSMutableArray *) getBestPathForDestinations:(NSMutableArray *)destinationArray;
-(int) getShortestLength;

@end
