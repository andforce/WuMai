//
//  Pos.m
//
//  Created by Diyuan Wang on 2019/11/24
//  Copyright (c) 2019 None All rights reserved.
//

#import "Pos.h"


NSString *const kPosLat = @"lat";
NSString *const kPosLng = @"lng";


@interface Pos ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation Pos

@synthesize lat = _lat;
@synthesize lng = _lng;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];

    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        self.lat = [self objectOrNilForKey:kPosLat fromDictionary:dict];
        self.lng = [self objectOrNilForKey:kPosLng fromDictionary:dict];

    }

    return self;

}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.lat forKey:kPosLat];
    [mutableDict setValue:self.lng forKey:kPosLng];

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

    self.lat = [aDecoder decodeObjectForKey:kPosLat];
    self.lng = [aDecoder decodeObjectForKey:kPosLng];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {

    [aCoder encodeObject:_lat forKey:kPosLat];
    [aCoder encodeObject:_lng forKey:kPosLng];
}

- (id)copyWithZone:(NSZone *)zone {
    Pos *copy = [[Pos alloc] init];

    if (copy) {

        copy.lat = [self.lat copyWithZone:zone];
        copy.lng = [self.lng copyWithZone:zone];
    }

    return copy;
}


@end
