//
//  PathBuilderViewController.m
//  CalPositionByDistance
//
//  Created by Lc on 15/3/2.
//  Copyright (c) 2015年 Lc. All rights reserved.
//

#import "PathBuilderViewController.h"

@interface PathBuilderViewController ()
@property (nonatomic, readonly) PathBuilderView *pathBuilderView;

@end


@implementation PathBuilderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    NSArray *uuid = [[NSArray alloc] initWithObjects:@"first", @"sec", @"third", @"fourth", @"fifth", @"sixth", nil];
//    [self CalPosition:0 y0:0 r0:1 x1:1 y1:1 r1:1 x2:2 y2:2 r2:2.236067977];
    aIBeacons = [[NSMutableArray alloc] init];
    for (int i = 0; i < NUM_OF_BEACONS; i ++) {
        iBeacon *test = [[iBeacon alloc] initWithLocation:[NSString stringWithFormat:@"%d", iBeaconPositions[i][0]] y:[NSString stringWithFormat:@"%d", iBeaconPositions[i][1]] idStr:[uuid objectAtIndex:i]];
        [aIBeacons addObject:test];
    }
    self.beaconClient.aIBeacons = aIBeacons;
    
    drawOrClear = YES;
    choosedPoints = [[NSMutableArray alloc] init];
    pathPoints = [[NSMutableArray alloc] init];
    
    
    
    [self viewPrepare];
    
//    [self.pathBuilderView DrawSelf:50 y:50];
    
//    NSLog(@"kjahsdkja%d",[self CheckSelfPositionAfterCalculate:62 y:62]);
    
    
    //启动iBeacons，timer开始定时计算自身位置
    [self startIbeacons];
//    NSTimer *calSelfPositionTimer = [NSTimer scheduledTimerWithTimeInterval:0.05
//                                                                     target:self
//                                                                   selector:@selector(drawPosition)
//                                                                   userInfo:nil
//                                                                    repeats:YES];
    
    
    
    
    
   
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - initView

- (void)viewPrepare{
//    self.view = [[PathBuilderView alloc] initWithFrame:CGRectMake(0, 64, 768, 920)];
    
    PathBuilderView * builderView = [[PathBuilderView alloc] initWithFrame:self.view.frame];
    [self.view insertSubview:builderView atIndex:0];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self CreateWarehouse:keyPointMap storagePosition:storagePosition];
    
    self.pathBuilderView.pathShapeView.shapeLayer.strokeColor = [UIColor blackColor].CGColor;
    self.pathBuilderView.prospectivePathShapeView.shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    self.pathBuilderView.pointsShapeView.shapeLayer.strokeColor = [UIColor blackColor].CGColor;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
    animation.fromValue = @0.0;
    animation.toValue = @1.0;
    animation.removedOnCompletion = NO;
    animation.duration = kDuration;
    [self.pathBuilderView.pathShapeView.shapeLayer addAnimation:animation forKey:NSStringFromSelector(@selector(strokeEnd))];
    
    self.pathBuilderView.pathShapeView.shapeLayer.speed = 0;
    self.pathBuilderView.pathShapeView.shapeLayer.timeOffset = 0.0;
    
    [CATransaction flush];
    
    self.pathBuilderView.pathShapeView.shapeLayer.timeOffset = 2;
    
}

- (PathBuilderView *)pathBuilderView
{
    return (PathBuilderView *)self.view.subviews.firstObject;
}

