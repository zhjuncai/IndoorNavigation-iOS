//
//  NSObject+NaviAlgo.m
//  Navi
//
//  Created by Chen on 15/3/14.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import "NaviAlgo.h"



@implementation NaviAlgo

-(void) setGraph:(int [42][42])graph {
    
    MAX = 100000;
    LEFT = 1;
    RIGHT = -1;
    UP = 2;
    DOWN = -2;
    
    for(int i=0;i<42;i++){
        for (int j=0;j<42;j++){
            if(i==j){
                myGraph[i][j] =0;
            }
            else if(graph[i][j]==0){
                myGraph[i][j] = MAX;
            }
            else
                myGraph[i][j]= graph[i][j];
            
            spot[i][j] = -1;
        }
        
        onePath[i] = -1;
    }
    
    for(int u=0;u<42;++u){
        for (int v=0; v<42; v++) {
            for(int w=0;w<42;w++){
                if(myGraph[v][w] > myGraph[v][u] + myGraph[u][w]){
                    myGraph[v][w] = myGraph[v][u] + myGraph[u][w];
                    spot[v][w] =u;
                }
            }
        }
    }
    
    for(int i =0;i<42;i++){
        int points[1];//经过的点数
        for(int j=0;j<42;j++){
            points[0] = 0;
            onePath[points[0]++]=i;
            [self getPathForEachPoints:spot from:i to:j path:onePath numOfPoints:points];
            
            pathForEachTwoPoints[i][j] = [[NSMutableArray alloc] init];
            for(int k=0;k<points[0];k++){
                [pathForEachTwoPoints[i][j] addObject:@(onePath[k])];
            }
        }
    }
    
    
    shortestLength = MAX;
    
}

-(void) setPointMapping:(int [42][2])pointsPosition{
    for(int i=0;i<42;i++) {
        for (int j=0;j<2;j++){
          myPointsPosition[i][j] = pointsPosition[i][j];
        }
    }
}

-(void) getPathForEachPoints:(int[42][42])spots from:(int)i to:(int)j path:(int[])aPath numOfPoints:(int[])point{
    if(i==j){
        return;
    }
    
    if(spots[i][j]==-1){
        
        aPath[point[0]++] =j;
    }
    
    else{
        [self getPathForEachPoints:spots from:i to:spots[i][j] path:aPath numOfPoints:point];
        [self getPathForEachPoints:spots from:spots[i][j] to:j path:aPath numOfPoints:point];
    }
    
    
}

-(NSMutableArray *)getBestPathForDestinations:(NSMutableArray *)destinationArray{
    
    shortestLength = MAX;
    [self sortAlgoForDestinations:destinationArray toPath:[[NSMutableArray alloc] init] ];
    
    NSMutableArray* tempBestPath = [NSMutableArray arrayWithArray:bestPath];
    bestPath = [[NSMutableArray alloc] init];
    
    for(int i=0;i<[tempBestPath count];i++){
        
        if(i!=0){
            if (i==[tempBestPath count]-1) {
                for (int k =0; k<[pathForEachTwoPoints[[[tempBestPath objectAtIndex:i-1] intValue]][[[tempBestPath objectAtIndex:i] intValue]] count];k++){
                    [bestPath addObject:[pathForEachTwoPoints[[[tempBestPath objectAtIndex:i-1] intValue]][[[tempBestPath objectAtIndex:i] intValue]] objectAtIndex:k]];
                }
            }
            else
                for (int k =0; k<[pathForEachTwoPoints[[[tempBestPath objectAtIndex:i-1] intValue]][[[tempBestPath objectAtIndex:i] intValue]] count]-1;k++){
                    [bestPath addObject:[pathForEachTwoPoints[[[tempBestPath objectAtIndex:i-1] intValue]][[[tempBestPath objectAtIndex:i] intValue]] objectAtIndex:k]];
                }
            
        }
    }
    return [self formatPathToPosition:bestPath];
}



