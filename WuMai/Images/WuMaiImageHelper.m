//
//  WuMaiImageHelper.m
//  WuMai
//
//  Created by Diyuan Wang on 2019/11/24
//  Copyright (c) 2019 None All rights reserved.
//

#import "WuMaiImageHelper.h"

@implementation WuMaiImageHelper {
    NSArray *_rect;
    NSArray *_circle;
}

- (instancetype)init {

    if (self = [super init]) {
        _rect = @[
                [UIImage imageNamed:@"wumai_rect_1_30x27"],
                [UIImage imageNamed:@"wumai_rect_2_30x27"],
                [UIImage imageNamed:@"wumai_rect_3_30x27"],
                [UIImage imageNamed:@"wumai_rect_4_30x27"],
                [UIImage imageNamed:@"wumai_rect_5_30x27"],
                [UIImage imageNamed:@"wumai_rect_6_30x27"]];

        _circle = @[
                [UIImage imageNamed:@"wumai_circle_1_8x8"],
                [UIImage imageNamed:@"wumai_circle_2_8x8"],
                [UIImage imageNamed:@"wumai_circle_3_8x8"],
                [UIImage imageNamed:@"wumai_circle_4_8x8"],
                [UIImage imageNamed:@"wumai_circle_5_8x8"],
                [UIImage imageNamed:@"wumai_circle_6_8x8"]];

    }
    return self;
}

- (UIImage *)image:(int)zoomLevel with:(int)aqiLevel {
    int index = 0;

    if (aqiLevel >= 0 && aqiLevel <= 50) {
        index = 0;
    } else if (aqiLevel >= 51 && aqiLevel <= 100) {
        index = 1;
    } else if (aqiLevel >= 101 && aqiLevel <= 150) {
        index = 2;
    } else if (aqiLevel >= 151 && aqiLevel <= 200) {
        index = 3;
    } else if (aqiLevel >= 201 && aqiLevel <= 300) {
        index = 4;
    } else if (aqiLevel > 300) {
        index = 5;
    }

    if (zoomLevel > 7) {
        return _rect[(NSUInteger) index];
    } else {
        return _circle[(NSUInteger) index];
    }
}


+ (WuMaiImageHelper *)shareInstance {
    static WuMaiImageHelper *s_instance_dj_singleton = nil;
    if (s_instance_dj_singleton == nil) {
        s_instance_dj_singleton = [[WuMaiImageHelper alloc] init];
    }
    return (WuMaiImageHelper *) s_instance_dj_singleton;
}

@end
