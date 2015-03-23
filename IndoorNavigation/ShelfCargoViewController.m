//
//  ShelfCargoViewController.m
//  IndoorNavigation
//
//  Created by Ethan Zhang on 3/22/15.
//  Copyright (c) 2015 SAP SE. All rights reserved.
//

#import "ShelfCargoViewController.h"

@interface ShelfCargoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *cargoNameLabel;
@end

@implementation ShelfCargoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.preferredContentSize = CGSizeMake(200 , 35);
}

- (void)configCargoName:(NSString *)cargoName {
    self.cargoNameLabel.text = cargoName;
}

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    return YES;
}

@end
