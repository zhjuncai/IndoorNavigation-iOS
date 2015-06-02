//
//  ViewController.m
//  LoadingPlan
//
//  Created by Ethan Zhang on 12/13/14.
//  Copyright (c) 2014 SAP SE. All rights reserved.
//

#import "ScanViewController.h"
#import "FreightOrderDetailViewController.h"
#import "YALContextMenuTableView.h"
#import "YALNavigationBar.h"
#import "ContextMenuCell.h"
#define CUSTOM_BUTTON_ID 100

static NSString *const menuCellIdentifier = @"rotationCell";

@interface ScanViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
YALContextMenuTableViewDelegate
>
{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *bbitemStart;
@property (weak, nonatomic) IBOutlet UIView *viewPreview;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;


@property (nonatomic) BOOL isReading;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@property (nonatomic, retain) UIImageView * line;



@property (nonatomic, strong) YALContextMenuTableView* contextMenuTableView;
@property (nonatomic, strong) NSArray *menuTitles;
@property (nonatomic, strong) NSArray *menuIcons;


-(void)loadBeepSound;

@end

@implementation ScanViewController{
    AAShareBubbles *shareBubbles;
    float radius;
    float bubbleRadius;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    radius = 130;
    bubbleRadius = 40;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"Indoor Explorer";
    UIImage *scanviewbg=[UIImage imageNamed:@"scanviewbg"];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:scanviewbg]];
    
    [self initiateMenuOptions];
    [self.navigationController setValue:[[YALNavigationBar alloc]init] forKeyPath:@"navigationBar"];
    self.isReading = NO;
    self.captureSession = nil;
    [self loadBeepSound];
}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    //should be called after rotation animation completed
    [self.contextMenuTableView reloadData];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    [self.contextMenuTableView updateAlongsideRotation];
}

- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    
    [coordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        //should be called after rotation animation completed
        [self.contextMenuTableView reloadData];
    }];
    [self.contextMenuTableView updateAlongsideRotation];
    
}



- (IBAction)startStopReading:(id)sender {
    
    if(!self.isReading){
        if ([self startReading]) {
            self.bbitemStart.title = @"Cancel";
        }
    }else{
        [self stopReading];
        self.bbitemStart.title = @"Scan";
    }
}

- (BOOL)startReading{
    
//    self.viewPreview.backgroundColor=[UIColor clearColor];
    NSError *error;
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    self.captureSession = [[AVCaptureSession alloc] init];
    [self.captureSession addInput:input];
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [self.captureSession addOutput:captureMetadataOutput];
    
//    dispatch_queue_t dispatchQueue;
//    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    self.videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    self.videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    
//    self.videoPreviewLayer.frame = self.viewPreview.layer.bounds;
//    self.videoPreviewLayer.borderColor = [UIColor redColor].CGColor;
//    self.videoPreviewLayer.borderWidth = 4;
//    self.videoPreviewLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
//    self.videoPreviewLayer.opacity = .5;
//    self.videoPreviewLayer.opaque = YES;
    
    
    
    
    
    
    CGFloat imageWidth = 400.f, imageHeight = imageWidth;
    CGFloat positionX = ( CGRectGetWidth(self.view.frame) - imageWidth ) / 2;
    CGFloat positionY = ( CGRectGetHeight(self.view.frame) - imageHeight ) / 2.5;
    
    
    UILabel * labIntroudction= [[UILabel alloc] initWithFrame:CGRectMake(positionX + 50, positionY - 80, 400, 50)];
    labIntroudction.tag = 2000;
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.numberOfLines=2;
    labIntroudction.textColor=[UIColor whiteColor];
//    labIntroudction.text=@"将二维码图像置于矩形方框内，离手机摄像头10CM左右，系统会自动识别。";
    
    labIntroudction.text=@"Place your QR Code inside the square.";
//    [self.viewPreview insertSubview:labIntroudction atIndex:0];
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(positionX, positionY, imageWidth, imageHeight)];
    
    imageView.tag = 1000;
    imageView.image = [UIImage imageNamed:@"pick_bg"];
    
//    CALayer *lightGrayLayer = [CALayer layer];
//    lightGrayLayer.frame = imageView.layer.bounds;
//    lightGrayLayer.backgroundColor = [UIColor clearColor].CGColor;
//    lightGrayLayer.borderColor = [UIColor greenColor].CGColor;
//    lightGrayLayer.borderWidth = 1;
//    lightGrayLayer.opacity = .5;
//    lightGrayLayer.opaque = NO;
    
//    [self.viewPreview.layer addSublayer:lightGrayLayer];
    
    self.videoPreviewLayer.frame = self.viewPreview.bounds;
