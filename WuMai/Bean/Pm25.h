//
//  Pm25.h
//
//  Created by Diyuan Wang on 2019/11/24
//  Copyright (c) 2019 None All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Pm25 : NSObject <NSCoding, NSCopying>

@property(nonatomic, strong) NSString *key;
@property(nonatomic, strong) NSString *type;
@property(nonatomic, strong) NSString *val;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

- (NSDictionary *)dictionaryRepresentation;

@end
