//
//  Data.h
//
//  Created by Diyuan Wang on 2019/11/24
//  Copyright (c) 2019 None All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Data : NSObject <NSCoding, NSCopying>

@property(nonatomic, strong) NSArray *monitors;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

- (NSDictionary *)dictionaryRepresentation;

@end