//    self.videoPreviewLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
//    self.videoPreviewLayer.opacity = .5;
//    self.videoPreviewLayer.opaque = YES;
    
    [self.viewPreview.layer addSublayer:self.videoPreviewLayer];
    
//    AVCaptureVideoPreviewLayer *copiedLayer = [self.videoPreviewLayer copy];
//    copiedLayer.bounds = imageView.bounds;
//    copiedLayer.borderColor = [UIColor greenColor].CGColor;
//    copiedLayer.borderWidth = 1;
    
//    [self.viewPreview.layer addSublayer:copiedLayer];
    
    [self.viewPreview addSubview:labIntroudction];
    [self.viewPreview addSubview:imageView];
    
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(positionX, 350, imageWidth, 2)];
    _line.image = [UIImage imageNamed:@"line.png"];
    [self.view addSubview:_line];
    
    [UIView animateKeyframesWithDuration:2 delay:0 options:UIViewKeyframeAnimationOptionRepeat animations:^{
        //
        CGRect frame = _line.frame;
        
        frame.origin.y = frame.origin.y + 300;
        frame.origin.y = MAX(frame.origin.y, imageView.frame.origin.y);
    
        
        _line.frame = frame;
    } completion:^(BOOL finished) {
        _line.frame = CGRectMake(positionX, 300, imageWidth, 2);
    }];
    
//    timer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    
    [self.captureSession startRunning];
    self.isReading = YES;
    
    return YES;
}


-(void)animation1
{
    
    CGRect frame = _line.frame;
    
    if (frame.origin.y <= 650) {
        frame.origin.y = frame.origin.y + 10;
        _line.frame = frame;
    }else{
        frame.origin.y = 350;
        _line.frame = frame;
    }
    
//    if (upOrdown == NO) {
//        num ++;
//        _line.frame = CGRectMake(184, 290 + 2*num, 400, 2);
//        if (2*num == 400) {
//            upOrdown = YES;
//        }
//    }
//    else {
//        num --;
//        _line.frame = CGRectMake(184, 290 + 2*num, 400, 2);
//        if (num == 0) {
//            upOrdown = NO;
//        }
//    }
    
}

- (void)stopReading{
    [self.captureSession stopRunning];
    self.captureSession = nil;
    self.isReading = NO;
    self.bbitemStart.title = @"Start!";
    [self.videoPreviewLayer removeFromSuperlayer];
    
    [timer invalidate];
    
    UIImageView * instructorView = (UIImageView *)[self.view viewWithTag:1000];
    [instructorView removeFromSuperview];
    
    UILabel * instructorLabel = (UILabel *)[self.view viewWithTag:2000];
    [instructorLabel removeFromSuperview];
    
    [_line removeFromSuperview];
}

- (void)loadBeepSound{
    NSString *beepFilePath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"mp3"];
    NSURL *beepURL = [NSURL URLWithString:beepFilePath];
    NSError *error;
    
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:beepURL error:&error];
    if (error) {
        NSLog(@"Could not play beep file.");
        NSLog(@"%@", [error localizedDescription]);
    }
    else{
        [_audioPlayer prepareToPlay];
    }
}

