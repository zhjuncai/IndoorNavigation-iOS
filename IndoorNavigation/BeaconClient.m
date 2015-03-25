////
////  BeaconClient.m
////  iBeaconApp
////
////  Created by Sidney on 14-2-28.
////  Copyright (c) 2014年 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
////


#import "BeaconClient.h"
#import "AppDelegate.h"

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
        [_locationManager requestAlwaysAuthorization];
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        
        
        NSUUID *estimoteUUID = [[NSUUID alloc] initWithUUIDString:@"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"];
        _region = [[CLBeaconRegion alloc] initWithProximityUUID:estimoteUUID identifier:kIndetifier];
        // launch app when display is turned on and inside region
        _region.notifyEntryStateOnDisplay = YES;
    }
    return self;
}

- (BOOL)openClient
{
    self.itemdic=[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"beacon",@"beacon", nil];
    NSString *str;
    for (OrderItem *item in self.freightOrder.foItems) {
        str=[NSString stringWithFormat:@"%i-%i",[item.major intValue],[item.minor intValue]];
        [self.itemdic setValue:@"false" forKey:str];
    }
    if ([CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]])
    {
        [_locationManager startMonitoringForRegion:_region];
        [_locationManager startRangingBeaconsInRegion:_region];
        [_locationManager requestStateForRegion:_region];
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
        //        [self.itemdic setValue:@"false" forKey:str];
        if ([[self.itemdic valueForKey:str] isEqualToString:@"false"]  && [beacon.major integerValue] ==0 && [beacon.minor integerValue] == 4 && beacon.accuracy<0.3 && beacon.accuracy>=0) {
            for (OrderItem *item in self.freightOrder.foItems) {
                if ([item.major integerValue]==[beacon.major integerValue]&&[item.minor integerValue]==[beacon.minor integerValue]) {
                    [self.itemdic setValue:@"true" forKey:str];
                    NSString *string=[[NSString alloc] initWithString:[NSString stringWithFormat:@"您正靠近%@,距离为:%0.4f 米,请注意!此为危险物品!",item.itemName,beacon.accuracy]];
                    [self showAlertView:nil message:string];
                }
            }
        }
    }
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




@end


