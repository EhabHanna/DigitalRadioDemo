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
@protocol AIMEPGParserDelegate <NSObject>

- (void) parser:(id<AIMOnAirDocumentParser>) parser didFinishParsingWithObject:(AIMOnAirDocument *) onAirDocument;

@end

@protocol AIMOnAirDocumentParser <NSObject>

-(instancetype) initWithFile:(NSString *) fileName;
-(instancetype) initWithRawString:(NSString *) rawString;

@property (nonatomic, weak) id<AIMEPGParserDelegate> delegate;

-(void) parse;
@end
