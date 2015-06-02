//
//  ShelfCargoViewController.h
//  IndoorNavigation
//
//  Created by Ethan Zhang on 3/22/15.
//  Copyright (c) 2015 SAP SE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FreightOrder.h"

@interface ShelfCargoViewController : UITableViewController <UIPopoverPresentationControllerDelegate>

@property (nonatomic, readwrite) OrderItem *cargoItem;
@end