//
//#import "BeaconClient.h"
//#import "AppDelegate.h"
//#define kIndetifier [[NSBundle mainBundle] bundleIdentifier]
//
//
//@interface BeaconClient() <CLLocationManagerDelegate>
//
//
//@end
//int iBeaconPositionsinClient[6][2] = {
////    {0, 0}, {768, 0}, {768, 916}, {0, 916}, {384, 0}, {768, 458}
//    {0, 0}, {768, 0}, {768, 916}, {0, 916}, {384, 916/2},
//};
//@implementation BeaconClient
//
//- (id)init
//{
//    if (self = [super init]) {
//        _isInsideRegion = NO;
//        _locationManager = [[CLLocationManager alloc] init];
//        [_locationManager requestAlwaysAuthorization];
//        _locationManager.delegate = self;
//        self.myBeacons = [[NSMutableDictionary alloc] init];
//        observeBeacons = [[NSMutableDictionary alloc] init];
//        self.aIBeacons = [[NSMutableArray alloc] init];
//        self.positionArray = [[NSArray alloc] initWithObjects:@"", @"", nil];
//        
//        NSUUID *estimoteUUID = [[NSUUID alloc] initWithUUIDString:@"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"];
//        self.bearegion = [[CLBeaconRegion alloc] initWithProximityUUID:estimoteUUID major:0 minor:4 identifier:kIndetifier];
//        // launch app when display is turned on and inside region
//        self.bearegion.notifyEntryStateOnDisplay = YES;
//
////        NSArray *uuid = [[NSArray alloc] initWithObjects:@"0-1", @"0-2", @"0-3", @"0-4", @"0-5", @"0-6", nil];
//        //    [self CalPosition:0 y0:0 r0:1 x1:1 y1:1 r1:1 x2:2 y2:2 r2:2.236067977];
////        _aIBeacons = [[NSMutableArray alloc] init];
////        for (int i = 0; i < NUM_OF_BEACONS; i ++) {
////            iBeacon *test = [[iBeacon alloc] initWithLocation:[NSString stringWithFormat:@"%d", iBeaconPositionsinClient[i][0]] y:[NSString stringWithFormat:@"%d", iBeaconPositionsinClient[i][1]] idStr:[uuid objectAtIndex:i]];
////            [_aIBeacons addObject:test];
////        }
//
//    }
//    return self;
//}
//
//- (BOOL)openClient
//{
//    self.itemdic=[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"beacon",@"beacon", nil];
//    if ([CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]])
//    {
//        [_locationManager startMonitoringForRegion:self.bearegion];
//        [_locationManager startRangingBeaconsInRegion:self.bearegion];
//        [_locationManager requestStateForRegion:self.bearegion];
//        return YES;
//    }else{
//        [self showAlertView:nil message:@"This device does not support monitoring beacon regions"];
//        return NO;
//    }
//}
//
//- (void)closeClient
//{
//    [_locationManager stopMonitoringForRegion:self.bearegion];
//    [_locationManager stopRangingBeaconsInRegion:self.bearegion];
//    
//}
//
//#pragma mark - CLLocationManagerDelegate
//- (void)locationManager:(CLLocationManager *)manager
//	  didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
//{
//    if(state == CLRegionStateInside)
//    {
//        _isInsideRegion = YES;
//    }else if(state == CLRegionStateOutside){
//        _isInsideRegion = NO;
//    }else{
//        _isInsideRegion = NO;
//    }
//}
//
//-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
//{
//    
//}
//
//- (NSMutableDictionary*)getMybeaconsArray{
//    return self.myBeacons;
//}
//
//- (void)locationManager:(CLLocationManager *)manager
//         didEnterRegion:(CLRegion *)region
//{
//    NSLog(@"didEnterRegion");
//   
////    [self sendEnterLocalNotification];
////    [self showAlertView:nil message:@"Welcome，你已经进入 iSS iBeacon region"];
////    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground)
////    {
////        [self sendEnterLocalNotification];
////    }else{
////        [self showAlertView:nil message:@"Hi，你已经进入 iSS iBeacon region"];
////    }
//    if (_isInsideRegion)
//        return;
//    else{
//        [self showAlertView:nil message:@"Welcome，你已经进入 4号 iBeacon region"];
//
//    }
//   
//    
//}
//
//
//- (void)locationManager:(CLLocationManager *)manager
//          didExitRegion:(CLRegion *)region
//{
//    NSLog(@"didExitRegion");
////    if (!_isInsideRegion) return;
////    [self sendExitLocalNotification];
////    [self showAlertView:nil message:@"Sorry，你离开了 iSS iBeacon region"];
////    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground)
////    {
////        [self sendExitLocalNotification];
////    }else{
////        [self showAlertView:nil message:@"sorry，你离开了 iSS iBeacon region"];
////    }
//    if (!_isInsideRegion)
//        return;
//    else{
//        [self showAlertView:nil message:@"Bye，你已经退出 4号 iBeacon region"];
//    }
//}
//
//- (void)showAlertView:(NSString *)title message:(NSString *)msg
//{
//    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:title
//                                                         message:msg
//                                                        delegate:nil
//                                               cancelButtonTitle:@"确定"
//                                               otherButtonTitles:nil];
//    [alertView show];
//}
//
//- (void)sendEnterLocalNotification
//{
////    UILocalNotification *notice = [[UILocalNotification alloc] init];
////    notice.alertBody = @"Hi，你已经进入 iSS iBeacon region，打开应用获取最新信息";
////    notice.alertAction = @"Open";
////    notice.soundName = UILocalNotificationDefaultSoundName;
////    [[UIApplication sharedApplication] scheduleLocalNotification:notice];
//}
//
//- (void)sendExitLocalNotification
//{
////    UILocalNotification *notice = [[UILocalNotification alloc] init];
////    notice.alertBody = @"Sorry，你也许离开了 iSS iBeacon region";
////    notice.alertAction = @"Open";
////    notice.soundName = UILocalNotificationDefaultSoundName;
////    [[UIApplication sharedApplication] scheduleLocalNotification:notice];
//}
//
//#pragma mark - Beacon ranging delegate methods
//- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
//{
//    if (![CLLocationManager locationServicesEnabled]) {
//        NSLog(@"Couldn't turn on ranging: Location services are not enabled.");
//
//        return;
//    }
//    
//    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized) {
//        NSLog(@"Couldn't turn on ranging: Location services not authorised.");
//
//        return;
//    }
//}
//
//
//
//
//
////- (void)login
////{
////    self.loginRequest = [[NetworkRequestAPI alloc] initWithDelegate:self];
////    NSString *url = @"http://123.123.123.123/9health/member/authLogin.ecmop?user_name=";
////    [self.loginRequest startGetRequest:url requestKey:nil];
////}
//
//
//#pragma mark NetworkRequestAPIDelegate
////- (void)networkRequestFailed:(NetworkRequestAPI *)api error:(NSString *)errorStr
////{
////    api.delegate = nil;
////    api = nil;
////
////}
////
////- (void)networkRequestSuccessed:(NetworkRequestAPI *)api result:(id)data requestKey:(NSString *)key
////{
////    api.delegate = nil;
////    api = nil;
////    UILocalNotification *notice = [[UILocalNotification alloc] init];
////   
////    NSDictionary * dict = (NSDictionary *)data;
////    //result=0,登陆正常，1会员卡未激活，2用户冻结，3用户名密码错误，4其他错误，5系统错误
////    int result = [[[[dict objectForKey:@"resMsg"] objectForKey:@"rows"] objectForKey:@"result"] intValue];
////    
////    NSString * alertMsg = nil;
////    
////    switch (result) {
////        case 0:
////        case 1:
////        {
////         alertMsg = @"API请求登陆正常";
////        }
////            break;
////        default:
////        {
////         alertMsg = @"API请求异常";
////        }
////            break;
////    }
////    
////    notice.alertBody = [dict description];
////    notice.alertAction = @"Open";
////    notice.soundName = UILocalNotificationDefaultSoundName;
////    [[UIApplication sharedApplication] scheduleLocalNotification:notice];
////
////    
////}
//
//
//#pragma mark - Calculate self position
//
////根据传入的三组数据（每组包括beacon的xy以及距离信息）计算出一个当前位置
//- (NSArray *)CalPosition: (float)x0 y0:(float)y0 r0:(float)r0 x1:(float)x1 y1:(float)y1 r1:(float)r1 x2:(float)x y2:(float)y r2:(float)r{
//    NSString *position1 = [self CalCircleIntersectposition:x0 y0:y0 r0:r0 x1:x1 y1:y1 r1:r1 x:x y:y r:r];
//    NSString *position2 = [self CalCircleIntersectposition:x y0:y r0:r x1:x0 y1:y0 r1:r0 x:x1 y:y1 r:r1];
//    NSString *position3 = [self CalCircleIntersectposition:x1 y0:y1 r0:r1 x1:x y1:y r1:r x:x0 y:y0 r:r0];
//    NSArray *array1 = [position1 componentsSeparatedByString:@" "];
//    NSArray *array2 = [position2 componentsSeparatedByString:@" "];
//    NSArray *array3 = [position3 componentsSeparatedByString:@" "];
//    
//    NSMutableArray *iBeaconPoints = [[NSMutableArray alloc]init];
//    [iBeaconPoints addObject:array1];
//    [iBeaconPoints addObject:array2];
//    [iBeaconPoints addObject:array3];
//    
//    float xFinal = 0;
//    float yFinal = 0;
//    if ([position1 isEqualToString:@"nan nan"] || [position2 isEqualToString:@"nan nan"] || [position3 isEqualToString:@"nan nan"]) {
//        if ([position1 isEqualToString:@"nan nan"]) {
//            [iBeaconPoints removeObject:array1];
//        }
//        if ([position2 isEqualToString:@"nan nan"]) {
//            [iBeaconPoints removeObject:array2];
//        }
//        if ([position3 isEqualToString:@"nan nan"]) {
//            [iBeaconPoints removeObject:array3];
//        }
//        if ([iBeaconPoints count] >= 1) {
//            for (int i = 0; i < [iBeaconPoints count]; i ++) {
//                xFinal = xFinal + [iBeaconPoints[i][0] floatValue];
//                yFinal = yFinal + [iBeaconPoints[i][1] floatValue];
//            }
//            xFinal = xFinal / [iBeaconPoints count];
//            yFinal = yFinal / [iBeaconPoints count];
//            NSArray *result = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%f", xFinal], [NSString stringWithFormat:@"%f", yFinal], nil];
//            return result;
//        }else{
//            return nil;
//        }
//    }else{
//        float distance1 = [self CalDistance:[array1[0] floatValue] y0:[array1[1] floatValue] x1:[array2[0] floatValue] y1:[array2[1] floatValue]];
//        float distance2 = [self CalDistance:[array3[0] floatValue] y0:[array3[1] floatValue] x1:[array2[0] floatValue] y1:[array2[1] floatValue]];
//        float distance3 = [self CalDistance:[array1[0] floatValue] y0:[array1[1] floatValue] x1:[array3[0] floatValue] y1:[array3[1] floatValue]];
//        float disoffirst = distance1 + distance3;
//        float disofsec = distance1 + distance2;
//        float disofthird = distance2 + distance3;
//        
//        float maxDis = MAX(MAX(disoffirst, disofsec), disofthird);
//        int index = 2;
//        if (maxDis == disoffirst) {
//            index = 0;
//        }else if(maxDis == disofsec){
//            index = 1;
//        }
//        [iBeaconPoints removeObjectAtIndex:index];
//        
//        for (int i = 0; i < 2; i ++) {
//            xFinal = xFinal + [iBeaconPoints[i][0] floatValue];
//            yFinal = yFinal + [iBeaconPoints[i][1] floatValue];
//        }
//        xFinal = xFinal / 2;
//        yFinal = yFinal / 2;
//        NSArray *result = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%f", xFinal], [NSString stringWithFormat:@"%f", yFinal], nil];
//        return result;
//    }
//}
//
//- (NSString *)CalCircleIntersectposition: (float)x0 y0:(float)y0 r0:(float)r0 x1:(float)x1 y1:(float)y1 r1:(float)r1 x:(float)x y:(float)y r:(float)r{
//    float D = [self CalDistance:x0 y0:y0 x1:x1 y1:y1];
//    float a = (r0 * r0 - r1 * r1 + D * D) / (2*D);
//    float tem = (r0 * r0 - a * a);
//    NSLog(@"看看正负：%f", tem);
//    float h = sqrt(tem);
//    float x2 = x0 + a * (x1 - x0) / D;
//    float y2 = y0 + a * (y1 - y0) / D;
//    
//    float x3 = x2 + h * (y1 - y0) / D;
//    float y3 = y2 - h * (x1 - x0) / D;
//    
//    float dis = [self CalDistance:x3 y0:y3 x1:x y1:y];
//    
//    float x4 = x2 - h * (y1 - y0) / D;
//    float y4 = y2 + h * (x1 - x0) / D;
//    
//    float dis2 = [self CalDistance:x4 y0:y4 x1:x y1:y];
//    if (dis < dis2) {
//        x3 = x4;
//        y3 = y4;
//    }
////    NSLog(@"x : %f, y : %f",x3, y3);
//    if (x3 < 0 || y3 < 0) {
//        return @"nan nan";
//    }
//    NSString *result = [NSString stringWithFormat:@"%f %f",x3, y3];
////    NSLog(@"hehehehe:%@", result);
//    return result;
//}
//
//- (float)CalDistance: (float)x0 y0:(float)y0 x1:(float)x1 y1:(float)y1{
//    float xDis = fabsf(x0 - x1);
//    float yDis = fabsf(y0 - y1);
//    return sqrt(xDis * xDis + yDis * yDis);
//}
//
//
////- (NSMutableArray *)getData{
////    NSData *fileData = [[NSData alloc]init];
////    NSUserDefaults *UD = [NSUserDefaults standardUserDefaults];
////    if ([UD objectForKey:@"beacons"] == nil) {
////        NSString *path;
////        path = [[NSBundle mainBundle] pathForResource:@"location" ofType:@"json"];
////        fileData = [NSData dataWithContentsOfFile:path];
////        [UD setObject:fileData forKey:@"beacons"];
////        [UD synchronize];
////    }
////    else {
////        fileData = [UD objectForKey:@"beacons"];
////    }
////
////    NSDictionary *myData = [NSJSONSerialization JSONObjectWithData:fileData options:NSJSONReadingMutableLeaves error:nil];
////    NSDictionary *data = [myData objectForKey:@"beacons"];
////    NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:0];
////    NSLog(@"内容为--》%@", data);
////
////    return array;
////}
//
//#pragma mark - Check method
//
////检查beacon的距离是不是已经超出 MAX_DISTANCE，移动距离是不是过小
//- (BOOL)CheckBeaconsDataQualifyBeforeCalculate:(NSArray *)beacons{
//    int wrongNum = 0;
//    
//    for (CLBeacon* beacon in beacons) {
//        NSString *str=[NSString stringWithFormat:@"%i-%i",[beacon.major intValue],[beacon.minor intValue]];
//        if (beacon.accuracy > MAX_DISTANCE || beacon.accuracy < 0) {
//            wrongNum ++;
//        }else{
//            [self.myBeacons setObject:beacon forKey:str];
////            if ([self.myBeacons count] < NUM_OF_BEACONS) {
////                [self.myBeacons setObject:beacon forKey:str];
////            }else{
////                [self.myBeacons setObject:beacon forKey:str];
////                for (CLBeacon* preBeacon in self.myBeacons){
////                    if ([beacon.minor isEqualToNumber:preBeacon.minor] && [beacon.major isEqualToNumber:preBeacon.major]) {
////                        if (fabs(preBeacon.accuracy - beacon.accuracy) * SCALE < MIN_DISTANCE) {
////                            wrongNum ++;
////                        }else{
////                            [self.myBeacons setObject:beacon forKey:str];
////                        }
////                    }
////                }
////            }
////
//        }
//    }
//    
//    if (3 > NUM_OF_BEACONS - wrongNum) {
//        return NO;
//    }else{
//        return YES;
//    }
//}
//
//#pragma mark - draw self position
//
//-(void)drawPosition{
//    NSMutableArray *tem = [[NSMutableArray alloc] init];
//    tem = [self PickIBeacons];
//    NSLog(@"%@",tem);
//    if ([tem count] >= 3) {
//        int num = [tem count];
//        
//        NSMutableArray* resultArray = [[NSMutableArray alloc] init];
//        for (int i = 0; i < num-2; i ++) {
//            float x0 = 0.0,y0 = 0.0,r0 = 0.0,x1 = 0.0,y1 = 0.0,r1 = 0.0,x = 0.0,y = 0.0,r = 0.0;
//            CLBeacon* beacon0 = [tem objectAtIndex:i];
//            CLBeacon* beacon1 = [tem objectAtIndex:i + 1];
//            CLBeacon* beacon2 = [tem objectAtIndex:i + 2];
//            for(iBeacon *myBeacon in self.aIBeacons){
//                if ([[myBeacon getIdStr] isEqualToString:[NSString stringWithFormat:@"%i-%i",[beacon0.major intValue],[beacon0.minor intValue]]]) {
//                    x0 = [[myBeacon getX] intValue];
//                    y0 = [[myBeacon getY] intValue];
//                    double tem = fabs(beacon0.accuracy);
//                    tem = [[NSString stringWithFormat:@"%.2f",tem] doubleValue];
//                    r0 = fabs(tem * SCALE);
//                }else if([[myBeacon getIdStr] isEqualToString:[NSString stringWithFormat:@"%i-%i",[beacon1.major intValue],[beacon1.minor intValue]]]){
//                    x1 = [[myBeacon getX] intValue];
//                    y1 = [[myBeacon getY] intValue];
//                    double tem = fabs(beacon1.accuracy);
//                    tem = [[NSString stringWithFormat:@"%.2f",tem] doubleValue];
//                    r1 = fabs(tem * SCALE);
//                }else if ([[myBeacon getIdStr] isEqualToString:[NSString stringWithFormat:@"%i-%i",[beacon2.major intValue],[beacon2.minor intValue]]]){
//                    x = [[myBeacon getX] intValue];
//                    y = [[myBeacon getY] intValue];
//                    double tem = fabs(beacon2.accuracy);
//                    tem = [[NSString stringWithFormat:@"%.2f",tem] doubleValue];
//                    r = fabs(tem * SCALE);
//                }
//            }
//            if ([self CalPosition:x0 y0:y0 r0:r0 x1:x1 y1:y1 r1:r1 x2:x y2:y r2:r] != nil) {
//                [resultArray addObject:[self CalPosition:x0 y0:y0 r0:r0 x1:x1 y1:y1 r1:r1 x2:x y2:y r2:r]];
//            }
//        }
//        if ([resultArray count] > 0) {
//            float resultX = 0.0;
//            float resultY = 0.0;
//            float averageX = 0.0;
//            float averageY = 0.0;
//            for (int i = 0; i < [resultArray count]; i ++) {
//                NSArray* temArray = [resultArray objectAtIndex:i];
//                float temX = [[temArray objectAtIndex:0] floatValue];
//                float temY = [[temArray objectAtIndex:1] floatValue];
//                averageX += temX;
//                averageY += temY;
//            }
//            averageX = averageX/[resultArray count];
//            averageY = averageY/[resultArray count];
//            NSMutableArray *temDisArray = [[NSMutableArray alloc] init];
//            for (int i = 0; i < [resultArray count]; i ++) {
//                NSArray* temArray = [resultArray objectAtIndex:i];
//                float temX = [[temArray objectAtIndex:0] floatValue];
//                float temY = [[temArray objectAtIndex:1] floatValue];
//                float temResult = [self CalDistance:temX y0:temY x1:averageX y1:averageY];
//                [temDisArray addObject:[NSNumber numberWithFloat:temResult*temResult]];
//            }
//            if ([resultArray count] > 2) {
//                NSMutableArray *removeArray = [[NSMutableArray alloc] init];
//                for (int i = 0; i < PASS_NUMBER; i ++) {
//                    for (int j = 0; j < [resultArray count]; j ++) {
//                        NSNumber* temNumber = [temDisArray objectAtIndex:i];
//                        if ([self JudgeBigest:temDisArray value:temNumber] == YES) {
//                            [removeArray addObject:[resultArray objectAtIndex:j]];
//                            break;
//                        }
//                    }
//                    [resultArray removeObject:[removeArray lastObject]];
//                }
//            }
//            
//            for (int i = 0; i < [resultArray count]; i ++) {
//                NSArray* tem = [resultArray objectAtIndex:i];
//                float temX = [[tem objectAtIndex:0] floatValue];
//                float temY = [[tem objectAtIndex:1] floatValue];
//                resultX += temX;
//                resultY += temY;
//            }
//            resultY = resultY/[resultArray count];
//            resultX = resultX/[resultArray count];
//            
//            
//            float distanceFromPre = [self CalDistance:resultX y0:resultY x1:[[self.positionArray objectAtIndex:0] floatValue] y1:[[self.positionArray objectAtIndex:0] floatValue]];
//            
//            //        if (distanceFromPre < 2*SCALE && distanceFromPre > 0.3*SCALE) {
//            self.positionArray = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%f",resultX], [NSString stringWithFormat:@"%f",resultY], nil];
//            NSLog(@"X: %f, Y: %f", resultX, resultY);
//            //        }
//        }
//
//
//    }
//}
//
//
//- (NSMutableArray*)PickIBeacons{
//    NSMutableArray* resultBeacons = [[NSMutableArray alloc] init];
//    for (iBeacon* tem in self.aIBeacons) {
//        if ([self.myBeacons objectForKey:[tem getIdStr]] != nil) {
//            [resultBeacons addObject:[self.myBeacons objectForKey:[tem getIdStr]]];
//        }
//    }
////    NSArray *sortedArray = [resultBeacons sortedArrayUsingComparator:^NSComparisonResult(CLBeacon *p1, CLBeacon *p2){
////        return [[NSNumber numberWithDouble: p1.accuracy] compare:[NSNumber numberWithDouble: p2.accuracy]] == NSOrderedDescending;
////    }];
////    [resultBeacons removeAllObjects];
////    if ([sortedArray count] >= 3) {
////        NSIndexSet *indexs = [[NSMutableIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, 3)];
////        [resultBeacons addObjectsFromArray:[sortedArray objectsAtIndexes:indexs]];
////    }
//    return resultBeacons;
//}
//
//- (BOOL)JudgeBigest:(NSMutableArray*)array value:(NSNumber*)value{
//    for (int i = 0; i < [array count]; i ++) {
//        if (value < [array objectAtIndex:i]) {
//            return NO;
//        }
//    }
//    return YES;
//}
//
//@end
