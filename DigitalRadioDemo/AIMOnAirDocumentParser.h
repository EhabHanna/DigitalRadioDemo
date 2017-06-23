//
//  AIMEPGParser.h
//  DigitalRadioDemo
//
//  Created by Ehab Hanna on 23/6/17.
//  Copyright © 2017 Ehab Hanna. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AIMOnAirDocument.h"

@protocol AIMOnAirDocumentParser;
@protocol AIMOnAirDocumentParserDelegate <NSObject>

- (void) parser:(id <AIMOnAirDocumentParser> _Nonnull) parser didFinishParsingWithObject:(AIMOnAirDocument * _Nullable) onAirDocument;
- (void) parser:(id<AIMOnAirDocumentParser> _Nonnull)parser didFailWithError:(NSError *_Nullable)error;
@end

@protocol AIMOnAirDocumentParser <NSObject>

-(instancetype _Nullable) initWithFile:(NSString * _Nonnull) fileName;
-(instancetype _Nullable ) initWithRawString:(NSString * _Nonnull) rawString;

@property (nonatomic, weak) id <AIMOnAirDocumentParserDelegate> _Nullable delegate;

-(void) parse;
@end
