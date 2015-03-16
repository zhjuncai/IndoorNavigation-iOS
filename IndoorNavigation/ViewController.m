//
//  ViewController.m
//  CalPositionByDistance
//
//  Created by Lc on 15/3/2.
//  Copyright (c) 2015年 Lc. All rights reserved.
//

#import "ViewController.h"
#define SCALE 1024/4.8
#define NUMOFBEACONS 6

@interface ViewController ()
@property (nonatomic, readonly) PathBuilderView *pathBuilderView;
@end


@implementation ViewController
static CFTimeInterval const kDuration = 2.0;
static CFTimeInterval const kPointDiameter = 10;

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
    { 32, 224 }, { 128, 224 },{ 288, 224 }, { 384, 224 }, { 480, 224 }, { 640, 224 },{ 736, 224 },
    { 32, 416 }, { 128, 416 }, { 288, 416 },{ 384, 416 }, { 480, 416 }, { 640, 416 }, { 736, 416 },
    { 32, 608 }, { 128, 608 }, { 288, 608 }, { 384, 608 },{ 480, 608 }, { 640, 608 }, { 736, 608 },
    { 32, 800 },{ 128, 800 }, { 288, 800 }, { 384, 800 }, { 480, 800 },{ 640, 800 }, { 736, 800 },
    { 32, 992 }, { 128, 992 },{ 288, 992 }, { 384, 992 }, { 480, 992 }, { 640, 992 },{ 736, 992 }
};
int storagePosition[40][4] ={
    {64, 64, 144, 64}, {208, 64, 144, 64}, {416, 64, 144, 64}, {560, 64, 144, 64},
    {64, 128, 144, 64}, {208, 128, 144, 64}, {416, 128, 144, 64}, {560, 128, 144, 64},
    {64, 256, 144, 64}, {208, 256, 144, 64}, {416, 256, 144, 64}, {560, 256, 144, 64},
    {64, 320, 144, 64}, {208, 320, 144, 64}, {416, 320, 144, 64}, {560, 320, 144, 64},
    {64, 448, 144, 64}, {208, 448, 144, 64}, {416, 448, 144, 64}, {560, 448, 144, 64},
    {64, 512, 144, 64}, {208, 512, 144, 64}, {416, 512, 144, 64}, {560, 512, 144, 64},
    {64, 640, 144, 64}, {208, 640, 144, 64}, {416, 640, 144, 64}, {560, 640, 144, 64},
    {64, 704, 144, 64}, {208, 704, 144, 64}, {416, 704, 144, 64}, {560, 704, 144, 64},
    {64, 832, 144, 64}, {208, 832, 144, 64}, {416, 832, 144, 64}, {560, 832, 144, 64},
    {64, 896, 144, 64}, {208, 896, 144, 64}, {416, 896, 144, 64}, {560, 896, 144, 64}
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
    [self CalPosition:0 y0:0 r0:1 x1:1 y1:1 r1:1 x2:2 y2:2 r2:2.236067977];
    aIBeacons = [[NSMutableArray alloc] init];
    for (int i = 0; i < NUMOFBEACONS; i ++) {
        iBeacon *test = [[iBeacon alloc] initWithLocation:[NSString stringWithFormat:@"%d", iBeaconPositions[i][0]] y:[NSString stringWithFormat:@"%d", iBeaconPositions[i][1]] idStr:[uuid objectAtIndex:i]];
        [aIBeacons addObject:test];
    }
    
    drawOrClear = YES;
    
    [self viewPrepare];
    [self.pathBuilderView DrawSelf:47 y:47];
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - initView

- (void)viewPrepare{
    self.view = [[PathBuilderView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    points = [[NSMutableArray alloc] init];
    [self CreateWarehouse:keyPointMap storagePosition:storagePosition];
    
    self.pathBuilderView.pathShapeView.shapeLayer.strokeColor = [UIColor blackColor].CGColor;
    self.pathBuilderView.prospectivePathShapeView.shapeLayer.strokeColor = [UIColor grayColor].CGColor;
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
    [drawPathButton addTarget:self action:@selector(beginCalcu) forControlEvents:UIControlEventTouchUpInside];
    drawPathButton.frame = CGRectMake(300, 974, 168, 50);
    [self.view addSubview:drawPathButton];
    
}

- (PathBuilderView *)pathBuilderView
{
    return (PathBuilderView *)self.view;
}

- (CGRect)ConvertToFram:(int[4])array{
    CGRect frame = CGRectMake(array[0], array[1], array[2], array[3]);
    return frame;
}

- (void)CreateWarehouse:(int[40])keyPointMap storagePosition:(int[40][4])storagePosition{
    for (int i = 0; i < 40; i ++) {
        CGRect frame = [self ConvertToFram:storagePosition[i]];
        storage *oStorage = [[storage alloc] init:frame angle:0 keyPoint:keyPointMap[i]-1 name:@""];

        [self.view addSubview:oStorage];
        [oStorage addTarget:self action:@selector(getKeyPointIndexByClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}




#pragma mark - drawPath method

- (void)drawPath:(NSMutableArray*)resultArray points:(int[42][2])pointsArray{
    [self addPointsToView:resultArray points:pointsArray];
    CFTimeInterval timeOffset = self.pathBuilderView.pathShapeView.shapeLayer.timeOffset;
    [CATransaction setCompletionBlock:^{
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
        animation.fromValue = @0.0;
        animation.toValue = @1.0;
        animation.removedOnCompletion = NO;
        animation.duration = kDuration;
        self.pathBuilderView.pathShapeView.shapeLayer.speed = 0;
        self.pathBuilderView.pathShapeView.shapeLayer.timeOffset = 0;
        [self.pathBuilderView.pathShapeView.shapeLayer addAnimation:animation forKey:NSStringFromSelector(@selector(strokeEnd))];
        [CATransaction flush];
        self.pathBuilderView.pathShapeView.shapeLayer.timeOffset = timeOffset;
    }];
    
    self.pathBuilderView.pathShapeView.shapeLayer.timeOffset = 0.0;
    self.pathBuilderView.pathShapeView.shapeLayer.speed = 1.0;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
    animation.fromValue = @0.0;
    animation.toValue = @1.0;
    animation.duration = kDuration;
    
    [self.pathBuilderView.pathShapeView.shapeLayer addAnimation:animation forKey:NSStringFromSelector(@selector(strokeEnd))];
}

- (void)addPointsToView:(NSMutableArray*)resultArray points:(int[42][2])pointsArray{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (int i = 0; i < [resultArray count]; i ++) {
        NSNumber *index = [resultArray objectAtIndex:i];
        int tem = [index intValue];
        CGFloat x = pointsArray[tem][0];
        CGFloat y = pointsArray[tem][1];
        CGPoint temPoint = CGPointMake(x, y);
        [result addObject:[NSValue valueWithCGPoint:temPoint]];
    }
    [self.pathBuilderView addPointsIn:result];
}

- (IBAction)getKeyPointIndexByClick:(id)sender{
    storage *btn = sender;
    NSNumber *index = [NSNumber numberWithUnsignedInt:btn.tag];
    if (![points containsObject:index]) {
        [points addObject:index];
    }
    NSLog(@"ssss %d",[points count]);
}

- (void)beginCalcu{
    // TODO:
    if (drawOrClear == YES) {
        NaviAlgo *calPath = [[NaviAlgo alloc] init];
        points = [calPath getBestPathForGraph:distanceData withDestinations:points];
        [self drawPath:points points:pointsPosition];
        [points removeAllObjects];
        drawOrClear = NO;
    }else{
        drawOrClear = YES;
        
    }
    
}

#pragma mark - Calculate self position

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


- (NSMutableArray *)getData{
    NSData *fileData = [[NSData alloc]init];
    NSUserDefaults *UD = [NSUserDefaults standardUserDefaults];
    if ([UD objectForKey:@"beacons"] == nil) {
        NSString *path;
        path = [[NSBundle mainBundle] pathForResource:@"location" ofType:@"json"];
        fileData = [NSData dataWithContentsOfFile:path];
        [UD setObject:fileData forKey:@"beacons"];
        [UD synchronize];
    }
    else {
        fileData = [UD objectForKey:@"beacons"];
    }
    
    NSDictionary *myData = [NSJSONSerialization JSONObjectWithData:fileData options:NSJSONReadingMutableLeaves error:nil];
    NSDictionary *data = [myData objectForKey:@"beacons"];
    NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:0];
    NSLog(@"内容为--》%@", data);

    return array;
}

#pragma mark - iBeacon

-(void)drawPosition{
    NSMutableDictionary* myBeacons = [[NSMutableDictionary alloc] init];
    myBeacons = [self.beaconClient getMybeaconsArray];
    int distance[6];
    NSMutableArray *tem = [[NSMutableArray alloc] init];
    for(CLBeacon* beacon in myBeacons){
        [tem addObject:beacon];
    }
    int num = [tem count]/3;
    NSMutableArray* resultArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < num; i ++) {
        float x0,y0,r0,x1,y1,r1,x,y,r;
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
    [self.pathBuilderView DrawSelf:resultX y:resultY];
}

-(void) start:(id)sender{
    if (!_beaconClient) {
        _beaconClient = [[BeaconClient alloc] init];
    }
    [_beaconClient openClient];
}

@end
