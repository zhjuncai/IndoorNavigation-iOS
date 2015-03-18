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

@interface BeaconClient : NSObject
<CLLocationManagerDelegate>
{
    CLLocationManager * _locationManager;
    BOOL _isInsideRegion; // flag to prevent duplicate sending of notification
}

- (BOOL)openClient;
- (NSMutableDictionary*)getMybeaconsArray;
- (void)closeClient;
@property (strong, readwrite) NSMutableDictionary *myBeacons;
@property (strong, readwrite) NSMutableDictionary *itemdic;
@property (strong, readwrite) CLBeaconRegion *bearegion;
@end
