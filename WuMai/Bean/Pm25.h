//
//  Pm25.h
//
//  Created by   on 2018/4/1
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
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