- (void)showFreightOrder:(NSString *) freightOrderId{
//    FreightOrder *freightOrder = [FreightOrder freightOrderWithID:freightOrderId];
    FreightOrder *freightOrder = [FreightOrder freightOrderWithID:freightOrderId];
    
    if (freightOrder) {
        FreightOrderDetailViewController *orderDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderDetailViewController"];
        orderDetailVC.freightOrder = freightOrder;
    
        [self.navigationController pushViewController:orderDetailVC animated:YES];
    }else{
        
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Freight Order Not Found"
                                                             message:@"Sorry, the QR Code doesn't contain an valid freight order."
                                                            delegate:nil
                                                   cancelButtonTitle:@"Got it"
                                                   otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    NSLog(@"Call captureOutput");
    
    NSString *freightOrderID = nil;
    
    [self stopReading];
    
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        
        if ([metadataObj.type isEqualToString: AVMetadataObjectTypeQRCode]) {
            
            freightOrderID = metadataObj.stringValue;
            
            if (self.audioPlayer) {
                [self.audioPlayer play];
            }
        }
    }
    [self showFreightOrder:freightOrderID];
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

- (IBAction)shareTapped:(id)sender
{
    if(shareBubbles) {
        shareBubbles = nil;
    }
    shareBubbles = [[AAShareBubbles alloc] initWithPoint:_shareButton.center radius:radius inView:self.view];
    shareBubbles.delegate = self;
    shareBubbles.bubbleRadius = bubbleRadius;
//    shareBubbles.showFacebookBubble = YES;
//    shareBubbles.showTwitterBubble = YES;
//    shareBubbles.showGooglePlusBubble = YES;
//    shareBubbles.showTumblrBubble = YES;
//    shareBubbles.showVkBubble = YES;
//    shareBubbles.showLinkedInBubble = YES;
//    shareBubbles.showYoutubeBubble = YES;
//    shareBubbles.showVimeoBubble = YES;
//    shareBubbles.showRedditBubble = YES;
//    shareBubbles.showPinterestBubble = YES;
    shareBubbles.showInstagramBubble = YES;
    shareBubbles.showWhatsappBubble = YES;
    shareBubbles.showMailBubble = YES;
    shareBubbles.showQRBubble = YES;
//    shareBubbles.showMsgBubble = YES;
    shareBubbles.showShareBubble= YES;
    shareBubbles.showWhatsappBubble =YES;
    
    [shareBubbles addCustomButtonWithIcon:[UIImage imageNamed:@"custom-vine-icon"]
                          backgroundColor:[UIColor colorWithRed:0.0 green:164.0/255.0 blue:120.0/255.0 alpha:1.0]
                              andButtonId:CUSTOM_BUTTON_ID];
    
    [shareBubbles show];
}


#pragma mark AAShareBubbles

-(void)aaShareBubbles:(AAShareBubbles *)shareBubbles tappedBubbleWithType:(int)bubbleType
{
    switch (bubbleType) {
        case AAShareBubbleTypeFacebook:
            NSLog(@"Facebook");
            break;
        case AAShareBubbleTypeTwitter:
            NSLog(@"Twitter");
            break;
        case AAShareBubbleTypeGooglePlus:
            NSLog(@"Google+");
            break;
        case AAShareBubbleTypeTumblr:
            NSLog(@"Tumblr");
            break;
        case AAShareBubbleTypeVk:
            NSLog(@"Vkontakte (vk.com)");
            break;
        case AAShareBubbleTypeLinkedIn:
            NSLog(@"LinkedIn");
            break;
        case AAShareBubbleTypeYoutube:
            NSLog(@"Youtube");
            break;
        case AAShareBubbleTypeVimeo:
            NSLog(@"Vimeo");
            break;
        case AAShareBubbleTypeReddit:
            NSLog(@"Reddit");
            break;
        case CUSTOM_BUTTON_ID:
            NSLog(@"Custom Button With Type %d", bubbleType);
            break;
        default:
            break;
    }
}




#pragma mark - IBAction

- (IBAction)presentMenuButtonTapped:(UIBarButtonItem *)sender {
    // init YALContextMenuTableView tableView
    if (!self.contextMenuTableView) {
        self.contextMenuTableView = [[YALContextMenuTableView alloc]initWithTableViewDelegateDataSource:self];
        self.contextMenuTableView.animationDuration = 0.15;
        //optional - implement custom YALContextMenuTableView custom protocol
        self.contextMenuTableView.yalDelegate = self;
        
        //register nib
        UINib *cellNib = [UINib nibWithNibName:@"ContextMenuCell" bundle:nil];
        [self.contextMenuTableView registerNib:cellNib forCellReuseIdentifier:menuCellIdentifier];
    }
    
    // it is better to use this method only for proper animation
    [self.contextMenuTableView showInView:self.navigationController.view withEdgeInsets:UIEdgeInsetsZero animated:YES];
}


- (void)initiateMenuOptions {
    self.menuTitles = @[@"",
                        @"Send message",
                        @"Like profile",
                        @"Connect Administrator",
                        @"Add to favourites",
                        @"Block user"];
    
    self.menuIcons = @[[UIImage imageNamed:@"Icnclose"],
                       [UIImage imageNamed:@"SendMessageIcn"],
                       [UIImage imageNamed:@"LikeIcn"],
                       [UIImage imageNamed:@"AddToFriendsIcn"],
                       [UIImage imageNamed:@"AddToFavouritesIcn"],
                       [UIImage imageNamed:@"BlockUserIcn"]];
}


#pragma mark - YALContextMenuTableViewDelegate

- (void)contextMenuTableView:(YALContextMenuTableView *)contextMenuTableView didDismissWithIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Menu dismissed with indexpath = %@", indexPath);
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (void)tableView:(YALContextMenuTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView dismisWithIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuTitles.count;
}

- (UITableViewCell *)tableView:(YALContextMenuTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ContextMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:menuCellIdentifier forIndexPath:indexPath];
    
    if (cell) {
        cell.backgroundColor = [UIColor clearColor];
        cell.menuTitleLabel.text = [self.menuTitles objectAtIndex:indexPath.row];
        cell.menuImageView.image = [self.menuIcons objectAtIndex:indexPath.row];
    }
    
    return cell;
}



@end
