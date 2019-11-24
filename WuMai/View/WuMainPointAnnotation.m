//
//  WuMainPointAnnotation.m
//  WuMai
//
//  Created by Diyuan Wang on 2019/11/24
//  Copyright (c) 2019 None All rights reserved.
//

#import "WuMainPointAnnotation.h"

@implementation WuMainPointAnnotation

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }

    if (![object isKindOfClass:[WuMainPointAnnotation class]]) {
        return NO;
    } else {
        NSString *monitor = [NSString stringWithFormat:@"%@+%@", self.monitors.pos.lat, self.monitors.pos.lat];

        WuMainPointAnnotation *targetAnn = object;
        NSString *target = [NSString stringWithFormat:@"%@+%@", targetAnn.monitors.pos.lat, targetAnn.monitors.pos.lat];

        BOOL isEqual = [monitor isEqualToString:target];
        return isEqual;
    }
}
@end
