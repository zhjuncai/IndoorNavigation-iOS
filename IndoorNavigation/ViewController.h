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


@interface ViewController : UIViewController{
    NSMutableArray *choosedPoints;
    NSMutableArray *pathPoints;
    NSMutableArray *aIBeacons;
    NSTimer *ressTimer;
    BOOL drawOrClear;
    int drawPointsNum;
}

@property (nonatomic, retain) BeaconClient *beaconClient;
@end

