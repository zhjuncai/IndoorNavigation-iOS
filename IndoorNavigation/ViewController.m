//
//  ViewController.m
//  CalPositionByDistance
//
//  Created by Lc on 15/3/2.
//  Copyright (c) 2015年 Lc. All rights reserved.
//

#import "ViewController.h"
#define SCALE 1024/4.8    //定义实际距离与屏幕显示房间尺寸的比例尺
#define NUM_OF_BEACONS 6  //定义beacon总数量
#define MAX_DISTANCE 3  //定义可能的最大beacon距离 单位：米
#define MIN_DISTANCE 1  //定义更新坐标的最小值，单位:屏幕像素

@interface ViewController ()  <CLLocationManagerDelegate>
@property (nonatomic, readonly) PathBuilderView *pathBuilderView;
@property (nonatomic , strong) CLLocationManager *locationManager;
@property (nonatomic , strong) NSOperationQueue *queue;
@property (nonatomic , strong) CALayer *naviIcon;
@end


@implementation ViewController
static CFTimeInterval const kDuration = 4.0;

int distanceData[42][42] = {
    // 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42
    { 0, 3, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },//1
    { 3, 0, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },//2
    { 0, 5, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },//3
    { 0, 0, 3, 0, 3, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },//4
    { 0, 0, 0, 3, 0, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },//5
    { 0, 0, 0, 0, 5, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },//6
    { 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },//7
    { 6, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },//8
    { 0, 0, 0, 0, 0, 0, 0, 3, 0, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },//9
    { 0, 0, 0, 0, 0, 0, 0, 0, 5, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },//10
    { 0, 0, 0, 6, 0, 0, 0, 0, 0, 3, 0, 3, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },//11
    { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },//12
    { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },//13
    { 0, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },//14
    { 0, 0, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },//15
    { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },//16
    { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },//17
    { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 3, 0, 3, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },//18
    { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },//19
    { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },//20
    { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },//21
    { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },//22
    { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },//23
    { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },//24
    { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 3, 0, 3, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },//25
    { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },//26
    { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },//27
    { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 0, 0, },//28
    { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 0, },//29
    { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },//30
    { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },//31
    { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 3, 0, 3, 0, 0, 0, 0, 0, 6, 0, 0, 0, },//32
    { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 5, 0, 0, 0, 0, 0, 0, 0, 0, },//33
    { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 0, 3, 0, 0, 0, 0, 0, 0, 0, },//34
    { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 6, },//35
    { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, },//36
    { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 5, 0, 0, 0, 0, },//37
    { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 0, 3, 0, 0, 0, },//38
    { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 3, 0, 3, 0, 0, },//39
    { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 5, 0, },//40
    { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 0, 3, },//41
    { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 3, 0, }//42
    // 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42
    
};

int pointsPosition[42][2] = {
    { 32, 32 }, { 128, 32 }, { 288, 32 }, { 384, 32 },{ 480, 32 }, { 640, 32 }, { 736, 32 },
    { 32, 204 }, { 128, 204 },{ 288, 204 }, { 384, 204 }, { 480, 204 }, { 640, 204 },{ 736, 204 },
    { 32, 376 }, { 128, 376 }, { 288, 376 },{ 384, 376 }, { 480, 376 }, { 640, 376 }, { 736, 376 },
    { 32, 548 }, { 128, 548 }, { 288, 548 }, { 384, 548 },{ 480, 548 }, { 640, 548 }, { 736, 548 },
    { 32, 720 },{ 128, 720 }, { 288, 720 }, { 384, 720 }, { 480, 720 },{ 640, 720 }, { 736, 720 },
    { 32, 892 },{ 128, 892 },{ 288, 892 }, { 384, 892 }, { 480, 892 },{ 640, 892 },{ 736, 892 }
};

