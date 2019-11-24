//
//  PM25Module.m
//
//  Created by Diyuan Wang on 2019/11/24
//  Copyright (c) 2019 None All rights reserved.
//

#import "PM25Module.h"
#import "Data.h"


NSString *const kPM25ModuleMsg = @"msg";
NSString *const kPM25ModuleStatus = @"status";
NSString *const kPM25ModuleData = @"data";


@interface PM25Module ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation PM25Module

@synthesize msg = _msg;
@synthesize status = _status;
@synthesize data = _data;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];

    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        self.msg = [self objectOrNilForKey:kPM25ModuleMsg fromDictionary:dict];
        self.status = [[self objectOrNilForKey:kPM25ModuleStatus fromDictionary:dict] doubleValue];
        self.data = [Data modelObjectWithDictionary:[dict objectForKey:kPM25ModuleData]];

    }

    return self;

}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.msg forKey:kPM25ModuleMsg];
    [mutableDict setValue:[NSNumber numberWithDouble:self.status] forKey:kPM25ModuleStatus];
    [mutableDict setValue:[self.data dictionaryRepresentation] forKey:kPM25ModuleData];

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

    self.msg = [aDecoder decodeObjectForKey:kPM25ModuleMsg];
    self.status = [aDecoder decodeDoubleForKey:kPM25ModuleStatus];
    self.data = [aDecoder decodeObjectForKey:kPM25ModuleData];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {

    [aCoder encodeObject:_msg forKey:kPM25ModuleMsg];
    [aCoder encodeDouble:_status forKey:kPM25ModuleStatus];
    [aCoder encodeObject:_data forKey:kPM25ModuleData];
}

- (id)copyWithZone:(NSZone *)zone {
    PM25Module *copy = [[PM25Module alloc] init];

    if (copy) {

        copy.msg = [self.msg copyWithZone:zone];
        copy.status = self.status;
        copy.data = [self.data copyWithZone:zone];
    }

    return copy;
}


@end
