//
//  PM25Module.h
//
//  Created by Diyuan Wang on 2019/11/24
//  Copyright (c) 2019 None All rights reserved.
//

#import <Foundation/Foundation.h>

@class Data;

@interface PM25Module : NSObject <NSCoding, NSCopying>

@property(nonatomic, strong) NSString *msg;
@property(nonatomic, assign) double status;
@property(nonatomic, strong) Data *data;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

- (NSDictionary *)dictionaryRepresentation;

@end