int storagePosition[40][4] ={
    { 64, 64, 144, 54 }, { 208, 64, 144, 54 },{ 416, 64, 144, 54 }, { 560, 64, 144, 54 },
    { 64, 118, 144, 54 },{ 208, 118, 144, 54 }, { 416, 118, 144, 54 },{ 560, 118, 144, 54 },
    { 64, 236, 144, 54 }, { 208, 236, 144, 54 },{ 416, 236, 144, 54 }, { 560, 236, 144, 54 },
    { 64, 290, 144, 54 },{ 208, 290, 144, 54 }, { 416, 290, 144, 54 },{ 560, 290, 144, 54 },
    { 64, 408, 144, 54 }, { 208, 408, 144, 54 },{ 416, 408, 144, 54 }, { 560, 408, 144, 54 },
    { 64, 462, 144, 54 },{ 208, 462, 144, 54 }, { 416, 462, 144, 54 },{ 560, 462, 144, 54 },
    { 64, 580, 144, 54 }, { 208, 580, 144, 54 },{ 416, 580, 144, 54 }, { 560, 580, 144, 54 },
    { 64, 634, 144, 54 },{ 208, 634, 144, 54 }, { 416, 634, 144, 54 },{ 560, 634, 144, 54 },
    { 64, 752, 144, 54 }, { 208, 752, 144, 54 },{ 416, 752, 144, 54 }, { 560, 752, 144, 54 },
    { 64, 806, 144, 54 },{ 208, 806, 144, 54 }, { 416, 806, 144, 54 }, { 560, 806, 144, 54 }
};
int keyPointMap[40] = {
    2, 3, 5, 6,
    9, 10, 12, 13,
    9, 10, 12, 13,
    16,17, 19, 20,
    16,17, 19, 20,
    23, 24, 26, 27,
    23, 24, 26, 27,
    30, 31, 33, 34,
    30, 31, 33, 34,
    37, 38, 40, 41
};

int iBeaconPositions[6][2] = {
    {0, 0}, {0, 512}, {0, 1024}, {768, 0}, {768, 512}, {768, 1024}
};

