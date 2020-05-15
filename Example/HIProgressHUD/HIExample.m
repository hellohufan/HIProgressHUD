//
//  HIExample.m
//  HIProgressView_Example
//
//  Created by hufan on 2020/5/13.
//  Copyright © 2020 hellohufan. All rights reserved.
//

#import "HIExample.h"

@implementation HIExample

+ (instancetype)exampleWithTitle:(NSString *)title selector:(SEL)selector {
    HIExample *example = [[self class] new];
    example.title = title;
    example.selector = selector;
    return example;
}

@end
