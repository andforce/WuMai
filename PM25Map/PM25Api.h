//
//  PM25Api.h
//  PM25Map
//
//  Created by 迪远 王 on 2018/4/3.
//  Copyright © 2018年 andforce. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Monitors;

typedef void (^Handler)(NSArray<Monitors*> *monitors);

@interface PM25Api : NSObject

-(void)fetchMonitors:(float)zoomLevel leftLat:(double)llat leftLon:(double)llon rightLat:(double)rlat rightLon:(double)rlon handler:(Handler) handler;

@end
