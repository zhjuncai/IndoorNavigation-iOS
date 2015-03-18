//
//  ViewController.m
//  LoadingPlan
//
//  Created by Ethan Zhang on 12/13/14.
//  Copyright (c) 2014 SAP SE. All rights reserved.
//

#import "ScanViewController.h"
#import "FreightOrderDetailViewController.h"

@interface ScanViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *bbitemStart;
@property (weak, nonatomic) IBOutlet UIView *viewPreview;

@property (nonatomic) BOOL isReading;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

-(void)loadBeepSound;

@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    UIImage *bgImage=[UIImage imageNamed:@"Wallpaper.png"];
//    self.view.backgroundColor=[UIColor colorWithPatternImage:bgImage];
    UIImage *scanviewImage=[UIImage imageNamed:@"scanview.png"];
    self.viewPreview.backgroundColor=[UIColor colorWithPatternImage:scanviewImage];
    self.isReading = NO;
    self.captureSession = nil;
    [self loadBeepSound];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)startStopReading:(id)sender {
    
    if(!self.isReading){
        if ([self startReading]) {
            self.bbitemStart.title = @"Stop";
        }
    }else{
        [self stopReading];
        self.bbitemStart.title = @"Start!";
    }
}

- (BOOL)startReading{
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
    self.videoPreviewLayer.frame = self.viewPreview.layer.bounds;
    
    self.videoPreviewLayer.borderColor = [UIColor redColor].CGColor;
    self.videoPreviewLayer.borderWidth = 4;
    
    [self.viewPreview.layer addSublayer:self.videoPreviewLayer];
    
    [self.captureSession startRunning];
    self.isReading = YES;
    
    return YES;
}

- (void)stopReading{
    [self.captureSession stopRunning];
    self.captureSession = nil;
    self.isReading = NO;
    self.bbitemStart.title = @"Start!";
    [self.videoPreviewLayer removeFromSuperlayer];
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



@end
