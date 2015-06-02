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


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.preferredContentSize = CGSizeMake(200 , 50);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 3.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 2.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"PopoverCargoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.imageView.image = [UIImage imageNamed:self.cargoItem.productImage];
    cell.textLabel.text = self.cargoItem.itemName;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@ %@",
                                 _cargoItem.itemType, _cargoItem.quantity, _cargoItem.unitOfMeasure];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
    
    return cell;
}

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    return YES;
}

@end
