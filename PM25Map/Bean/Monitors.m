//
//  Monitors.m
//
//  Created by   on 2018/4/1
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import "Monitors.h"
#import "Pm25.h"
#import "Pos.h"


NSString *const kMonitorsSite = @"site";
NSString *const kMonitorsCity = @"city";
NSString *const kMonitorsPm25 = @"pm25";
NSString *const kMonitorsUpdateTime = @"updateTime";
NSString *const kMonitorsMinLevel = @"minLevel";
NSString *const kMonitorsSfUrl = @"sfUrl";
NSString *const kMonitorsName = @"name";
NSString *const kMonitorsPos = @"pos";


@interface Monitors ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation Monitors

@synthesize site = _site;
@synthesize city = _city;
@synthesize pm25 = _pm25;
@synthesize updateTime = _updateTime;
@synthesize minLevel = _minLevel;
@synthesize sfUrl = _sfUrl;
@synthesize name = _name;
@synthesize pos = _pos;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.site = [self objectOrNilForKey:kMonitorsSite fromDictionary:dict];
            self.city = [self objectOrNilForKey:kMonitorsCity fromDictionary:dict];
            self.pm25 = [Pm25 modelObjectWithDictionary:[dict objectForKey:kMonitorsPm25]];
            self.updateTime = [self objectOrNilForKey:kMonitorsUpdateTime fromDictionary:dict];
            self.minLevel = [self objectOrNilForKey:kMonitorsMinLevel fromDictionary:dict];
            self.sfUrl = [self objectOrNilForKey:kMonitorsSfUrl fromDictionary:dict];
            self.name = [self objectOrNilForKey:kMonitorsName fromDictionary:dict];
            self.pos = [Pos modelObjectWithDictionary:[dict objectForKey:kMonitorsPos]];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.site forKey:kMonitorsSite];
    [mutableDict setValue:self.city forKey:kMonitorsCity];
    [mutableDict setValue:[self.pm25 dictionaryRepresentation] forKey:kMonitorsPm25];
    [mutableDict setValue:self.updateTime forKey:kMonitorsUpdateTime];
    [mutableDict setValue:self.minLevel forKey:kMonitorsMinLevel];
    [mutableDict setValue:self.sfUrl forKey:kMonitorsSfUrl];
    [mutableDict setValue:self.name forKey:kMonitorsName];
    [mutableDict setValue:[self.pos dictionaryRepresentation] forKey:kMonitorsPos];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.site = [aDecoder decodeObjectForKey:kMonitorsSite];
    self.city = [aDecoder decodeObjectForKey:kMonitorsCity];
    self.pm25 = [aDecoder decodeObjectForKey:kMonitorsPm25];
    self.updateTime = [aDecoder decodeObjectForKey:kMonitorsUpdateTime];
    self.minLevel = [aDecoder decodeObjectForKey:kMonitorsMinLevel];
    self.sfUrl = [aDecoder decodeObjectForKey:kMonitorsSfUrl];
    self.name = [aDecoder decodeObjectForKey:kMonitorsName];
    self.pos = [aDecoder decodeObjectForKey:kMonitorsPos];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_site forKey:kMonitorsSite];
    [aCoder encodeObject:_city forKey:kMonitorsCity];
    [aCoder encodeObject:_pm25 forKey:kMonitorsPm25];
    [aCoder encodeObject:_updateTime forKey:kMonitorsUpdateTime];
    [aCoder encodeObject:_minLevel forKey:kMonitorsMinLevel];
    [aCoder encodeObject:_sfUrl forKey:kMonitorsSfUrl];
    [aCoder encodeObject:_name forKey:kMonitorsName];
    [aCoder encodeObject:_pos forKey:kMonitorsPos];
}

- (id)copyWithZone:(NSZone *)zone
{
    Monitors *copy = [[Monitors alloc] init];
    
    if (copy) {

        copy.site = [self.site copyWithZone:zone];
        copy.city = [self.city copyWithZone:zone];
        copy.pm25 = [self.pm25 copyWithZone:zone];
        copy.updateTime = [self.updateTime copyWithZone:zone];
        copy.minLevel = [self.minLevel copyWithZone:zone];
        copy.sfUrl = [self.sfUrl copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
        copy.pos = [self.pos copyWithZone:zone];
    }
    
    return copy;
}


@end
