//
//  HIExample.h
//  HIProgressView_Example
//
//  Created by hufan on 2020/5/13.
//  Copyright © 2020 hellohufan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface HIExample : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) SEL selector;

+ (instancetype)exampleWithTitle:(NSString *)title selector:(SEL)selector;

@end

NS_ASSUME_NONNULL_END
