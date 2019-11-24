//
//  Pos.h
//
//  Created by Diyuan Wang on 2019/11/24
//  Copyright (c) 2019 None All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Pos : NSObject <NSCoding, NSCopying>

@property(nonatomic, strong) NSString *lat;
@property(nonatomic, strong) NSString *lng;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

- (NSDictionary *)dictionaryRepresentation;

@end
