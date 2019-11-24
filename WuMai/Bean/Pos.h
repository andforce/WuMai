//
//  Pos.h
//
//  Created by   on 2018/4/1
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Pos : NSObject <NSCoding, NSCopying>

@property(nonatomic, strong) NSString *lat;
@property(nonatomic, strong) NSString *lng;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

- (NSDictionary *)dictionaryRepresentation;

@end
