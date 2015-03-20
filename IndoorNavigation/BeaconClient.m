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


@interface BeaconClient() <CLLocationManagerDelegate>


@end
@implementation BeaconClient

- (id)init
{
    if (self = [super init]) {
        _isInsideRegion = NO;
        _locationManager = [[CLLocationManager alloc] init];
        [_locationManager requestAlwaysAuthorization];
        _locationManager.delegate = self;
        self.myBeacons = [[NSMutableDictionary alloc] init];
        observeBeacons = [[NSMutableDictionary alloc] init];
        self.aIBeacons = [[NSMutableArray alloc] init];
        positionArray = [[NSArray alloc] initWithObjects:@"", @"", nil];
        
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
    [_locationManager stopMonitoringForRegion:self.bearegion];
    [_locationManager stopRangingBeaconsInRegion:self.bearegion];
    
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
//    NSArray* resultArray = [beacons sortedArrayWithOptions:NSSortStable usingComparator:^NSComparisonResult(CLBeacon* firstBeacon, CLBeacon* secondBeacon){
//        return [[NSNumber numberWithDouble: firstBeacon.accuracy] compare:[NSNumber numberWithDouble: secondBeacon.accuracy]] == NSOrderedDescending;
//    }];
//    NSIndexSet *indexs = [[NSMutableIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, 3)];
    BOOL maxCheck = [self CheckBeaconsDataQualifyBeforeCalculate:beacons];
    if (maxCheck == YES) {
        [self drawPosition];
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


#pragma mark - Calculate self position

//根据传入的三组数据（每组包括beacon的xy以及距离信息）计算出一个当前位置
- (NSArray *)CalPosition: (float)x0 y0:(float)y0 r0:(float)r0 x1:(float)x1 y1:(float)y1 r1:(float)r1 x2:(float)x y2:(float)y r2:(float)r{
    NSString *position1 = [self CalCircleIntersectposition:x0 y0:y0 r0:r0 x1:x1 y1:y1 r1:r1 x:x y:y r:r];
    NSString *position2 = [self CalCircleIntersectposition:x y0:y r0:r x1:x0 y1:y0 r1:r0 x:x1 y:y1 r:r1];
    NSString *position3 = [self CalCircleIntersectposition:x1 y0:y1 r0:r1 x1:x y1:y r1:r x:x0 y:y0 r:r0];
    NSArray *array1 = [position1 componentsSeparatedByString:@" "];
    NSArray *array2 = [position2 componentsSeparatedByString:@" "];
    NSArray *array3 = [position3 componentsSeparatedByString:@" "];
    
    NSMutableArray *iBeaconPoints = [[NSMutableArray alloc]init];
    [iBeaconPoints addObject:array1];
    [iBeaconPoints addObject:array2];
    [iBeaconPoints addObject:array3];
    
    
    float distance1 = [self CalDistance:[array1[0] floatValue] y0:[array1[1] floatValue] x1:[array2[0] floatValue] y1:[array2[1] floatValue]];
    float distance2 = [self CalDistance:[array3[0] floatValue] y0:[array3[1] floatValue] x1:[array2[0] floatValue] y1:[array2[1] floatValue]];
    float distance3 = [self CalDistance:[array1[0] floatValue] y0:[array1[1] floatValue] x1:[array3[0] floatValue] y1:[array3[1] floatValue]];
    
    float disoffirst = distance1 + distance3;
    float disofsec = distance1 + distance2;
    float disofthird = distance2 + distance3;
    
    float maxDis = MAX(MAX(disoffirst, disofsec), disofthird);
    int index = 2;
    if (maxDis == disoffirst) {
        index = 0;
    }else if(maxDis == disofsec){
        index = 1;
    }
    [iBeaconPoints removeObjectAtIndex:index];
    float xFinal = 0;
    float yFinal = 0;
    for (int i = 0; i < 2; i ++) {
        xFinal = xFinal + [iBeaconPoints[i][0] floatValue];
        yFinal = yFinal + [iBeaconPoints[i][1] floatValue];
    }
    xFinal = xFinal / 2;
    yFinal = yFinal / 2;
    NSArray *result = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%f", xFinal], [NSString stringWithFormat:@"%f", yFinal], nil];
    return result;
}

- (NSString *)CalCircleIntersectposition: (float)x0 y0:(float)y0 r0:(float)r0 x1:(float)x1 y1:(float)y1 r1:(float)r1 x:(float)x y:(float)y r:(float)r{
    float D = [self CalDistance:x0 y0:y0 x1:x1 y1:y1];
    NSLog(@"%f",D);
    float a = (r0 * r0 - r1 * r1 + D * D) / (2*D);
    float h = sqrt(r0 * r0 - a * a);
    
    float x2 = x0 + a * (x1 - x0) / D;
    float y2 = y0 + a * (y1 - y0) / D;
    
    float x3 = x2 + h * (y1 - y0) / D;
    float y3 = y2 - h * (x1 - x0) / D;
    
    float dis = [self CalDistance:x3 y0:y3 x1:x y1:y];
    
    float x4 = x2 - h * (y1 - y0) / D;
    float y4 = y2 + h * (x1 - x0) / D;
    
    float dis2 = [self CalDistance:x4 y0:y4 x1:x y1:y];
    if (dis < dis2) {
        x3 = x4;
        y3 = y4;
    }
    NSLog(@"x : %f, y : %f",x3, y3);
    
    NSString *result = [NSString stringWithFormat:@"%f %f",x3, y3];
    NSLog(@"hehehehe:%@", result);
    return result;
}

- (float)CalDistance: (float)x0 y0:(float)y0 x1:(float)x1 y1:(float)y1{
    return sqrt((x0 - x1) * (x0 - x1) + (y0 - y1) * (y0 - y1));
}


//- (NSMutableArray *)getData{
//    NSData *fileData = [[NSData alloc]init];
//    NSUserDefaults *UD = [NSUserDefaults standardUserDefaults];
//    if ([UD objectForKey:@"beacons"] == nil) {
//        NSString *path;
//        path = [[NSBundle mainBundle] pathForResource:@"location" ofType:@"json"];
//        fileData = [NSData dataWithContentsOfFile:path];
//        [UD setObject:fileData forKey:@"beacons"];
//        [UD synchronize];
//    }
//    else {
//        fileData = [UD objectForKey:@"beacons"];
//    }
//
//    NSDictionary *myData = [NSJSONSerialization JSONObjectWithData:fileData options:NSJSONReadingMutableLeaves error:nil];
//    NSDictionary *data = [myData objectForKey:@"beacons"];
//    NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:0];
//    NSLog(@"内容为--》%@", data);
//
//    return array;
//}

#pragma mark - Check method

//检查beacon的距离是不是已经超出 MAX_DISTANCE，移动距离是不是过小
- (BOOL)CheckBeaconsDataQualifyBeforeCalculate:(NSArray *)beacons{
    int wrongNum = 0;
    
    for (CLBeacon* beacon in beacons) {
        NSString *str=[NSString stringWithFormat:@"%i-%i",[beacon.major intValue],[beacon.minor intValue]];
        if (beacon.accuracy > MAX_DISTANCE) {
            wrongNum ++;
        }else{
            for (CLBeacon* preBeacon in self.myBeacons){
                if (beacon.major == preBeacon.minor && beacon.major == preBeacon.major) {
                    if (fabs(preBeacon.accuracy - beacon.accuracy) * SCALE < MIN_DISTANCE) {
                        wrongNum ++;
                    }else{
                        [self.myBeacons setObject:beacon forKey:str];
                    }
                }
            }
        }
    }
    
    if (3 > NUM_OF_BEACONS - wrongNum) {
        return NO;
    }else{
        return YES;
    }
}

#pragma mark - draw self position

-(void)drawPosition{
    NSMutableArray *tem = [[NSMutableArray alloc] init];
    for(CLBeacon* beacon in self.myBeacons){
        [tem addObject:beacon];
    }
    int num = [tem count]/3;
    NSMutableArray* resultArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < num; i ++) {
        float x0 = 0.0,y0 = 0.0,r0 = 0.0,x1 = 0.0,y1 = 0.0,r1 = 0.0,x = 0.0,y = 0.0,r = 0.0;
        CLBeacon* beacon0 = [tem objectAtIndex:3*i];
        CLBeacon* beacon1 = [tem objectAtIndex:3*i + 1];
        CLBeacon* beacon2 = [tem objectAtIndex:3*i + 2];
        for(iBeacon *myBeacon in self.aIBeacons){
            if ([[myBeacon getIdStr] isEqualToString:[NSString stringWithFormat:@"%i-%i",[beacon0.major intValue],[beacon0.minor intValue]]]) {
                x0 = [[myBeacon getX] intValue];
                y0 = [[myBeacon getY] intValue];
                r0 = beacon0.accuracy * SCALE;
            }else if([[myBeacon getIdStr] isEqualToString:[NSString stringWithFormat:@"%i-%i",[beacon1.major intValue],[beacon1.minor intValue]]]){
                x1 = [[myBeacon getX] intValue];
                y1 = [[myBeacon getY] intValue];
                r1 = beacon1.accuracy * SCALE;
            }else if ([[myBeacon getIdStr] isEqualToString:[NSString stringWithFormat:@"%i-%i",[beacon2.major intValue],[beacon2.minor intValue]]]){
                x = [[myBeacon getX] intValue];
                y = [[myBeacon getY] intValue];
                r = beacon2.accuracy * SCALE;
            }
        }
        [resultArray addObject:[self CalPosition:x0 y0:y0 r0:r0 x1:x1 y1:y1 r1:r1 x2:x y2:y r2:r]];
    }
    float resultX = 0.0;
    float resultY = 0.0;
    
    for (int i = 0; i < num; i ++) {
        NSArray* tem = [resultArray objectAtIndex:i];
        float temX = [[tem objectAtIndex:0] floatValue];
        float temY = [[tem objectAtIndex:1] floatValue];
        resultX += temX;
        resultY += temY;
    }
    
    resultX = resultX/num;
    resultY = resultY/num;
    float distanceFromPre = [self CalDistance:resultX y0:resultY x1:[[positionArray objectAtIndex:0] floatValue] y1:[[positionArray objectAtIndex:0] floatValue]];
    
    if (distanceFromPre < 40 && distanceFromPre > 3) {
        positionArray = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%f",resultX], [NSString stringWithFormat:@"%f",resultY], nil];
    }
}


@end
