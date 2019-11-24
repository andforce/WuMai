//
//  WuMaiLevelApi.m
//  WuMai
//
//  Created by Diyuan Wang on 2019/11/24
//  Copyright (c) 2019 None All rights reserved.
//

#import "WuMaiLevelApi.h"
#import "Monitors.h"

#import <AFNetworking/AFHTTPSessionManager.h>
#import "DataModels.h"

@implementation WuMaiLevelApi {
    AFHTTPSessionManager *_browser;
}

- (instancetype)init {
    if (self = [super init]) {
        _browser = [AFHTTPSessionManager manager];
        _browser.responseSerializer = [AFHTTPResponseSerializer serializer];
        _browser.responseSerializer.acceptableContentTypes = [_browser.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        [_browser.requestSerializer setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36" forHTTPHeaderField:@"User-Agent"];

    }
    return self;
}

- (void)findAirMonitors:(float)zoomLevel leftLocation:(CLLocationCoordinate2D)left rightLocation:(CLLocationCoordinate2D)right handler:(void (^)(NSArray<Monitors *> *))handler {
    double llat = left.latitude;
    double llon = left.longitude;
    double rlat = right.latitude;
    double rlon = right.longitude;

    NSDate *date = [NSDate date];
    long timeStamp = (NSInteger) [date timeIntervalSince1970];
    NSString *url = [NSString stringWithFormat:@"https://sp0.baidu.com/5LMDcjW6BwF3otqbppnN2DJv/weather.pae.baidu.com/weather/data/Monitorlist?z=%d&lb=%f,%f&rt=%f,%f&_=%ld",
                                               (int) zoomLevel, llon, llat, rlon, rlat, timeStamp];

    [_browser GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {

        NSString *jsonDataString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];

        NSData *data = [jsonDataString dataUsingEncoding:NSUTF8StringEncoding];

        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingOptions) kNilOptions error:nil];

        PM25Module *module = [[PM25Module alloc] initWithDictionary:dictionary];

        NSArray<Monitors *> *monitors = [[module data] monitors];

        NSLog(@"获取到的检测点数量： %ld", (long) monitors.count);

        handler(monitors);

    }     failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        handler(nil);
    }];
}

@end
