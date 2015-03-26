//
//  Header.h
//  IndoorNavigation
//
//  Created by Lc on 15/3/20.
//  Copyright (c) 2015年 SAP SE. All rights reserved.
//

#ifndef IndoorNavigation_Header_h
#define IndoorNavigation_Header_h
#define SCALE 916/3    //定义实际距离与屏幕显示房间尺寸的比例尺
#define NUM_OF_BEACONS 5  //定义beacon总数量
#define MAX_DISTANCE 5  //定义可能的最大beacon距离 单位：米
#define MIN_DISTANCE 1  //定义更新坐标的最小值，单位:屏幕像素
#define TIME_LENGTH 0.002 
#define PASS_NUMBER 2
#define AVERAGE_NUM 3  //几次求平均来画位置
#define kIndetifier [[NSBundle mainBundle] bundleIdentifier]

#define ARROW_WIDTH 16
#define ARROW_HEIGHT 10
#endif
