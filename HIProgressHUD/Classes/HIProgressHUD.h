//
//  HIProgressManager.h
//
//  Version 1.0.0
//  Created by hufan on 2018/11/11.
//  Copyright © 2018年 hufan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HIProgressViewConstance.h"

@class HIProgressView;


NS_ASSUME_NONNULL_BEGIN

@interface HIProgressHUD : NSObject

/**
 * 显示菊花
 *
 * @note 加载到AppDelegate的window上
 * @note 调用该方法前提keyWindow不能为nil。
 *
 * @see 对应的隐藏方法：+ (void)hide;
 */
+ (void)show;

/**
 * 在某个view上显示菊花
 *
 * @param view 菊花的 super view
 *
 * @see hide:
*/
+ (void)show:(UIView *)view;

/**
 * 显示带状态文字的菊花
 *
 * @param text 状态文字，如“请求中...”
 *
 * @note 加载到AppDelegate的window上
 * @note 调用该方法前提keyWindow不能为nil。
 *
 * @see 对应的隐藏方法：+ (void)hide;
*/
+ (void)showWithText:(NSString *)text;

/**
 * 在某个view上显示菊花
 *
 * @param view 菊花progressView的 super view
 * @param animated 如果设置成YES，将会显示默认animationType的动画；如果设置成NO，不会显示动画。
 *
 * @see hide:
*/
+ (void)show:(UIView *)view animated:(BOOL)animated;

/**
 * 显示带状态文字菊花
 *
 * @param text 状态文字，如“请求中...”
 * @param animated 如果设置成YES，将会显示默认animationType的动画；如果设置成NO，不会显示动画。
 *
 * @note 加载到AppDelegate的window上
 * @note 调用该方法前提keyWindow不能为nil。
 *
 * @see 对应的隐藏方法：+ (void)hide;
*/
+ (void)showWithText:(nullable NSString *)text on:(UIView *)view animate:(BOOL)animated;

/**
 * 显示吐司
 *
 * 基于keyWindow，调用请确保window有值
 *
 * @param text 吐司显示的内容
 *
 * @note 默认显示时间3秒
 *
 * @see showToast:delaySeconeds:
 */
+ (void)showToast:(NSString *)text;

/**
 * 显示吐司
 *
 * 基于keyWindow，调用请确保window有值
 *
 * @param text 吐司显示的内容
 * @param seconds 显示时间
*/
+ (void)showToast:(NSString *)text delaySeconeds:(NSInteger)seconds;

/**
 * 显示吐司
 *
 * 基于keyWindow，调用请确保window有值
 *
 * @param text 吐司显示的内容
 * @param position 显示位置，上中下，参见HIProgressViewToastPosition
 * @param seconds 显示时间
 *
 * @see HIProgressViewToastPosition
*/
+ (void)showToast:(NSString *)text position:(HIProgressViewToastPosition)position delaySeconeds:(NSInteger)seconds;

/**
 * 显示吐司
 *
 *
 * @param text 吐司显示的内容
 * @param position 显示位置，上中下，参见HIProgressViewToastPosition
 * @param seconds 显示时间
 *
 * @see HIProgressViewToastPosition
*/
+ (void)showToast:(NSString *)text on:(UIView *)view position:(HIProgressViewToastPosition)position delaySeconeds:(NSInteger)seconds;

/**
 * 显示百分比进度条
 * 需要配合方法showProgress:view:使用
 *
 * @param view 状态条的super view
 * @param style 三种style，参看HIProgressBarStyle
 * @param text 显示文本
 *
 * @see HIProgressBarStyle
 * @see showProgress:view:
*/
+ (void)showProgressView:(UIView *)view style:(HIProgressBarStyle)style text:(NSString *)text;

/**
 * 状态传入当前进度百分比
 * 需要配合方法showProgressView:style:text:使用
 *
 * @param progress 传入当前进度，数值0-1
 * @param view 状态条的super view
 *
 * @see HIProgressBarStyle
 * @see showProgressView:style:text:
*/
+ (void)showProgress:(CGFloat)progress view:(UIView *)view;

/**
 * 隐藏菊花
 *
 * @note 加载到AppDelegate的window上
 * @note 调用该方法前提keyWindow不能为nil。
 *
 * @see 对应显示方法：+ (void)show;
*/
+ (void)hide;

/**
 * 在某个view上显示菊花
 *
 * @param view 菊花的 super view
 *
 * @see show:
*/
+ (void)hide:(UIView *)view;

/**
 * 隐藏菊花
 *
 * @param animated 如果设置成YES，将会显示默认animationType的动画；如果设置成NO，不会显示动画。
 *
 * @see show:
*/
+ (void)hide:(UIView *)view animated:(BOOL)animated;

/**
 * 创建一个新的progressView，在view上显示progressView，对应的隐藏方法为 hideOn:animated:
 *
 * @note 调用对应的隐藏方法后，progressView也将自动销毁
 *
 * @param view progressView的mother view
 * @param animated 如果设置成YES，将会显示默认animationType的动画；如果设置成NO，不会显示动画。
 *
 * @return 返回HIProgressView实例.
 *
 * @see hideOn: animated:
 */
+ (HIProgressView *)showOn:(UIView *)view animated:(BOOL)animated;

/**
 * 隐藏progressView
 *
 * @param view 从这个view上找到progressView，并移除
 * @param animated 如果设置成YES，将会显示默认animationType的动画；如果设置成NO，不会显示动画。
 *
 * @return YES 找到并移除, NO 未找到，移除失败
 *
 * @see showprogressViewAddedTo:animated:
 * @see animationType
 */
+ (BOOL)hideOn:(UIView *)view animated:(BOOL)animated;

/**
 * 从view的子view中找到未结束动画的HIProgressView对象
 *
 * @param view progressView的mother view
 * @return HIProgressView对象
 */
+ (nullable HIProgressView *)progressViewFromMotherView:(UIView *)view NS_SWIFT_NAME(progressViewForView(_:));

@end

NS_ASSUME_NONNULL_END