//在屏幕上创建出表示货架的黑button
- (void)CreateWarehouse:(int[40])keyPointMap storagePosition:(int[40][4])storagePosition{
    for (int i = 0; i < 40; i ++) {
        CGRect frame = [self ConvertToFram:storagePosition[i]];
        storage *oStorage = [[storage alloc] init:frame angle:0 keyPoint:keyPointMap[i]-1 name:@""];

        [self.view addSubview:oStorage];
        [oStorage addTarget:self action:@selector(getKeyPointIndexByClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}




#pragma mark - drawPath method

//画路径，根据需求不同当需要路径小时，就等于是在prospectivePathShapeView上面画，如果是让路径出现就是在pathShapeView上画
- (void)drawPath:(NSMutableArray*)resultArray{
    [self addPointsToView:resultArray];
    ShapeView *tem = nil;
    if (drawOrClear == YES) {
        tem = self.pathBuilderView.pathShapeView;
    }else{
        tem = self.pathBuilderView.prospectivePathShapeView;
    }
    tem.shapeLayer.timeOffset = 0.0;
    tem.shapeLayer.speed = 1.0;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
    animation.fromValue = @0.0;
    animation.toValue = @1.0;
    animation.duration = kDuration;
    
    [tem.shapeLayer addAnimation:animation forKey:NSStringFromSelector(@selector(strokeEnd))];
}

//把zion返回的计算结果添加到pathBuilderView的self.points里面
- (void)addPointsToView:(NSMutableArray*)resultArray{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (int i = 0; i < [resultArray count]; i ++) {
        NSString *tem = [resultArray objectAtIndex:i];
        CGPoint temPoint = CGPointFromString(tem);
        [result addObject:[NSValue valueWithCGPoint:temPoint]];
    }
    [self.pathBuilderView addPointsIn:result shapViewOrNot:drawOrClear];
}

//button点击事件，绑定在每一个货架的button上面
- (IBAction)getKeyPointIndexByClick:(id)sender{
    storage *btn = sender;
    NSNumber *index = [NSNumber numberWithLong:btn.tag];
    if (![choosedPoints containsObject:index]) {
        [choosedPoints addObject:index];
    }
}

//button点击事件，就是点击”Draw Path“ button后触发的事件
- (IBAction)drawNavigationPath: (UIBarButtonItem *) sender{
    // TODO:
    if (drawOrClear == YES) {
        
        NaviAlgo *calPath = [[NaviAlgo alloc] init];
        [calPath setGraph:distanceData];
        [calPath setPointMapping:pointsPosition];
        if([choosedPoints count]!=0){
            self.pathBuilderView.pathShapeView.shapeLayer.path=nil;
            self.pathBuilderView.prospectivePathShapeView.shapeLayer.path=nil;
            pathPoints = [calPath getBestPathForDestinations:choosedPoints];
            [self drawPath:pathPoints];
            [sender setTitle:@"Stop!"];
            drawOrClear = NO;
        }
        else{
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                 message:@"Please choose some destinations"
                                                                delegate:nil
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil];
            [alertView show];
        }
        
    }else{
        [self drawPath:[self SwapAllElementInArray:pathPoints]];
        [self ClearPath];
        [sender setTitle:@"Navigate!"];
    }
    
}

#pragma mark - iBeacon

-(void) startIbeacons{
    if (!_beaconClient) {
        _beaconClient = [[BeaconClient alloc] init];
        [_beaconClient addObserver:self forKeyPath:@"positionArray" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    }
    [_beaconClient openClient];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    float resultX = [[[self.beaconClient valueForKey:@"observeBeacons"] objectAtIndex:0] floatValue];
    float resultY = [[[self.beaconClient valueForKey:@"observeBeacons"] objectAtIndex:1] floatValue];
    if([self CheckSelfPositionAfterCalculate:resultX y:resultY] == NO){
        //如果计算出的点不跟货架重合，就画出来
        [self.pathBuilderView DrawSelf:resultX y:resultY];
    }

}

//-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
//{
//    NSDictionary *ibeaconsDic=[[NSDictionary alloc] initWithObjectsAndKeys:beacons,@"iBeacons",nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"iBeaconsBack" object:Nil userInfo:ibeaconsDic];
//    
//    for (CLBeacon* beacon in beacons) {
//        if ([self CheckBeaconsDataQualifyBeforeCalculate:beacons] == YES) {
//            //如果计算之前的检查没有问题，就开始计算
//            [self drawPosition];
//        }
//    }
//}



#pragma mark - Help method

//把数组元素顺序全部颠倒
- (NSMutableArray*)SwapAllElementInArray:(NSMutableArray*)source{
    int len = [source count];
    for(int i = 0; i < len / 2; i ++){
        NSString *tem = [source objectAtIndex:i];
        [source replaceObjectAtIndex:i withObject:[source objectAtIndex:len-1-i]];
        [source replaceObjectAtIndex:len-1-i withObject:tem];
    }
    return source;
}

//清空路径数据
- (void)ClearPath{

    drawOrClear = YES;
    [pathPoints removeAllObjects];
    [choosedPoints removeAllObjects];
    [self.pathBuilderView Clear];
}


- (CGRect)ConvertToFram:(int[4])array{
    CGRect frame = CGRectMake(array[0], array[1], array[2], array[3]);
    return frame;
}


//判断一个点是不是在货架范围内，也就是走到货架内部了
- (BOOL)CheckSelfPositionAfterCalculate:(float)x y:(float)y{
    for (int i = 0; i < 42; i ++) {
        if ([self JudgePointsInArea:storagePosition[i] point:CGPointMake(x, y)] == YES) {
            return NO;
        }
    }
    return YES;
}


- (BOOL)JudgePointsInArea:(int[])area point:(CGPoint)point{
    CGMutablePathRef pathRef=CGPathCreateMutable();
    CGPathMoveToPoint(pathRef, NULL, area[0], area[1]);
    CGPathAddLineToPoint(pathRef, NULL, area[0], area[1] + area[3]);
    CGPathAddLineToPoint(pathRef, NULL, area[0] + area[2], area[1] + area[3]);
    CGPathAddLineToPoint(pathRef, NULL, area[0] + area[2], area[1]);
    CGPathAddLineToPoint(pathRef, NULL, area[0], area[1]);
    CGPathCloseSubpath(pathRef);
    
    if (CGPathContainsPoint(pathRef, NULL, point, NO)){
        return YES;
    }else{
        return NO;
    }
}
@end
