//
//  BeaconClient.h
//  iBeaconApp
//
//  Created by Sidney on 14-2-28.
//  Copyright (c) 2014年 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>
//#import "FreightOrder.h"

@interface BeaconClient : NSObject
<CLLocationManagerDelegate>
{
    CLLocationManager * _locationManager;
    CLBeaconRegion * _region;
    BOOL _isInsideRegion; // flag to prevent duplicate sending of notification
}

- (BOOL)openClient;
- (NSMutableDictionary*)getMybeaconsArray;
- (void)closeClient;
@property (strong, readwrite) NSMutableDictionary *myBeacons;
@property (strong, readwrite) NSMutableDictionary *itemdic;

@end
