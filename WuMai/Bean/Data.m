//
//  Data.m
//
//  Created by Diyuan Wang on 2019/11/24
//  Copyright (c) 2019 None All rights reserved.
//

#import "Data.h"
#import "Monitors.h"


NSString *const kDataMonitors = @"monitors";


@interface Data ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation Data

@synthesize monitors = _monitors;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];

    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        NSObject *receivedMonitors = [dict objectForKey:kDataMonitors];
        NSMutableArray *parsedMonitors = [NSMutableArray array];
        if ([receivedMonitors isKindOfClass:[NSArray class]]) {
            for (NSDictionary *item in (NSArray *) receivedMonitors) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    [parsedMonitors addObject:[Monitors modelObjectWithDictionary:item]];
                }
            }
        } else if ([receivedMonitors isKindOfClass:[NSDictionary class]]) {
            [parsedMonitors addObject:[Monitors modelObjectWithDictionary:(NSDictionary *) receivedMonitors]];
        }

        self.monitors = [NSArray arrayWithArray:parsedMonitors];

    }

    return self;

}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForMonitors = [NSMutableArray array];
    for (NSObject *subArrayObject in self.monitors) {
        if ([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForMonitors addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForMonitors addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForMonitors] forKey:kDataMonitors];

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

    self.monitors = [aDecoder decodeObjectForKey:kDataMonitors];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {

    [aCoder encodeObject:_monitors forKey:kDataMonitors];
}

- (id)copyWithZone:(NSZone *)zone {
    Data *copy = [[Data alloc] init];

    if (copy) {

        copy.monitors = [self.monitors copyWithZone:zone];
    }

    return copy;
}


@end