-(void) sortAlgoForDestinations:(NSMutableArray *)destinationArray toPath:(NSMutableArray *)path{
    if ([destinationArray count] == 0) {
        int length=0;
        
        [path insertObject:@38 atIndex:0];
        [path insertObject:@38 atIndex:[path count]];
        
        for(int i=0;i<[path count];i++){
            if(i!=0){
                length += myGraph[[[path objectAtIndex:i-1] intValue]][[[path objectAtIndex:i] intValue]];
            }
        }
        
        if(length<shortestLength){
            shortestLength = length;
            bestPath = [NSMutableArray arrayWithArray:path];
        }
        
        return;
    }
    
    for(int i =0; i<[destinationArray count]; i++){
        NSMutableArray* newDestination = [NSMutableArray arrayWithArray:destinationArray];
        NSMutableArray* newPath = [NSMutableArray arrayWithArray:path];
        
        [newPath addObject:[newDestination objectAtIndex:i]];
        [newDestination removeObjectAtIndex:i];
        [self sortAlgoForDestinations:newDestination toPath:newPath];
    }
}

-(NSMutableArray* ) formatPathToPosition:(NSMutableArray* )path{
    
    NSMutableArray* tempBestPath = bestPath;
    bestPath = nil;

    
    int direction = 0;
    int newDirection = 0;
    
    
    for(int i=0; i<[tempBestPath count];i++){
        if(i==0){
            
        }
        else if (i ==1){
            direction = [self getDirectionForPointsFrom:myPointsPosition[i-1] to:myPointsPosition[i]];
            CGPoint point = [self setPathForPonint:CGPointMake(myPointsPosition[i-1][0],myPointsPosition[i-1][1]) ByDirection:direction];
            [bestPath addObject:NSStringFromCGPoint(point)];
        }
        else if (i == [tempBestPath count] -1){
            CGPoint point = [self setPathForPonint:CGPointMake(myPointsPosition[i][0],myPointsPosition[i][1]) ByDirection:direction];
            [bestPath addObject:NSStringFromCGPoint(point)];
        }
        else{
            newDirection = [self getDirectionForPointsFrom:myPointsPosition[i-1] to:myPointsPosition[i]];
            
            if(newDirection==direction){
                CGPoint point = [self setPathForPonint:CGPointMake(myPointsPosition[i-1][0],myPointsPosition[i-1][1]) ByDirection:direction];
                [bestPath addObject:NSStringFromCGPoint(point)];
            }
            else if(newDirection == -direction){
                
                CGPoint point = [self setPathForPonint:CGPointMake(myPointsPosition[i-1][0],myPointsPosition[i-1][1]) ByDirection:direction];
                [bestPath addObject:NSStringFromCGPoint(point)];
                CGPoint newPoint = [self setPathForPonint:CGPointMake(myPointsPosition[i-1][0],myPointsPosition[i-1][1]) ByDirection:newDirection];
                [bestPath addObject:NSStringFromCGPoint(newPoint)];
                
            }
            else{
                CGPoint point = [self setPathForPonint:CGPointMake(myPointsPosition[i-1][0],myPointsPosition[i-1][1]) ByDirection:direction];
                point = [self setPathForPonint:point ByDirection:newDirection];
                [bestPath addObject:NSStringFromCGPoint(point)];
            }
            
            direction = newDirection;
        }
    }
    return bestPath;
}

-(int) getDirectionForPointsFrom:(int[2]) from to:(int[2]) to{

    
    int deltaX =to[0] - from[0];
    int deltaY = to[1] - from[1];
    
    if(deltaX > 0)
        return RIGHT;
    else if(deltaX < 0)
        return LEFT;
    
    if (deltaY > 0)
        return DOWN;
    else if(deltaY <0)
        return UP;
    
    return 0;
    
}

-(CGPoint) setPathForPonint:(CGPoint) point ByDirection:(int) direction{
    
    if (direction == LEFT){
        return CGPointMake(point.x, point.y-16);
    }else if(direction == RIGHT){
        return CGPointMake(point.x, point.y+16);
    }
    else if(direction == UP){
        return CGPointMake(point.x+16, point.y);
    }
    else if(direction == DOWN){
        return CGPointMake(point.x-16, point.y);
    }
    
    return CGPointMake(point.x, point.y);
}

-(int) getShortestLength{
    return shortestLength;
}

@end
