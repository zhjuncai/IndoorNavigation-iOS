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
    {0, 0}, {768, 0}, {768, 916}, {0, 916}, {384, 204}, {384, 720}
};
@implementation PathBuilderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    NSArray *uuid = [[NSArray alloc] initWithObjects:@"1-1", @"2-1", @"3-1", @"4-1", @"5-1", @"6-1", nil];
//    [self CalPosition:0 y0:0 r0:1 x1:1 y1:1 r1:1 x2:2 y2:2 r2:2.236067977];
    aIBeacons = [[NSMutableArray alloc] init];
    for (int i = 0; i < NUM_OF_BEACONS; i ++) {
        iBeacon *test = [[iBeacon alloc] initWithLocation:[NSString stringWithFormat:@"%d", iBeaconPositions[i][0]] y:[NSString stringWithFormat:@"%d", iBeaconPositions[i][1]] idStr:[uuid objectAtIndex:i]];
        [aIBeacons addObject:test];
    }
    drawOrClear = YES;
    choosedPoints = [[NSMutableArray alloc] init];
    pathPoints = [[NSMutableArray alloc] init];
    storageArray =[[NSMutableArray alloc] init];
    footprintArray = [[NSMutableArray alloc] init];
    
    kDuration = 4.0;
    
    
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
    [builderView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]]];
    [self.view insertSubview:builderView atIndex:0];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self CreateWarehouse:keyPointMap storagePosition:storagePosition];
    
    self.pathBuilderView.pathShapeView.shapeLayer.strokeColor = [UIColor blackColor].CGColor;
    self.pathBuilderView.prospectivePathShapeView.shapeLayer.strokeColor = [UIColor colorWithRed:239 green:240 blue:242 alpha:1].CGColor;
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
        
        UILongPressGestureRecognizer *longPressGR =
        [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                      action:@selector(handleLongPress:)];
        //longPressGR.allowableMovement=NO;
        longPressGR.minimumPressDuration = 0.8;
        [oStorage addGestureRecognizer:longPressGR];

        //响应的事件
      

    }
}

-(IBAction)handleLongPress:(UILongPressGestureRecognizer*)gestureRecognizer{
    
    //storage *button=sender;
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan){
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil
                                                             message:@"test"
                                                            delegate:nil
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil];
        [alertView show];
    }
   
    
}


#pragma mark - drawPath method

//画路径，根据需求不同当需要路径小时，就等于是在prospectivePathShapeView上面画，如果是让路径出现就是在pathShapeView上画
//- (void)drawPath:(NSMutableArray*)resultArray{
//    [self addPointsToView:resultArray];
//    ShapeView *tem = nil;
//    if (drawOrClear == YES) {
//        tem = self.pathBuilderView.pathShapeView;
//    }else{
//        tem = self.pathBuilderView.prospectivePathShapeView;
//    }
//    tem.shapeLayer.timeOffset = 0.0;
//    tem.shapeLayer.speed = 1.0;
//    
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
//    animation.fromValue = @0.0;
//    animation.toValue = @1.0;
//    animation.duration = kDuration;
//    
//    [tem.shapeLayer addAnimation:animation forKey:NSStringFromSelector(@selector(strokeEnd))];
//}

- (void)drawPath:(NSMutableArray*)resultArray{
    BOOL isLeft = YES;
    
    for(int i=0;i<[resultArray count];i++){
        if(i==0){
            
        }
        else{
            CGPoint oldPoint = CGPointFromString([resultArray objectAtIndex:i-1]);
            CGPoint newPoint = CGPointFromString([resultArray objectAtIndex:i]);
            int length = (newPoint.x - oldPoint.x) + (newPoint.y - oldPoint.y);
            int deltaX = newPoint.x - oldPoint.x;
            int deltaY = newPoint.y - oldPoint.y;
            int num = abs(length/30);
            NSString *direction;
            
            if(deltaX>0){
                direction = @"right";
            }
            else if(deltaX<0){
                direction =@"left";
            }
            else if(deltaY >0){
                direction = @"down";
            }
            else if(deltaY){
                direction = @"up";
            }
            
            
            
            for( int j = 0;j<num;j++){
                CALayer *footIcon = [[CALayer alloc] init];
                
                if(isLeft){
                    
                    if(deltaX>0){
                        footIcon.frame = CGRectMake(oldPoint.x+ j*deltaX/num-8 , oldPoint.y+ j*deltaY/num-4-8,18,18);
                        footIcon.contents = (id)[[UIImage imageNamed:@"leftFootprint-right"] CGImage];
                    }
                    else if(deltaX<0){
                        footIcon.frame = CGRectMake(oldPoint.x+ j*deltaX/num -8, oldPoint.y+ j*deltaY/num+4-8,18,18);
                        footIcon.contents = (id)[[UIImage imageNamed:@"leftFootprint-left"] CGImage];
                    }
                    else if(deltaY >0){
                        footIcon.frame = CGRectMake(oldPoint.x+4 + j*deltaX/num -8, oldPoint.y+ j*deltaY/num-8,18,18);
                        footIcon.contents = (id)[[UIImage imageNamed:@"leftFootprint-down"] CGImage];
                    }
                    else if(deltaY){
                        footIcon.frame = CGRectMake(oldPoint.x-4 + j*deltaX/num -8, oldPoint.y+ j*deltaY/num-8,18,18);
                        footIcon.contents = (id)[[UIImage imageNamed:@"leftFootprint-up"] CGImage];
                        
                    }
                    
                    isLeft=!isLeft;
                }
                else{
                    
                    if(deltaX>0){
                        footIcon.frame = CGRectMake(oldPoint.x+ j*deltaX/num-8 , oldPoint.y+ j*deltaY/num+4-8,18,18);
                        footIcon.contents = (id)[[UIImage imageNamed:@"rightFootprint-right"] CGImage];
                    }
                    else if(deltaX<0){
                        footIcon.frame = CGRectMake(oldPoint.x+ j*deltaX/num -8, oldPoint.y+ j*deltaY/num-4-8,18,18);
                        footIcon.contents = (id)[[UIImage imageNamed:@"rightFootprint-left"] CGImage];
                    }
                    else if(deltaY >0){
                        footIcon.frame = CGRectMake(oldPoint.x-4+ j*deltaX/num -8, oldPoint.y+ j*deltaY/num-8,18,18);
                        footIcon.contents = (id)[[UIImage imageNamed:@"rightFootprint-down"] CGImage];
                    }
                    else if(deltaY){
                        footIcon.frame = CGRectMake(oldPoint.x+4 + j*deltaX/num -8, oldPoint.y+ j*deltaY/num-8,18,18);
                        footIcon.contents = (id)[[UIImage imageNamed:@"rightFootprint-up"] CGImage];
                    }
                    isLeft=!isLeft;

                }
                footIcon.hidden = YES;
                [footprintArray addObject:footIcon];
                [self.view.layer addSublayer:footIcon];
                
            }

        }
    }
    

    for(int k=0; k<[footprintArray count];k++){
        NSTimer *myTimer = [NSTimer scheduledTimerWithTimeInterval:0.3*k target:self selector:@selector(drawFootprint:) userInfo:[footprintArray objectAtIndex:k] repeats:NO];
    }
    
}


