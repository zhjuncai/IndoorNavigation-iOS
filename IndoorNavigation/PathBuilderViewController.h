//
//  ViewController.h
//  CalPositionByDistance
//
//  Created by Lc on 15/3/2.
//  Copyright (c) 2015年 Lc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BeaconClient.h"
#import "storage.h"
#import "iBeacon.h"
#import "PathBuilderView.h"
#import "ShapeView.h"
#import "NaviAlgo.h"
#import "Header.h"
#import "ShelfCargoViewController.h"
#import "FreightOrder.h"


@interface PathBuilderViewController : UIViewController{
    NSMutableArray *choosedPoints;
    NSMutableArray *pathPoints;
    //NSMutableArray *aIBeacons;
    NSTimer *ressTimer;
    BOOL drawOrClear;
    NSMutableArray *storageArray;
    NSMutableArray *footprintArray;
    CFTimeInterval kDuration;
    
    NSMutableArray *arrayForPointsAverage;
}

@property (nonatomic, retain) NSMutableArray *choosedStorages;
@property (nonatomic, retain) NSMutableDictionary *freightOrderCargoItems;

//@property (nonatomic, retain) BeaconClient *beaconClient;
//- (void) drawFootprint:(NSTimer *) myTimer;
//- (void) clearFootprint:(NSTimer *) myTimer;
@end

