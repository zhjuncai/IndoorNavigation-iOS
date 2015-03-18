//
//  ViewController.h
//  PulsingHaloDemo
//
//  Created by shuichi on 12/5/13.
//  Copyright (c) 2013 Shuichi Tsutsumi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FreightOrder.h"

@interface FreightOrderDetailViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) FreightOrder* freightOrder;


-(IBAction)start:(id)sender;

@end
