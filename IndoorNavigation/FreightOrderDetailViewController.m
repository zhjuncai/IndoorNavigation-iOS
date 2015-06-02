//
//  ViewController.m
//  PulsingHaloDemo
//
//  Created by shuichi on 12/5/13.
//  Copyright (c) 2013 Shuichi Tsutsumi. All rights reserved.
//

#import "FreightOrderDetailViewController.h"
#import "PulsingHaloLayer.h"
#import "AMWaveTransition.h"
#import "BeaconClient.h"

#import <CFNetwork/CFNetwork.h>
#import "PathBuilderViewController.h"

#define kMaxRadius 160


@interface FreightOrderDetailViewController () <UINavigationControllerDelegate>

@property (nonatomic,strong)BeaconClient *beaconClient;
@property (nonatomic, strong) PulsingHaloLayer *halo;

@property (weak, nonatomic) IBOutlet UIImageView *beaconView;

@property (nonatomic, weak) UISlider *radiusSlider;
@property (nonatomic, weak) UISlider *rSlider;
@property (nonatomic, weak) UISlider *gSlider;
@property (nonatomic, weak) UISlider *bSlider;

@property (nonatomic,strong) NSMutableArray *storageIndexArray;




//tableview
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *footView;

@end


@implementation FreightOrderDetailViewController
NSArray *detailLabels;
NSArray *detailValues;

NSArray *itemLabels;
NSArray *itemValues;


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Freight Order Details";
//    UIImage *bgImage=[UIImage imageNamed:@"DarkBlueStainlesssteel.jpg"];
    
//    
//    UIImage *bgImage=[UIImage imageNamed:@"orderviewbg.png"];
//    self.tableView.backgroundColor=[UIColor colorWithPatternImage:bgImage]; 
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"appBackground"]];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = [UIColor clearColor];
    self.halo = [PulsingHaloLayer layer];
    

    CGPoint point=self.beaconView.center;
    
    point.y=self.beaconView.superview.superview.frame.size.height-self.beaconView.superview.frame.size.height-10;
    point.x=self.beaconView.superview.superview.frame.size.width/2;
    self.halo.position = point;
    
    [self.view.layer insertSublayer:self.halo below:self.beaconView.layer];
    [self setupInitialValues];
    
    
    FreightOrder *order=[FreightOrder freightOrderWithID:@"6100013026"];
    self.freightOrder = order;
//    FreightOrder *order = self.freightOrder;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = kCFDateFormatterFullStyle;
    dateFormatter.timeStyle = kCFDateFormatterFullStyle;
    
    detailLabels = @[@"Freight Order ID", @"Shipper", @"Consignee", @"Driver", @"Pickup Date", @"Delivery Date", @"Delivery Address"];
    detailValues = @[order.freightOrderID, order.shipper, order.consignee, order.driver,
                     [dateFormatter stringFromDate:order.pickupDatetime],
                     [dateFormatter stringFromDate:order.deliveryDatetime], order.deliveryAddress];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.storageIndexArray = [[NSMutableArray alloc] init];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void) start:(id)sender{
    if (!_beaconClient) {
        _beaconClient = [[BeaconClient alloc] init];
    }
//    _beaconClient.freightOrder=self.freightOrder;
    [_beaconClient openClient];
//    TableViewController *ibeacontablew = [self.storyboard instantiateViewControllerWithIdentifier:@"ibeacontableview"];
//    
//    [self.navigationController pushViewController:ibeacontablew animated:YES];
}

// =============================================================================
#pragma mark - Private

- (void)setupInitialValues {

    self.radiusSlider.value = 0.5;    
    self.rSlider.value = 0;
    self.gSlider.value = 0.487;
    self.bSlider.value = 1.0;

}


// =============================================================================
#pragma mark - IBAction


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.f;
}

//- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    if (section == 0) {
//        return  @"Order Details Info";
//    }else{
//        return  @"Items";
//    }
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return 44.f;
    }else{
        return 60.f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    CGFloat width = CGRectGetWidth(self.tableView.frame);
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 40.f)];
    headerView.backgroundColor  = [UIColor clearColor];
    
//    [headerView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"orderheader.png"]]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, width, 40.f)];
    label.textColor = [UIColor whiteColor];
    
    if (section == 0) {
        label.text = @"Order Details Info";
    }else{
        label.text = @"Items";
    }
    
    [headerView addSubview:label];
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0) {
        return [detailLabels count];
    }else{
        return [self.freightOrder.foItems count];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 30, 0, 30);
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:insets];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:insets];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = @"OrderDetailCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    }
    
    [cell setBackgroundColor: [UIColor clearColor]];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    if (indexPath.section == 0) {
        cell.textLabel.text = detailLabels[indexPath.row];
        cell.detailTextLabel.text = detailValues[indexPath.row];
    }else{
        OrderItem *orderItem = self.freightOrder.foItems[indexPath.row];
        cell.textLabel.text = orderItem.itemName;
        int shelfPosition = (arc4random() % 24) + 1;
        
        while([self.storageIndexArray containsObject:[NSNumber numberWithInteger:shelfPosition]]){
            shelfPosition = (arc4random() % 24) + 1;
        }
        
        [self.storageIndexArray addObject:[NSNumber numberWithInteger:shelfPosition]];
        
        cell.tag = shelfPosition;
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@ at Shelf %d", orderItem.quantity, orderItem.unitOfMeasure, shelfPosition];
        
        cell.imageView.image = [UIImage imageNamed: @"hierarchy"];
//        [UIImage imageNamed:orderItem.productImage];
    }
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"segueDetectDistance"]){
        UINavigationController *beaconNavController = segue.destinationViewController;
        PathBuilderViewController *pathBuilderVC = [beaconNavController.viewControllers firstObject];
//        beaconVC.freightOrder=self.freightOrder;
//        beaconVC.beaconClient=_beaconClient;
        
        // here determine number of cargo item position
        
        
        
        NSInteger itemSection = 1;
        NSInteger numberOfItems = [self.tableView numberOfRowsInSection:itemSection];
        NSMutableArray * chosenShelfPosition = [[NSMutableArray alloc] initWithCapacity:numberOfItems];
        
        NSMutableDictionary *cargoItems = [[NSMutableDictionary alloc] initWithCapacity:numberOfItems];
        
        for (int row = 0; row < numberOfItems; row++) {
            UITableViewCell *foCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:itemSection]];
            NSInteger shelfPosition = foCell.tag;
            [chosenShelfPosition addObject:[NSNumber numberWithInteger:shelfPosition]];
            
            OrderItem *orderItem = self.freightOrder.foItems[row];
            [cargoItems setObject:orderItem forKey:[NSNumber numberWithInteger:shelfPosition]];
        }
        
        pathBuilderVC.choosedStorages = chosenShelfPosition;
        pathBuilderVC.freightOrderCargoItems = cargoItems;
    }
             
}


@end
