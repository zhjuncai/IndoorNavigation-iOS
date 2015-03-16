//
//  NSObject+NaviAlgo.m
//  Navi
//
//  Created by Chen on 15/3/14.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import "NaviAlgo.h"



@implementation NaviAlgo


-(NSMutableArray *)getBestPathForGraph:(int [42][42])graph withDestinations:(NSMutableArray *)destinationArray{
    
    int MAX = 100000;
    int spot[42][42];
    int onePath[42];
    
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
    return bestPath;
}

-(void) getPathForEachPoints:(int[42][42])spots from:(int)i to:(int)j path:(int[])onePath numOfPoints:(int[])point{
    if(i==j){
        return;
    }
    
    if(spots[i][j]==-1){

        onePath[point[0]++] =j;
    }
    
    else{
        [self getPathForEachPoints:spots from:i to:spots[i][j] path:onePath numOfPoints:point];
        [self getPathForEachPoints:spots from:spots[i][j] to:j path:onePath numOfPoints:point];
    }
        
        
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

-(int) getShortestLength{
    return shortestLength;
}

@end
