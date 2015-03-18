//
//  ViewController.h
//  Demo
//
//  Created by Andrea on 16/04/14.
//  Copyright (c) 2014 Fancy Pixel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "CargoTableViewCell.h"
#import "FreightOrder.h"
#import "BeaconClient.h"

@interface TableViewController : UIViewController

@property (nonatomic, strong) FreightOrder *freightOrder;
@property (nonatomic, retain) BeaconClient *beaconClient;


- (void) handleMessage:(NSNotification*)nc;

@end
