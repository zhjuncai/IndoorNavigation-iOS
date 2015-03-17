//
//  PathBuilderView.m
//  AnimatedPath
//
//  Created by Andrew Hershberger on 11/13/13.
//  Copyright (c) 2013 Two Toasters, LLC. All rights reserved.
//

#import "PathBuilderView.h"
#import "ShapeView.h"
#import <CoreLocation/CoreLocation.h>

static CGFloat const kDistanceThreshold = 10.0;
static CGFloat const kPointDiameter = 7.0;

@interface PathBuilderView ()
@property (nonatomic, strong) NSMutableArray *points;
@property (nonatomic, strong) NSValue *prospectivePointValue;
@property (nonatomic) NSUInteger indexOfSelectedPoint;
@property (nonatomic) CGVector touchOffsetForSelectedPoint;
@property (nonatomic, strong) NSTimer *pressTimer;
@property (nonatomic) BOOL ignoreTouchEvents;



@end

@implementation PathBuilderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _points = [[NSMutableArray alloc] init];
        self.multipleTouchEnabled = NO;
        
        _ignoreTouchEvents = NO;
        _indexOfSelectedPoint = NSNotFound;
        
        _pathShapeView = [[ShapeView alloc] init];
        _pathShapeView.shapeLayer.fillColor = nil;
        _pathShapeView.backgroundColor = [UIColor clearColor];
        _pathShapeView.opaque = NO;
        _pathShapeView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_pathShapeView];
        
        _prospectivePathShapeView = [[ShapeView alloc] init];
        _prospectivePathShapeView.shapeLayer.fillColor = nil;
        _prospectivePathShapeView.backgroundColor = [UIColor clearColor];
        _prospectivePathShapeView.opaque = NO;
        _prospectivePathShapeView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_prospectivePathShapeView];
        
        _pointsShapeView = [[ShapeView alloc] init];
        _pointsShapeView.backgroundColor = [UIColor clearColor];
        _pointsShapeView.opaque = NO;
        _pointsShapeView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_pointsShapeView];
        
        
    }
    return self;}

- (void)addPointsIn:(NSMutableArray*)thosePoints{
//    [self.points addObjectsFromArray:thosePoints];
    self.points = thosePoints;
    [self updatePaths];
    
}

#pragma mark - Helper Methods

- (void)updatePaths
{

    if ([self.points count] >= 2) {
        UIBezierPath *path = [[UIBezierPath alloc] init];
        [self.points insertObject:[self.points firstObject] atIndex:0];
        [path moveToPoint:[[self.points firstObject] CGPointValue]];

        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, [self.points count] - 1)];
        [self.points enumerateObjectsAtIndexes:indexSet
                                       options:0
                                    usingBlock:^(NSValue *pointValue, NSUInteger idx, BOOL *stop) {
                                        [path addLineToPoint:[pointValue CGPointValue]];
                                    }];

        self.pathShapeView.shapeLayer.path = path.CGPath;
    }
    else {
//        self.pathShapeView.shapeLayer.path = nil;
    }

    if ([self.points count] >= 1 && self.prospectivePointValue) {
        UIBezierPath *path = [[UIBezierPath alloc] init];
        [path moveToPoint:[[self.points lastObject] CGPointValue]];
        [path addLineToPoint:[self.prospectivePointValue CGPointValue]];

        self.prospectivePathShapeView.shapeLayer.path = path.CGPath;
    }
    else {
//        self.prospectivePathShapeView.shapeLayer.path = nil;
    }
}

- (void)DrawSelf:(float)x y:(float)y{
    UIBezierPath *path = [[UIBezierPath alloc] init];
    CGPoint selfPoint = CGPointMake(x, y);

    [path appendPath:[UIBezierPath bezierPathWithArcCenter:selfPoint radius:kPointDiameter / 2.0 startAngle:0.0 endAngle:2 * M_PI clockwise:YES]];
    
    self.pointsShapeView.shapeLayer.path = path.CGPath;
}

- (void)Clear{
    self.prospectivePathShapeView.shapeLayer.path = nil;
    self.pathShapeView.shapeLayer.path = nil;
    [self.points removeAllObjects];
}



@end
