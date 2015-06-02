//
//  ViewController.m
//  Demo
//
//  Created by Andrea on 16/04/14.
//  Copyright (c) 2014 Fancy Pixel. All rights reserved.
//

#import "TableViewController.h"
#import "AMWaveTransition.h"
#import "BFPaperCheckbox.h"

@interface TableViewController () <UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, BFPaperCheckboxDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) NSDictionary *dic;
@property (strong, nonatomic) id dest;
@end

@implementation TableViewController
- (IBAction)dismiss:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // check to see if Location Services is enabled, there are two state possibilities:
    // 1) disabled for entire device, 2) disabled just for this app
    //
    NSString *causeStr = nil;
    
    // check whether location services are enabled on the device
    if ([CLLocationManager locationServicesEnabled] == NO)
    {
        causeStr = @"device";
    }
    // check the application’s explicit authorization status:
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        causeStr = @"app";
    }
    
    if (causeStr != nil)
    {
        NSString *alertMessage = [NSString stringWithFormat:@"You currently have location services disabled for this %@. Please refer to \"Settings\" app to turn on Location Services.", causeStr];
        
        UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled"
                                                                        message:alertMessage
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
        [servicesDisabledAlert show];
    }
    
//    [self.navigationController.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]]];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar"] forBarMetrics:UIBarMetricsDefault];
//    [self.view setBackgroundColor:[UIColor clearColor]];
//    UIGraphicsBeginImageContext(self.tableView.frame.size);
//    [[UIImage imageNamed:@"ibeacontablebg.png"] drawInRect:self.tableView.bounds];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
    
//    [self.tableView setBackgroundColor:[UIColor colorWithPatternImage:image]];
//    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
//    [self.navigationController.navigationBar setBackgroundColor:[UIColor blackColor]];
    
    self.title = @"iBeacons of Loading Cargos";
    self.data=[[NSMutableArray alloc] initWithCapacity:[self.freightOrder.foItems count]];
    
//    [self.data addObject:@{@"text": @"Stylized organs", @"icon": @"heart"}];
//    [self.data addObject:@{@"text": @"Food pictures", @"icon": @"camera"}];
//    [self.data addObject:@{@"text": @"Straight line maker", @"icon": @"pencil"}];
//    [self.data addObject:@{@"text": @"Let's cook!", @"icon": @"beaker"}];
//    [self.data addObject:@{@"text": @"That's the puzzle!", @"icon": @"puzzle"}];
//    [self.data addObject:@{@"text": @"Cheers", @"icon": @"glass"}];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMessage:) name:@"iBeaconsBack" object:nil];
}

- (void) viewDidDisappear:(BOOL)animated{
    [self.beaconClient closeClient];
}

- (void) handleMessage:(NSNotification*)nc{
    //解析消息内容
    NSLog(@"%@",[nc.userInfo objectForKey:@"iBeacons"]);
    
    NSSortDescriptor *firstDescriptor = [[NSSortDescriptor alloc] initWithKey:@"accuracy" ascending:YES];
    NSArray *sortDescriptors=[NSArray arrayWithObjects:firstDescriptor, nil];
    NSArray *sortedArray=[[nc.userInfo objectForKey:@"iBeacons"] sortedArrayUsingDescriptors:sortDescriptors];
    
    NSArray* proximityToString = @[@"Unknown", @"Immediate", @"Near", @"Far"];
    [self.data removeAllObjects];
    for (OrderItem *item in self.freightOrder.foItems) {
        NSString *info_1,*info_2,*info_3,*info_4,*info_5;
        info_1 = [NSString stringWithFormat:@"%@",item.itemName];
        info_2 = [NSString stringWithFormat:@"%@",item.major];
        info_3 = [NSString stringWithFormat:@"%@",item.minor];
        info_4 = [NSString stringWithFormat:@"%@",@"> 100m"];
        info_5 = [NSString stringWithFormat:@"%@",@"Unknown"];
        for (CLBeacon* beacon in sortedArray) {
            if ([item.major isEqualToString: [NSString stringWithFormat: @"%@",beacon.major]]&&[item.minor isEqualToString: [NSString stringWithFormat: @"%@",beacon.minor]]) {
                //                NSString * info_1 = [NSString stringWithFormat:@"CargoName:%@",beacon.proximityUUID.UUIDString];
                
                info_4 = [NSString stringWithFormat:@"%0.4f M",beacon.accuracy];
                info_5 = [NSString stringWithFormat:@"%@",proximityToString[beacon.proximity]];
                //        NSString * info_6 = [NSString stringWithFormat:@"rssi:%ld",(long)beacon.rssi];
            }
        }
        [self.data addObject:@{@"cargoName": info_1,@"icon": @"camera",@"major": info_2,@"minor": info_3,@"distance": info_4,@"status": info_5,@"selected":item}];
    }
    
    [self.tableView reloadData];
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setDelegate:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Cargos Details";
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40.f)];
//    UIGraphicsBeginImageContext(self.tableView.frame.size);
//    [[UIImage imageNamed:@"ibeaconcell.png"] drawInRect:self.tableView.bounds];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    [headerView setBackgroundColor:[UIColor colorWithPatternImage:image]];
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 320, 40.f)];
//    label.textColor = [UIColor grayColor];
//    
//    label.text=@"iBeacon Information:";
//    
//    [headerView addSubview:label];
//    return headerView;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CargoTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        cell = [[CargoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
//    UIGraphicsBeginImageContext(self.tableView.frame.size);
//    [[UIImage imageNamed:@"ibeaconcell.png"] drawInRect:self.tableView.bounds];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    [cell setBackgroundColor:[UIColor colorWithPatternImage:image]];
//    
    
