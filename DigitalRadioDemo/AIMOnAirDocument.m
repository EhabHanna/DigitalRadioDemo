//
//  AIMOnAirDocument.m
//  DigitalRadioDemo
//
//  Created by Ehab Hanna on 23/6/17.
//  Copyright © 2017 Ehab Hanna. All rights reserved.
//

#import "AIMOnAirDocument.h"

@implementation AIMOnAirDocumentItem

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.time = [AIMOnAirDocumentItem dateFromString:[dictionary objectForKey:@"time"] format:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
        self.duration = [AIMOnAirDocumentItem dateFromString:[dictionary objectForKey:@"duration"] format:@"HH:mm:ss"];
        
        NSArray *rawCustomFields = [dictionary objectForKey:@"customFields"];
        NSMutableDictionary *tempCustomFields = [NSMutableDictionary dictionaryWithCapacity:rawCustomFields.count];
        
        NSString *tempName = nil;
        NSString *tempValue = nil;
        
        for (NSDictionary *customField in rawCustomFields) {
            
            tempName = [customField objectForKey:@"name"];
            tempValue = [customField objectForKey:@"value"];
            
            if (tempName != nil && tempValue != nil) {
                [tempCustomFields setObject:tempValue forKey:tempName];
            }
            
            tempName = nil;
            tempValue = nil;
        }
        
        self.customFields = [NSDictionary dictionaryWithDictionary:tempCustomFields];
    }
    return self;
}

+ (NSDate *)dateFromString:(NSString *)dateString format:(NSString *)format	{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    if (format)
        [formatter setDateFormat:format];
    
    return  [formatter dateFromString:dateString];
}

+ (NSString *)date:(NSDate *) date asString:(NSString *)format	{
    

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] ];
    if (format)
        [formatter setDateFormat:format];
    
    return [formatter stringFromDate:date];
    
}

@end

@implementation AIMEPGItem

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self) {
        self.epgID = [dictionary objectForKey:@"id"];
        self.epgDescription = [dictionary objectForKey:@"description"];
        self.presenter = [dictionary objectForKey:@"presenter"];
        self.name = [dictionary objectForKey:@"name"];
    }
    return self;
}

@end

@interface AIMPlayoutItem ()

@property (nonatomic, strong) NSString *typeString;
@property (nonatomic, strong) NSString *statusString;
@end

@implementation AIMPlayoutItem

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self) {
        self.typeString = [dictionary objectForKey:@"type"];
        self.type = [self typeFromString:self.typeString];
        self.statusString = [dictionary objectForKey:@"status"];
        self.status = [self statusFromString:self.statusString];
        self.artist = [dictionary objectForKey:@"artist"];
        self.imageURL = [dictionary objectForKey:@"imageURL"];
        self.title = [dictionary objectForKey:@"title"];
    }
    return self;
}

- (AIMPlayoutItemStatus) statusFromString:(NSString *)statusString{
    
    if ([statusString isEqualToString:@"history"]) {
        return AIMPlayoutItemStatus_HISTORY;
    }
    
    return AIMPlayoutItemStatus_UNKNOWN;
}

- (AIMPlayoutItemType) typeFromString:(NSString *)typeString{
    
    if ([typeString isEqualToString:@"song"]) {
        return AIMPlayoutItemType_SONG;
    }
    
    return AIMPlayoutItemType_UNKNOWN;
}

- (NSString *) typeRawValue{
    return self.typeString;
}

-(NSString *) statusRawValue{
    return self.statusString;
}

@end

@implementation AIMOnAirDocument
@synthesize playoutItems = _playoutItems;
@synthesize epgItems = _epgItems;
- (instancetype)initWithEPGItems:(NSArray<AIMEPGItem *> *)epgs andPlayoutItems:(NSArray<AIMPlayoutItem *> *)playouts
{
    self = [super init];
    if (self) {
        _playoutItems = playouts;
        _epgItems = epgs;
    }
    return self;
}
@end
