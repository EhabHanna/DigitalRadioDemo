//
//  AIMOnAirDocument.h
//  DigitalRadioDemo
//
//  Created by Ehab Hanna on 23/6/17.
//  Copyright © 2017 Ehab Hanna. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AIMOnAirDocumentItem : NSObject

@property (nonatomic, strong) NSDate *time;
@property (nonatomic, strong) NSDate *duration;
@property (nonatomic, strong) NSDictionary *customFields;

-(instancetype) initWithDictionary:(NSDictionary *) dictionary;

@end

@interface AIMEPGItem : AIMOnAirDocumentItem
@property (nonatomic, strong) NSString *epgID;
@property (nonatomic, strong) NSString *epgDescription;
@property (nonatomic, strong) NSString *presenter;
@end

typedef enum {
    AIMPlayoutItemType_UNKNOWN = 0,
    AIMPlayoutItemType_SONG
} AIMPlayoutItemType;

typedef enum {
    AIMPlayoutItemStatus_UNKNOWN = 0,
    AIMPlayoutItemStatus_HISTORY
} AIMPlayoutItemStatus;

@interface AIMPlayoutItem : AIMOnAirDocumentItem
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) AIMPlayoutItemType type;
@property (nonatomic, assign) AIMPlayoutItemStatus status;
@property (nonatomic, strong) NSString *artist;
@property (nonatomic, strong) NSString *imageURL;

-(NSString *) typeRawValue;
-(NSString *) statusRawValue;
@end

@interface AIMOnAirDocument : NSObject

-(instancetype) initWithEPGItems:(NSArray<AIMEPGItem *> *) epgs andPlayoutItems:(NSArray<AIMPlayoutItem *> *) playouts;

@property (nonatomic, strong, readonly) NSArray<AIMEPGItem *> *epgItems;
@property (nonatomic, strong, readonly) NSArray<AIMPlayoutItem *> *playoutItems;
@end
