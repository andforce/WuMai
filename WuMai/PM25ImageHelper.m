//
//  PM25ImageHelper.m
//  WuMai
//
//  Created by 迪远 王 on 2018/4/3.
//  Copyright © 2018年 andforce. All rights reserved.
//

#import "PM25ImageHelper.h"

@implementation PM25ImageHelper {
    NSArray *_rect;
    NSArray *_point;
}

- (instancetype)init {

    if (self = [super init]) {
        _rect = @[
                [UIImage imageNamed:@"aqi_map_level_1_30x27_@2x.png"],
                [UIImage imageNamed:@"aqi_map_level_2_30x27_@2x.png"],
                [UIImage imageNamed:@"aqi_map_level_3_30x27_@2x.png"],
                [UIImage imageNamed:@"aqi_map_level_4_30x27_@2x.png"],
                [UIImage imageNamed:@"aqi_map_level_5_30x27_@2x.png"],
                [UIImage imageNamed:@"aqi_map_level_6_30x27_@2x.png"]];

        _point = @[
                [UIImage imageNamed:@"aqi_map_point_level_1_8x8_@2x.png"],
                [UIImage imageNamed:@"aqi_map_point_level_2_8x8_@2x.png"],
                [UIImage imageNamed:@"aqi_map_point_level_3_8x8_@2x.png"],
                [UIImage imageNamed:@"aqi_map_point_level_4_8x8_@2x.png"],
                [UIImage imageNamed:@"aqi_map_point_level_5_8x8_@2x.png"],
                [UIImage imageNamed:@"aqi_map_point_level_6_8x8_@2x.png"]];

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
        return _point[(NSUInteger) index];
    }
}


+ (PM25ImageHelper *)shareInstance {
    static PM25ImageHelper *s_instance_dj_singleton = nil;
    if (s_instance_dj_singleton == nil) {
        s_instance_dj_singleton = [[PM25ImageHelper alloc] init];
    }
    return (PM25ImageHelper *) s_instance_dj_singleton;
}

@end
