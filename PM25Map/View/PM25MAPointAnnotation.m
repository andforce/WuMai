//
//  PM25MAPointAnnotation.m
//  PM25Map
//
//  Created by 迪远 王 on 2018/4/1.
//  Copyright © 2018年 andforce. All rights reserved.
//

#import "PM25MAPointAnnotation.h"

@implementation PM25MAPointAnnotation

- (BOOL)isEqual:(id)object {
    if (self == object){
        return YES;
    }

    if (![object isKindOfClass:[PM25MAPointAnnotation class]]){
        return NO;
    } else {
        NSString *monitor = [NSString stringWithFormat:@"%@+%@" ,self.monitors.pos.lat, self.monitors.pos.lat];

        PM25MAPointAnnotation *targetAnn = object;
        NSString *target = [NSString stringWithFormat:@"%@+%@" ,targetAnn.monitors.pos.lat, targetAnn.monitors.pos.lat];

        BOOL isEqual = [monitor isEqualToString:target];
        return isEqual;
    }
}
@end