- (void) drawFootprint:(NSTimer *) myTimer{
    CALayer *footIcon = [myTimer userInfo];
    footIcon.hidden = NO;
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
    if (!btn.isSelected) {
        [choosedPoints addObject:index];
        [storageArray addObject:sender];
        btn.isSelected = YES;
        [btn setBackgroundImage:[UIImage imageNamed:@"selectedShelf"] forState:UIControlStateNormal];
    }
    else{
        [choosedPoints removeObject:index];
        [storageArray removeObject:sender];
        btn.isSelected = NO;
        [btn setBackgroundImage:[UIImage imageNamed:@"shelf"] forState:UIControlStateNormal];
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
            kDuration = [calPath getShortestLength] * TIME_LENGTH;
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
        //[self drawPath:[self SwapAllElementInArray:pathPoints]];
        [self ClearPath];
        [sender setTitle:@"Navigate!"];
        
    }
    
}

#pragma mark - iBeacon

-(void) startIbeacons{
    if (!_beaconClient) {
        _beaconClient = [[BeaconClient alloc] init];
        [_beaconClient addObserver:self forKeyPath:@"positionArray" options:NSKeyValueObservingOptionNew context:NULL];
    }
    [_beaconClient openClient];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    float resultX = [[[self.beaconClient valueForKey:@"positionArray"] objectAtIndex:0] floatValue];
    float resultY = [[[self.beaconClient valueForKey:@"positionArray"] objectAtIndex:1] floatValue];
    if([self CheckSelfPositionAfterCalculate:resultX y:resultY] == NO){
        //如果计算出的点不跟货架重合，就画出来
        [self.pathBuilderView DrawSelf:resultX y:resultY];
    }
//    else{
//        [self.pathBuilderView DrawSelf:resultX-10 y:resultY-10];
//    }
    NSLog(@"sadasdasdasdasdasd");

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
//- (void)ClearPath{
//
//    drawOrClear = YES;
//    for(int i=0;i<[storageArray count];i++){
//        storage* button = [storageArray objectAtIndex:i];
//        if(button.isSelected){
//            [button setBackgroundImage:[UIImage imageNamed:@"shelf"] forState:UIControlStateNormal];
//            button.isSelected = NO;
//        }
//        
//
//    }
//    
//    [storageArray removeAllObjects];
//    [pathPoints removeAllObjects];
//    [choosedPoints removeAllObjects];
//    [self.pathBuilderView Clear];
//}
- (void)ClearPath{
    drawOrClear = YES;
    
        for(int i=0;i<[storageArray count];i++){
            storage* button = [storageArray objectAtIndex:i];
            if(button.isSelected){
                [button setBackgroundImage:[UIImage imageNamed:@"shelf"] forState:UIControlStateNormal];
                button.isSelected = NO;
            }
    
    
        }
    
    
    for(int k=0; k<[footprintArray count];k++){
        NSTimer *myTimer = [NSTimer scheduledTimerWithTimeInterval:0.3*k target:self selector:@selector(clearFootprint:) userInfo:[footprintArray objectAtIndex:k] repeats:NO];
    }
    
    //[footprintArray removeAllObjects];
    [storageArray removeAllObjects];
    [pathPoints removeAllObjects];
    [choosedPoints removeAllObjects];
    [self.pathBuilderView Clear];
}

- (void) clearFootprint:(NSTimer *) myTimer{
    CALayer * footIcon = [myTimer userInfo];
    footIcon.hidden =YES;
    [footprintArray removeObject:footIcon];
    
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