//    UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
//    [switchview addTarget:self action:@selector(updateSwitchAtIndexPath:) forControlEvents:UIControlEventValueChanged];
//    cell.accessoryView = switchview;
    
    
    BFPaperCheckbox *checkbox = [[BFPaperCheckbox alloc] initWithFrame:CGRectMake(20, 150, bfPaperCheckboxDefaultRadius * 1, bfPaperCheckboxDefaultRadius * 1)];
    NSDictionary* dict = self.data[indexPath.row];
    OrderItem *orderItem=dict[@"selected"];
    
    checkbox.selectObj=dict;
    checkbox.tag = 1001;
    if ([orderItem.selected isEqualToString:@"selected"]) {
        [checkbox switchStatesAnimated:NO];
        checkbox.selected=true;
    }else{
        checkbox.selected=false;
    }
    checkbox.delegate = self;
    checkbox.row=dict;
    cell.accessoryView=checkbox;
    
    
    cell.distanceLabel.text=dict[@"distance"];
    cell.distanceLabel.textColor = [UIColor blueColor];
    cell.statusLabel.text=dict[@"status"];
    
    cell.majorLabel.text=dict[@"major"];
    cell.minorLabel.text=dict[@"minor"];
    cell.cargoNameLabel.text=dict[@"cargoName"];
    
//    cell.textLabel.text = dict[@"text"];
//    [cell setBackgroundColor:[UIColor clearColor]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//    [cell.imageView setImage:[UIImage imageNamed:dict[@"icon"]]];

    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (void)updateSwitchAtIndexPath:(id)sender {
    
    
    UISwitch *switchView = (UISwitch *)sender;
    
    if ([switchView isOn])
    {
        //do something..
    }
    else
    {
        //do something
        
        
    }
    
}


- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController*)fromVC
                                                 toViewController:(UIViewController*)toVC
{
    if (operation != UINavigationControllerOperationNone) {
        return [AMWaveTransition transitionWithOperation:operation];
    }
    return nil;
}

- (NSArray*)visibleCells
{
    return [self.tableView visibleCells];
}

- (void)dealloc
{
    [self.navigationController setDelegate:nil];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    self.dic=self.data[indexPath.row];
    [self.dest setValue:self.dic forKey:@"exchangeString"];
//    [self.navigationController pushViewController:tableselected animated:YES];
}



#pragma mark - BFPaperCheckbox Delegate
- (void)paperCheckboxChangedState:(BFPaperCheckbox *)checkbox
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyyMMddHHmmss";
    OrderItem *orderItem=checkbox.selectObj[@"selected"];
    
    NSString *trailerUnitID = @"";
    
    if ([self.freightOrder.freightOrderID isEqualToString:@"6100013025"]){
        trailerUnitID = @"800002692";
    }else{
        trailerUnitID = @"800002693";
    }
    
    
    if (checkbox.selected) {
        checkbox.selected=false;
        
       
        [orderItem setSelected:@"unselected"];
        
        
    }else{
        
    }

}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    //将page2设定成Storyboard Segue的目标UIViewController
    
    id page2 = segue.destinationViewController;
    self.dest=page2;
    //将值透过Storyboard Segue带给页面2的string变数
    
    
}




//禁止屏幕旋转
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation

{
    
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
    
}

- (BOOL)shouldAutorotate

{
    
    return NO;
    
}

- (NSUInteger)supportedInterfaceOrientations

{
    
    return UIInterfaceOrientationMaskPortrait;//只支持这一个方向(正常的方向)
    
}


@end

