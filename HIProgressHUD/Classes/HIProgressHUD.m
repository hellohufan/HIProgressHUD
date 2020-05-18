//
//  HIProgressManager.m
//
//  Version 1.0.0
//  Created by hufan on 2018/11/11.
//  Copyright © 2018年 hufan. All rights reserved.
//

#import "HIProgressHUD.h"
#import "HIProgressView.h"

@implementation HIProgressHUD
+ (void)show{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    if (window) {
        [self show:window animated:YES];
    }
}

+ (void)hide{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    if (window) {
        [self hide:window animated:YES];
    }
}

+ (void)show:(UIView *)view{
    [self show:view animated:YES];
}

+ (void)hide:(UIView *)view{
    [self hide:view animated:YES];
}

+ (void)show:(UIView *)view animated:(BOOL)animated{
    [self showWithText:nil on:view animate:animated];
}

+ (void)showWithText:(NSString *)text{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    if (window) {
        [self showWithText:nil on:window animate:YES];
    }
}

+ (void)showWithText:(nullable NSString *)text on:(UIView *)view animate:(BOOL)animated{
    HIProgressView *pv = [self showOn:view animated:animated];
    pv.label.text = text;
    [pv setAnimationType:HIProgressViewAnimationZoom];
}

+ (void)showToast:(NSString *)text{
    [self showToast:text delaySeconeds:3];
}

+ (void)showToast:(NSString *)text delaySeconeds:(NSInteger)seconds{
    [self showToast:text position:HIProgressViewToastPositionCenter delaySeconeds:seconds];
}

+ (void)showToast:(NSString *)text position:(HIProgressViewToastPosition)position delaySeconeds:(NSInteger)seconds{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    if (window) {
        [self showToast:text on:window position:position delaySeconeds:seconds];
    }
}

+ (void)showToast:(NSString *)text on:(UIView *)view position:(HIProgressViewToastPosition)position delaySeconeds:(NSInteger)seconds{
    HIProgressView *progressView = [self showOn:view mode:HIProgressViewModeText detailText:text animated:YES];
    NSArray *offsetY = @[@(-800), @(0), @(800)];
    CGFloat y = ((NSNumber *)offsetY[position]).floatValue;
    progressView.offset = CGPointMake(0, y);
    [progressView hideAnimated:YES afterDelay:seconds];
}

+ (void)showProgressView:(UIView *)view style:(HIProgressBarStyle)style text:(NSString *)text{
    HIProgressView *hud = [HIProgressHUD showOn:view animated:YES];
    hud.mode = (HIProgressViewMode)style;
    hud.label.text = @"加载中...";
}

+ (void)showProgress:(CGFloat)progress view:(UIView *)view{
    [self progressViewFromMotherView:view].progress = progress;
}

+ (HIProgressView *)showOn:(UIView *)view mode:(HIProgressViewMode)mode detailText:(NSString *)text animated:(BOOL)animated{
    HIProgressView *progressView = [self showOn:view animated:animated];
    progressView.mode = mode;
    progressView.label.text = text;
    [progressView setMode:mode];
    return progressView;
}

+ (HIProgressView *)showOn:(UIView *)view animated:(BOOL)animated {
    HIProgressView *hud = [[HIProgressView alloc] initWithView:view];
    hud.removeFromSuperViewOnHide = YES;
    [view addSubview:hud];
    [hud showAnimated:animated];
    return hud;
}

+ (void)hide:(UIView *)view animated:(BOOL)animated{
    [self hideOn:view animated:animated];
}

+ (BOOL)hideOn:(UIView *)view animated:(BOOL)animated {
    HIProgressView *hud = [self progressViewFromMotherView:view];
    if (hud != nil) {
        hud.removeFromSuperViewOnHide = YES;
        [hud hideAnimated:animated];
        return YES;
    }
    return NO;
}

+ (HIProgressView *)progressViewFromMotherView:(UIView *)view {
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:[HIProgressView class]]) {
            HIProgressView *hud = (HIProgressView *)subview;
            if (hud.hasFinished == NO) {
                return hud;
            }
        }
    }
    return nil;
}
@end
