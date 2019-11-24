//
//  Monitors.h
//
//  Created by Diyuan Wang on 2019/11/24
//  Copyright (c) 2019 None All rights reserved.
//

#import <Foundation/Foundation.h>

@class Pm25, Pos;

@interface Monitors : NSObject <NSCoding, NSCopying>

@property(nonatomic, strong) NSString *site;
@property(nonatomic, strong) NSString *city;
@property(nonatomic, strong) Pm25 *pm25;
@property(nonatomic, strong) NSString *updateTime;
@property(nonatomic, strong) NSString *minLevel;
@property(nonatomic, strong) NSString *sfUrl;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) Pos *pos;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

- (NSDictionary *)dictionaryRepresentation;

@end
