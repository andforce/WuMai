//
//  Data.h
//
//  Created by   on 2018/4/1
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Data : NSObject <NSCoding, NSCopying>

@property(nonatomic, strong) NSArray *monitors;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

- (NSDictionary *)dictionaryRepresentation;

@end
