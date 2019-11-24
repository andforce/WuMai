//
//  Pm25.m
//
//  Created by Diyuan Wang on 2019/11/24
//  Copyright (c) 2019 None All rights reserved.
//

#import "Pm25.h"


NSString *const kPm25Key = @"key";
NSString *const kPm25Type = @"type";
NSString *const kPm25Val = @"val";


@interface Pm25 ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation Pm25

@synthesize key = _key;
@synthesize type = _type;
@synthesize val = _val;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];

    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        self.key = [self objectOrNilForKey:kPm25Key fromDictionary:dict];
        self.type = [self objectOrNilForKey:kPm25Type fromDictionary:dict];
        self.val = [self objectOrNilForKey:kPm25Val fromDictionary:dict];

    }

    return self;

}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.key forKey:kPm25Key];
    [mutableDict setValue:self.type forKey:kPm25Type];
    [mutableDict setValue:self.val forKey:kPm25Val];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict {
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];

    self.key = [aDecoder decodeObjectForKey:kPm25Key];
    self.type = [aDecoder decodeObjectForKey:kPm25Type];
    self.val = [aDecoder decodeObjectForKey:kPm25Val];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {

    [aCoder encodeObject:_key forKey:kPm25Key];
    [aCoder encodeObject:_type forKey:kPm25Type];
    [aCoder encodeObject:_val forKey:kPm25Val];
}

- (id)copyWithZone:(NSZone *)zone {
    Pm25 *copy = [[Pm25 alloc] init];

    if (copy) {

        copy.key = [self.key copyWithZone:zone];
        copy.type = [self.type copyWithZone:zone];
        copy.val = [self.val copyWithZone:zone];
    }

    return copy;
}


@end
