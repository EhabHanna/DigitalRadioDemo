//
//  AIMEPGParser.m
//  DigitalRadioDemo
//
//  Created by Ehab Hanna on 23/6/17.
//  Copyright © 2017 Ehab Hanna. All rights reserved.
//

#import "AIMOnAirXMLParser.h"

@interface AIMOnAirXMLParser ()<NSXMLParserDelegate>
@property (nonatomic, strong) NSXMLParser *parser;
@property (nonatomic, strong) dispatch_queue_t dispatchQueue;
@property (nonatomic, strong) AIMOnAirDocument *parsedDocument;

@property (nonatomic, strong) NSMutableArray *epgItems;
@property (nonatomic, strong) NSMutableArray *playoutitems;
@property (nonatomic, strong) NSMutableArray *customFields;
@property (nonatomic, strong) NSMutableDictionary *item;
@end

@implementation AIMOnAirXMLParser
@synthesize delegate;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dispatchQueue = dispatch_queue_create("com.thisisaim.xmlParser", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (instancetype)initWithFile:(NSString *)fileName
{
    if (!fileName || fileName.length == 0) {
        return nil;
    }
    self = [self init];
    if (self) {
        self.parser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL fileURLWithPath:fileName]];
        if (!self.parser) {
            return nil;
        }
    }
    return self;
}

- (instancetype)initWithRawString:(NSString *)rawString
{
    if (!rawString || rawString.length == 0) {
        return nil;
    }
    self = [self initWithData:[rawString dataUsingEncoding:NSUTF8StringEncoding]];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithData:(NSData *)data
{
    if (!data || data.length == 0) {
        return nil;
    }
    self = [self init];
    if (self) {
        self.parser = [[NSXMLParser alloc] initWithData:data];
        if (!self.parser) {
            return nil;
        }
    }
    return self;
}

- (void) parse{
    
    self.parsedDocument = nil;
    self.parser.delegate = self;
    
    dispatch_async(self.dispatchQueue, ^{
        
        BOOL parsed = [self.parser parse];
        
        if (parsed) {
            
            if (self.delegate !=nil) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate parser:self didFinishParsingWithObject:self.parsedDocument];
                });
            }
        }else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate parser:self didFailWithError:self.parser.parserError];
            });
            
        }
    });
    
}

- (void) clearAll{
    
    [self.epgItems removeAllObjects];
    self.epgItems = nil;
    
    [self.playoutitems removeAllObjects];
    self.playoutitems = nil;
    
    [self.item removeAllObjects];
    self.item = nil;
    
    [self.customFields removeAllObjects];
    self.customFields = nil;
}

#pragma mark - 
#pragma mark NSXMLParserDelegate methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict;
{
    if ([elementName isEqualToString:@"onAir"]) {
        [self clearAll];
    }else if ([elementName isEqualToString:@"epgData"]) {
        self.epgItems = [[NSMutableArray alloc] initWithCapacity:100];
    }else if ([elementName isEqualToString:@"playoutData"]){
        self.playoutitems = [[NSMutableArray alloc] initWithCapacity:100];
    }else if ([elementName isEqualToString:@"customFields"]){
        self.customFields = [[NSMutableArray alloc] initWithCapacity:5];
    }else if ([elementName isEqualToString:@"epgItem"] || [elementName isEqualToString:@"playoutItem"]){
        self.item = [[NSMutableDictionary alloc] initWithDictionary:attributeDict];
    }else if ([elementName isEqualToString:@"customField"]){
        [self.customFields addObject:attributeDict];
    }
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string;
{
    
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName;
{
    if ([elementName isEqualToString:@"onAir"]) {
        self.parsedDocument = [[AIMOnAirDocument alloc] initWithEPGItems:self.epgItems andPlayoutItems:self.playoutitems];
    }else if ([elementName isEqualToString:@"epgData"]) {
        
    }else if ([elementName isEqualToString:@"playoutData"]){
        
    }else if ([elementName isEqualToString:@"customFields"]){
        [self.item setObject:self.customFields forKey:@"customFields"];
        self.customFields = nil;
    }else if ([elementName isEqualToString:@"epgItem"]){
        [self.epgItems addObject:[[AIMEPGItem alloc] initWithDictionary:self.item]];
    }else if([elementName isEqualToString:@"playoutItem"]){
        [self.playoutitems addObject:[[AIMPlayoutItem alloc] initWithDictionary:self.item]];
    }else if ([elementName isEqualToString:@"customField"]){
        
    }
}

- (void)dealloc
{
    [self clearAll];
}
@end