- (void)viewDidLoad {
    NSArray *uuid = [[NSArray alloc] initWithObjects:@"first", @"sec", @"third", @"fourth", @"fifth", @"sixth", nil];
//    [self CalPosition:0 y0:0 r0:1 x1:1 y1:1 r1:1 x2:2 y2:2 r2:2.236067977];
    aIBeacons = [[NSMutableArray alloc] init];
    for (int i = 0; i < NUM_OF_BEACONS; i ++) {
        iBeacon *test = [[iBeacon alloc] initWithLocation:[NSString stringWithFormat:@"%d", iBeaconPositions[i][0]] y:[NSString stringWithFormat:@"%d", iBeaconPositions[i][1]] idStr:[uuid objectAtIndex:i]];
        [aIBeacons addObject:test];
    }
    
    drawOrClear = YES;
    choosedPoints = [[NSMutableArray alloc] init];
    pathPoints = [[NSMutableArray alloc] init];
    iBeaconsFromDetectDic = [[NSMutableDictionary alloc] init];
    
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
    
    
    
    
    
    //箭头的manager
    if ([CLLocationManager headingAvailable]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        [self.locationManager startUpdatingHeading];
    }
    self.naviIcon = [[CALayer alloc] init];
    self.naviIcon.frame = CGRectMake(369, 892,30,30);
    self.naviIcon.contents = (id)[[UIImage imageNamed:@"location.png"] CGImage];
    [self.view.layer addSublayer:self.naviIcon];
    
    
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - initView

- (void)viewPrepare{
    self.view = [[PathBuilderView alloc] initWithFrame:CGRectMake(0, 64, 768, 920)];
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
    
    UIButton *drawPathButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [drawPathButton setTitle:NSLocalizedString(@"Draw Path", nil) forState:UIControlStateNormal];
    [drawPathButton addTarget:self action:@selector(beginCalcuAndDraw) forControlEvents:UIControlEventTouchUpInside];
    drawPathButton.frame = CGRectMake(300, 974, 168, 50);
    [self.view addSubview:drawPathButton];
    
}

- (PathBuilderView *)pathBuilderView
{
    return (PathBuilderView *)self.view;
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
- (void)beginCalcuAndDraw{
    // TODO:
    if (drawOrClear == YES) {
        NaviAlgo *calPath = [[NaviAlgo alloc] init];
        [calPath setGraph:distanceData];
        [calPath setPointMapping:pointsPosition];
        pathPoints = [calPath getBestPathForDestinations:choosedPoints];
        [self drawPath:pathPoints];
        drawOrClear = NO;
    }else{
        [self drawPath:[self SwapAllElementInArray:pathPoints]];
        [self ClearPath];
    }
    
}


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

#pragma mark - draw self position

-(void)drawPosition{
    NSMutableDictionary* myBeacons = [[NSMutableDictionary alloc] init];
//    myBeacons = [self.beaconClient getMybeaconsArray];
    myBeacons = iBeaconsFromDetectDic;
    NSMutableArray *tem = [[NSMutableArray alloc] init];
    for(CLBeacon* beacon in myBeacons){
        [tem addObject:beacon];
    }
    int num = [tem count]/3;
    NSMutableArray* resultArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < num; i ++) {
        float x0 = 0.0,y0 = 0.0,r0 = 0.0,x1 = 0.0,y1 = 0.0,r1 = 0.0,x = 0.0,y = 0.0,r = 0.0;
        CLBeacon* beacon0 = [tem objectAtIndex:3*i];
        CLBeacon* beacon1 = [tem objectAtIndex:3*i + 1];
        CLBeacon* beacon2 = [tem objectAtIndex:3*i + 2];
        for(iBeacon *myBeacon in aIBeacons){
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
    float resultX = 0;
    float resultY = 0;

    for (int i = 0; i < num; i ++) {
        NSArray* tem = [resultArray objectAtIndex:i];
        float temX = [[tem objectAtIndex:0] floatValue];
        float temY = [[tem objectAtIndex:1] floatValue];
        resultX += temX;
        resultY += temY;
    }
    
    resultX = resultX/num;
    resultY = resultY/num;
    if([self CheckSelfPositionAfterCalculate:resultX y:resultY] == NO){
        //如果计算出的点不跟货架重合，就画出来
        [self.pathBuilderView DrawSelf:resultX y:resultY];
    }
}

#pragma mark - iBeacon

-(void) startIbeacons{
    if (!_beaconClient) {
        _beaconClient = [[BeaconClient alloc] init];
    }
    [_beaconClient openClient];
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    NSDictionary *ibeaconsDic=[[NSDictionary alloc] initWithObjectsAndKeys:beacons,@"iBeacons",nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"iBeaconsBack" object:Nil userInfo:ibeaconsDic];
    
    for (CLBeacon* beacon in beacons) {
        if ([self CheckBeaconsDataQualifyBeforeCalculate:beacons] == YES) {
            //如果计算之前的检查没有问题，就开始计算
            [self drawPosition];
        }
    }
}

#pragma mark - self location icon delegate

-(void) locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
    
    CGFloat headings = M_PI*newHeading.trueHeading/180.0f;
    //CGFloat headings = newHeading.trueHeading;
    CABasicAnimation* anim = [CABasicAnimation animationWithKeyPath:@"transform"];
    
    CATransform3D fromValue = self.naviIcon.transform;
    anim.fromValue = [NSValue valueWithCATransform3D:fromValue];
    
    CATransform3D toValue = CATransform3DMakeRotation(headings, 0, 0, 1);
    anim.toValue = [NSValue valueWithCATransform3D:toValue];
    anim.duration = 0.2;
    anim.removedOnCompletion = YES;
    self.naviIcon.transform = toValue;
    [self.naviIcon addAnimation:anim forKey:nil];
    
    
}

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


//检查beacon的距离是不是已经超出 MAX_DISTANCE，移动距离是不是过小
- (BOOL)CheckBeaconsDataQualifyBeforeCalculate:(NSArray *)beacons{
    int wrongNum = 0;
    
    for (CLBeacon* beacon in beacons) {
        NSString *str=[NSString stringWithFormat:@"%i-%i",[beacon.major intValue],[beacon.minor intValue]];
        if (beacon.accuracy > MAX_DISTANCE) {
            wrongNum ++;
        }else{
            for (CLBeacon* preBeacon in iBeaconsFromDetectDic){
                if (beacon.major == preBeacon.minor && beacon.major == preBeacon.major) {
                    if (fabs(preBeacon.accuracy - beacon.accuracy) * SCALE < MIN_DISTANCE) {
                        wrongNum ++;
                    }else{
                        [iBeaconsFromDetectDic setObject:beacon forKey:str];
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
