//
//  CargoTableViewCell.h
//  PulsingHaloDemo
//
//  Created by Ching Hsu on 14-12-19.
//  Copyright (c) 2014年 Shuichi Tsutsumi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CargoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cargoNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *majorLabel;
@property (weak, nonatomic) IBOutlet UILabel *minorLabel;

@end
