//
//  BeaconClient.m
//  iBeaconApp
//
//  Created by Sidney on 14-2-28.
//  Copyright (c) 2014年 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
//

#import "BeaconClient.h"
#import "AppDelegate.h"
#define kIndetifier [[NSBundle mainBundle] bundleIdentifier]

//#import "RootViewController.h"
@interface BeaconClient() <CLLocationManagerDelegate>
//<NetworkRequestAPIDelegate>
//
//
//@property(nonatomic,strong) NetworkRequestAPI * loginRequest;


@end
@implementation BeaconClient

- (id)init
{
    if (self = [super init]) {
        _isInsideRegion = NO;
        _locationManager = [[CLLocationManager alloc] init];
        [_locationManager requestAlwaysAuthorization];
        _locationManager.delegate = self;

        
        NSUUID *estimoteUUID = [[NSUUID alloc] initWithUUIDString:@"B7D1027D-6788-416E-994F-EA11075F1765"];
        self.bearegion = [[CLBeaconRegion alloc] initWithProximityUUID:estimoteUUID identifier:kIndetifier];
        // launch app when display is turned on and inside region
        self.bearegion.notifyEntryStateOnDisplay = YES;
    }
    return self;
}

- (BOOL)openClient
{
    self.itemdic=[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"beacon",@"beacon", nil];
    self.myBeacons = [[NSMutableDictionary alloc] init];
    NSString *str;
    if ([CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]])
    {
        [_locationManager startMonitoringForRegion:self.bearegion];
        [_locationManager startRangingBeaconsInRegion:self.bearegion];
        [_locationManager requestStateForRegion:self.bearegion];
        return YES;
    }else{
        [self showAlertView:nil message:@"This device does not support monitoring beacon regions"];
        return NO;
    }
}

- (void)closeClient
{
    [_locationManager stopMonitoringForRegion:_region];
    [_locationManager stopRangingBeaconsInRegion:_region];
    
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
	  didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    if(state == CLRegionStateInside)
    {
        _isInsideRegion = YES;
    }else if(state == CLRegionStateOutside){
        _isInsideRegion = NO;
    }else{
        _isInsideRegion = NO;
    }
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    NSDictionary *ibeaconsDic=[[NSDictionary alloc] initWithObjectsAndKeys:beacons,@"iBeacons",nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"iBeaconsBack" object:Nil userInfo:ibeaconsDic];
    

    for (CLBeacon* beacon in beacons) {
        NSString *str=[NSString stringWithFormat:@"%i-%i",[beacon.major intValue],[beacon.minor intValue]];
        if([[self.itemdic valueForKey:str] isEqualToString:@"false"]){
            [self.myBeacons setObject:beacon forKey:str];
        }
    }
}

- (NSMutableDictionary*)getMybeaconsArray{
    return self.myBeacons;
}

- (void)locationManager:(CLLocationManager *)manager
         didEnterRegion:(CLRegion *)region
{
    NSLog(@"didEnterRegion");
    if (_isInsideRegion) return;
    [self sendEnterLocalNotification];
//    [self showAlertView:nil message:@"Welcome，你已经进入 iSS iBeacon region"];
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground)
    {
        [self sendEnterLocalNotification];
    }else{
        [self showAlertView:nil message:@"Hi，你已经进入 iSS iBeacon region"];
    }
}


- (void)locationManager:(CLLocationManager *)manager
          didExitRegion:(CLRegion *)region
{
    NSLog(@"didExitRegion");
    if (!_isInsideRegion) return;
    [self sendExitLocalNotification];
//    [self showAlertView:nil message:@"Sorry，你离开了 iSS iBeacon region"];
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground)
    {
        [self sendExitLocalNotification];
    }else{
//        [self showAlertView:nil message:@"sorry，你离开了 iSS iBeacon region"];
    }
}

- (void)showAlertView:(NSString *)title message:(NSString *)msg
{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:title
                                                         message:msg
                                                        delegate:nil
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil];
    [alertView show];
}

- (void)sendEnterLocalNotification
{
//    UILocalNotification *notice = [[UILocalNotification alloc] init];
//    notice.alertBody = @"Hi，你已经进入 iSS iBeacon region，打开应用获取最新信息";
//    notice.alertAction = @"Open";
//    notice.soundName = UILocalNotificationDefaultSoundName;
//    [[UIApplication sharedApplication] scheduleLocalNotification:notice];
}

- (void)sendExitLocalNotification
{
//    UILocalNotification *notice = [[UILocalNotification alloc] init];
//    notice.alertBody = @"Sorry，你也许离开了 iSS iBeacon region";
//    notice.alertAction = @"Open";
//    notice.soundName = UILocalNotificationDefaultSoundName;
//    [[UIApplication sharedApplication] scheduleLocalNotification:notice];
}

#pragma mark - Beacon ranging delegate methods
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"Couldn't turn on ranging: Location services are not enabled.");

        return;
    }
    
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized) {
        NSLog(@"Couldn't turn on ranging: Location services not authorised.");

        return;
    }
}





//- (void)login
//{
//    self.loginRequest = [[NetworkRequestAPI alloc] initWithDelegate:self];
//    NSString *url = @"http://123.123.123.123/9health/member/authLogin.ecmop?user_name=";
//    [self.loginRequest startGetRequest:url requestKey:nil];
//}


#pragma mark NetworkRequestAPIDelegate
//- (void)networkRequestFailed:(NetworkRequestAPI *)api error:(NSString *)errorStr
//{
//    api.delegate = nil;
//    api = nil;
//
//}
//
//- (void)networkRequestSuccessed:(NetworkRequestAPI *)api result:(id)data requestKey:(NSString *)key
//{
//    api.delegate = nil;
//    api = nil;
//    UILocalNotification *notice = [[UILocalNotification alloc] init];
//   
//    NSDictionary * dict = (NSDictionary *)data;
//    //result=0,登陆正常，1会员卡未激活，2用户冻结，3用户名密码错误，4其他错误，5系统错误
//    int result = [[[[dict objectForKey:@"resMsg"] objectForKey:@"rows"] objectForKey:@"result"] intValue];
//    
//    NSString * alertMsg = nil;
//    
//    switch (result) {
//        case 0:
//        case 1:
//        {
//         alertMsg = @"API请求登陆正常";
//        }
//            break;
//        default:
//        {
//         alertMsg = @"API请求异常";
//        }
//            break;
//    }
//    
//    notice.alertBody = [dict description];
//    notice.alertAction = @"Open";
//    notice.soundName = UILocalNotificationDefaultSoundName;
//    [[UIApplication sharedApplication] scheduleLocalNotification:notice];
//
//    
//}


@end
