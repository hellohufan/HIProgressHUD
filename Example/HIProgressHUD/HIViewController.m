//
//  HIViewController.m
//  HIProgressHUD
//
//  Created by hellohufan on 05/15/2020.
//  Copyright (c) 2020 hellohufan. All rights reserved.
//

#import "HIViewController.h"
#import "HIExample.h"
#import "HIProgressHUD.h"
#import "HIProgressView.h"

@interface HIViewController ()<NSURLSessionDelegate>

@property (nonatomic, strong) NSArray <HIExample *> *examples;

@property (atomic, assign) BOOL canceled;

@end

@implementation HIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [super awakeFromNib];
    self.examples =
    @[[HIExample exampleWithTitle:@"简洁菊花" selector:@selector(easyShow)],
      [HIExample exampleWithTitle:@"Tost" selector:@selector(showToast)],
//      [HIExample exampleWithTitle:@"带文字详情的菊花模式" selector:@selector(detailsLabelExample)]
    ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Examples

- (void)easyShow {
    [HIProgressHUD show];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Do something useful in the background
        [self doSomeWork];
        //显示和隐藏必须在主线程调用
        dispatch_async(dispatch_get_main_queue(), ^{
            [HIProgressHUD hide];
        });
    });
}

- (void)showToast {
    [HIProgressHUD showToast:@"helloworldhelloworldhelloworldhelloworld"];
}

#pragma mark - Tasks

- (void)doSomeWork {
    // Simulate by just waiting.
    sleep(1.);
}

- (void)doSomeWorkWithProgressObject:(NSProgress *)progressObject {
    // This just increases the progress indicator in a loop.
    while (progressObject.fractionCompleted < 1.0f) {
        if (progressObject.isCancelled) break;
        [progressObject becomeCurrentWithPendingUnitCount:1];
        [progressObject resignCurrent];
        usleep(20000);
    }
}

- (void)doSomeWorkWithProgress {
    self.canceled = NO;
    // This just increases the progress indicator in a loop.
    float progress = 0.0f;
    while (progress < 1.0f) {
        if (self.canceled) break;
        progress += 0.01f;
        dispatch_async(dispatch_get_main_queue(), ^{
            // Instead we could have also passed a reference to the HUD
            // to the HUD to myProgressTask as a method parameter.
            [HIProgressHUD progressViewFromMotherView:self.navigationController.view].progress = progress;
        });
        usleep(20000);
    }
}

- (void)doSomeWorkWithMixedProgress:(HIProgressView *)hud {
    // Indeterminate mode
    sleep(2);
    // Switch to determinate mode
    dispatch_async(dispatch_get_main_queue(), ^{
        hud.mode = HIProgressViewModeInnerAnnularBar;
        hud.label.text = @"加载中...";
    });
    float progress = 0.0f;
    while (progress < 1.0f) {
        progress += 0.01f;
        dispatch_async(dispatch_get_main_queue(), ^{
            hud.progress = progress;
        });
        usleep(20000);
    }
    // Back to indeterminate mode
    dispatch_async(dispatch_get_main_queue(), ^{
        hud.mode = HIProgressViewModeThrobber;
        hud.label.text = @"清理中...";
    });
    sleep(2);
    dispatch_sync(dispatch_get_main_queue(), ^{
        UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        hud.customView = imageView;
        hud.mode = HIProgressViewModeCustomView;
        hud.label.text = @"完成";
    });
    sleep(2);
}

- (void)cancelWork:(id)sender {
    self.canceled = YES;
}

- (void)doSomeNetworkWorkWithProgress:(HIProgressView *)pv {
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
    NSURL *URL = [NSURL URLWithString:@"https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/HT1425/sample_iPod.m4v.zip"];
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:URL];
    [task resume];
}

#pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    //do somthing
    dispatch_async(dispatch_get_main_queue(), ^{
        HIProgressView *hud = [HIProgressHUD progressViewFromMotherView:self.navigationController.view];
        UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        hud.customView = imageView;
        hud.mode = HIProgressViewModeCustomView;
        hud.label.text = @"完成";
        [hud hideAnimated:YES afterDelay:3.f];
    });
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    float progress = (float)totalBytesWritten / (float)totalBytesExpectedToWrite;

    // Update the UI on the main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        HIProgressView *hud = [HIProgressHUD progressViewFromMotherView:self.navigationController.view];
        hud.mode = HIProgressViewModeThrobber;
        hud.progress = progress;
    });
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.examples.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HIExample *example = self.examples[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HIExampleCell" forIndexPath:indexPath];
    cell.textLabel.text = example.title;
    cell.textLabel.textColor = self.view.tintColor;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.selectedBackgroundView = [UIView new];
    cell.selectedBackgroundView.backgroundColor = [cell.textLabel.textColor colorWithAlphaComponent:0.1f];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HIExample *example = self.examples[indexPath.row];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:example.selector];
#pragma clang diagnostic pop

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    });
}

@end
