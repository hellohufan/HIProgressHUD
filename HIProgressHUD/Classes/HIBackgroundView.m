//
//  HIBackgroundView.m
//
//  Version 1.0.0
//  Created by hufan on 2018/11/11.
//  Copyright © 2018年 hufan. All rights reserved.
//

#import "HIBackgroundView.h"

@interface HIBackgroundView ()

@property UIVisualEffectView *effectView;

@end


@implementation HIBackgroundView

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        _style = HIProgressViewBackgroundStyleBlur;
        if (@available(iOS 13.0, *)) {
            #if TARGET_OS_TV
            _blurEffectStyle = UIBlurEffectStyleRegular;
            #else
            _blurEffectStyle = UIBlurEffectStyleSystemThickMaterial;
            #endif
            // Leaving the color unassigned yields best results.
        } else {
            _blurEffectStyle = UIBlurEffectStyleLight;
            _color = [UIColor colorWithWhite:0.8f alpha:0.6f];
        }

        self.clipsToBounds = YES;

        [self updateForBackgroundStyle];
    }
    return self;
}

#pragma mark - Layout

- (CGSize)intrinsicContentSize {
    // Smallest size possible. Content pushes against this.
    return CGSizeZero;
}

#pragma mark - Appearance

- (void)setStyle:(HIProgressViewBackgroundStyle)style {
    if (_style != style) {
        _style = style;
        [self updateForBackgroundStyle];
    }
}

- (void)setColor:(UIColor *)color {
    NSAssert(color, @"The color should not be nil.");
    if (color != _color && ![color isEqual:_color]) {
        _color = color;
        [self updateViewsForColor:color];
    }
}

- (void)setBlurEffectStyle:(UIBlurEffectStyle)blurEffectStyle {
    if (_blurEffectStyle == blurEffectStyle) {
        return;
    }

    _blurEffectStyle = blurEffectStyle;

    [self updateForBackgroundStyle];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Views

- (void)updateForBackgroundStyle {
    [self.effectView removeFromSuperview];
    self.effectView = nil;

    HIProgressViewBackgroundStyle style = self.style;
    if (style == HIProgressViewBackgroundStyleBlur) {
        UIBlurEffect *effect =  [UIBlurEffect effectWithStyle:self.blurEffectStyle];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        [self insertSubview:effectView atIndex:0];
        effectView.frame = self.bounds;
        effectView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = self.color;
        self.layer.allowsGroupOpacity = NO;
        self.effectView = effectView;
    } else {
        self.backgroundColor = self.color;
    }
}

- (void)updateViewsForColor:(UIColor *)color {
    if (self.style == HIProgressViewBackgroundStyleBlur) {
        self.backgroundColor = self.color;
    } else {
        self.backgroundColor = self.color;
    }
}

@end
