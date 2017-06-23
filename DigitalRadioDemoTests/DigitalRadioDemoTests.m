//
//  DigitalRadioDemoTests.m
//  DigitalRadioDemoTests
//
//  Created by Ehab Hanna on 23/6/17.
//  Copyright © 2017 Ehab Hanna. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AIMOnAirDocument.h"
#import "AIMOnAirXMLParser.h"

@interface DigitalRadioDemoTests : XCTestCase<AIMOnAirDocumentParserDelegate>
@property (nonatomic, strong) XCTestExpectation *xmlParsedExpectation;
@property (nonatomic, strong) AIMOnAirDocument *parsedDocument;
@property (nonatomic, strong) NSError *parsingError;
@end

@implementation DigitalRadioDemoTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    self.parsedDocument = nil;
    [super tearDown];
}

- (void)testPlayoutItemInit {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    NSMutableDictionary *test = [NSMutableDictionary new];
    
    [test setObject:@"2017-06-23T10:04:20+10:00" forKey:@"time"];
    [test setObject:@"00:03:24" forKey:@"duration"];
    [test setObject:@"The Way You Used To Do" forKey:@"title"];
    [test setObject:@"Queens Of The Stone Age" forKey:@"artist"];
    [test setObject:@"history" forKey:@"status"];
    [test setObject:@"song" forKey:@"type"];
    [test setObject:@"http://www.abc.net.au/triplej/albums/56045/covers/190.jpg" forKey:@"imageUrl"];
    
    AIMPlayoutItem *item = [[AIMPlayoutItem alloc] initWithDictionary:test];
    XCTAssert(item.time !=nil,@"your time should have a value");
    XCTAssert(item.duration != nil, @"your duration should have a value");
    XCTAssert([item.title isEqualToString:@"The Way You Used To Do"], @"titles don't match");
    XCTAssert([item.artist isEqualToString:@"Queens Of The Stone Age"], @"artists don't match");
    XCTAssert(item.status == AIMPlayoutItemStatus_HISTORY, @"your status should be history");
    XCTAssert(item.type == AIMPlayoutItemType_SONG, @"your type should be song");
    XCTAssert([item.imageURL isEqualToString:@"http://www.abc.net.au/triplej/albums/56045/covers/190.jpg"],@"your urls don't match");
}

- (void)testEPGItemInit {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    NSMutableDictionary *test = [NSMutableDictionary new];
    
    [test setObject:@"2017-06-23T10:04:20+10:00" forKey:@"time"];
    [test setObject:@"00:03:24" forKey:@"duration"];
    [test setObject:@"160" forKey:@"id"];
    [test setObject:@"Mornings" forKey:@"name"];
    [test setObject:@"Zan Rowe brings you new music and exclusives to your morning. Listen up for album interviews and tips on your new favourite band." forKey:@"description"];
    [test setObject:@"Zan Rowe" forKey:@"presenter"];
    
    
    AIMEPGItem *item = [[AIMEPGItem alloc] initWithDictionary:test];
    XCTAssert(item.time !=nil,@"your time should have a value");
    XCTAssert(item.duration != nil, @"your duration should have a value");
    XCTAssert([item.epgDescription isEqualToString:@"Zan Rowe brings you new music and exclusives to your morning. Listen up for album interviews and tips on your new favourite band."], @"descriptions don't match");
    XCTAssert([item.epgID isEqualToString:@"160"], @"epgIDs don't match");
    XCTAssert([item.name isEqualToString:@"Mornings"],@"names don't match");
    XCTAssert([item.presenter isEqualToString:@"Zan Rowe"],@"presenters don't match");
}

- (void) testCustomFieldInit {
    
    NSMutableDictionary *test = [NSMutableDictionary new];
    
    [test setObject:@"2017-06-23T10:04:20+10:00" forKey:@"time"];
    [test setObject:@"00:03:24" forKey:@"duration"];
    [test setObject:@[@{@"name":@"image320",@"value":@"http://www.abc.net.au/triplej/programs/img/2017/mornings_zan/background.jpg"}, @{@"name":@"displayTime",@"value":@"Mon-Fri 9am-12pm"}] forKey:@"customFields"];
    
    AIMEPGItem *item = [[AIMEPGItem alloc] initWithDictionary:test];
    XCTAssert(item.customFields.count == 2, @"should have 2 custom fields");
    XCTAssert([[item.customFields objectForKey:@"displayTime"] isEqualToString:@"Mon-Fri 9am-12pm"],@"stored custom value does not match provided value");
}

- (void) testXMLParserNull{
    
    NSString *nilString = nil;
    
    AIMOnAirXMLParser *xmlParser = [[AIMOnAirXMLParser alloc] initWithFile:nilString];
    
    XCTAssertNil(xmlParser, @"should not have a parser without a file");
    
    xmlParser = [[AIMOnAirXMLParser alloc] initWithRawString:nilString];
    
    XCTAssertNil(xmlParser, @"should not have a parser without a string");
    
}

- (void) testParsedDocumentNull{
    
    AIMOnAirXMLParser *xmlParser = [[AIMOnAirXMLParser alloc] initWithRawString:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"];
    
    xmlParser.delegate = self;
    
    self.xmlParsedExpectation = [[XCTestExpectation alloc] initWithDescription:@"XML document has been parsed"];
    [xmlParser parse];
    
    [self waitForExpectations:@[self.xmlParsedExpectation] timeout:10.0];
    
    
    XCTAssertNil(self.parsedDocument, @"should not have a document with empty xml");
    
}

- (void) testParsedDocumentInValidXML{
    
    AIMOnAirXMLParser *xmlParser = [[AIMOnAirXMLParser alloc] initWithRawString:@"<arbitrary>"];
    
    xmlParser.delegate = self;
    
    self.xmlParsedExpectation = [[XCTestExpectation alloc] initWithDescription:@"XML document has been parsed"];
    [xmlParser parse];
    
    [self waitForExpectations:@[self.xmlParsedExpectation] timeout:10.0];
    
    
    XCTAssertNil(self.parsedDocument, @"should not have a document with non xml");
    XCTAssertNotNil(self.parsingError, @"should have an error");
    
}

- (void) testXMLParserOnFile{
    
    AIMOnAirXMLParser *xmlParser = [[AIMOnAirXMLParser alloc] initWithFile:[[NSBundle mainBundle] pathForResource:@"onair" ofType:@"xml"]];
    
    xmlParser.delegate = self;
    
    self.xmlParsedExpectation = [[XCTestExpectation alloc] initWithDescription:@"XML document has been parsed"];
    [xmlParser parse];
    
    [self waitForExpectations:@[self.xmlParsedExpectation] timeout:10.0];
    XCTAssertNotNil(self.parsedDocument,@"parsed document should have a value");
    XCTAssert(self.parsedDocument.epgItems.count == 1,@"the document should have 1 epg item");
    XCTAssert(self.parsedDocument.playoutItems.count == 20,@"the document should have 20 playout items");
}

- (void) testXMLParserOnString{
    
    NSString *customField1 = @"http://www.abc.net.au/triplej/programs/img/2017/mornings_zan/background.jpg";
    NSString *customField2 = @"Mon-Fri 9am-12pm";
    NSString *customField3 = @"http://www.abc.net.au/triplej/programs/img/2017/mornings_zan/background640.jpg";
    NSString *customField4 = @"http://www.abc.net.au/triplej/programs/img/2017/mornings_zan/70.jpg";
    NSString *customField5 = @"http://www.abc.net.au/triplej/programs/img/2017/mornings_zan/50.jpg";
    
    AIMOnAirXMLParser *xmlParser = [[AIMOnAirXMLParser alloc] initWithRawString:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?> <onAir> <epgData> <epgItem id=\"160\" name=\"Mornings\" description=\"Zan Rowe brings you new music and exclusives to your morning. Listen up for album interviews and tips on your new favourite band.\" time=\"2017-06-23T09:00:00+10:00\" duration=\"03:00:00\" presenter=\"\" > <customFields> <customField name=\"image320\" value=\"http://www.abc.net.au/triplej/programs/img/2017/mornings_zan/background.jpg\" /> <customField name=\"displayTime\" value=\"Mon-Fri 9am-12pm\" /> <customField name=\"image640\" value=\"http://www.abc.net.au/triplej/programs/img/2017/mornings_zan/background640.jpg\" /> <customField name=\"image70\" value=\"http://www.abc.net.au/triplej/programs/img/2017/mornings_zan/70.jpg\" /> <customField name=\"image50\" value=\"http://www.abc.net.au/triplej/programs/img/2017/mornings_zan/50.jpg\" /> </customFields> </epgItem> </epgData> </onAir>"];
    
    xmlParser.delegate = self;
    
    self.xmlParsedExpectation = [[XCTestExpectation alloc] initWithDescription:@"XML document has been parsed"];
    [xmlParser parse];
    
    [self waitForExpectations:@[self.xmlParsedExpectation] timeout:10.0];
    
    XCTAssertNotNil(self.parsedDocument,@"parsed document should have a value");
    
    AIMEPGItem *parseditem = [self.parsedDocument.epgItems lastObject];
    
    XCTAssertNotNil(parseditem,@"parsed document should have an epg item");
    
    XCTAssert([parseditem.name isEqualToString:@"Mornings"], @"epg item name invalid -> %@",parseditem.name);
    
    XCTAssert([parseditem.epgID isEqualToString:@"160"], @"epg item id invalid -> %@",parseditem.epgID);
    
    XCTAssert(parseditem.customFields.count == 5, @"epg item should have 5 items -> %lu",(unsigned long)parseditem.customFields.count);
    
    XCTAssert([[parseditem.customFields objectForKey:@"image320"] isEqualToString:customField1], @"epg customfield invalid -> %@",[parseditem.customFields objectForKey:@"image320"]);
    
    XCTAssert([[parseditem.customFields objectForKey:@"displayTime"] isEqualToString:customField2], @"epg customfield invalid -> %@",[parseditem.customFields objectForKey:@"displayTime"]);
    
    XCTAssert([[parseditem.customFields objectForKey:@"image640"] isEqualToString:customField3], @"epg customfield invalid -> %@",[parseditem.customFields objectForKey:@"image640"]);
    
    XCTAssert([[parseditem.customFields objectForKey:@"image70"] isEqualToString:customField4], @"epg customfield invalid -> %@",[parseditem.customFields objectForKey:@"image70"]);
    
    XCTAssert([[parseditem.customFields objectForKey:@"image50"] isEqualToString:customField5], @"epg customfield invalid -> %@",[parseditem.customFields objectForKey:@"image50"]);
}

- (void) testXMLParserPlayoutItem{
    
    
    AIMOnAirXMLParser *xmlParser = [[AIMOnAirXMLParser alloc] initWithRawString:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?> <onAir><playoutData> <playoutItem time=\"2017-06-23T10:04:20+10:00\" duration=\"00:03:24\" title=\"The Way You Used To Do\" artist=\"Queens Of The Stone Age\" album=\"The Way You Used To Do {Single}\" status=\"playing\" type=\"song\" imageUrl=\"http://www.abc.net.au/triplej/albums/56045/covers/190.jpg\"> <customFields> <customField name=\"tracknote\" value=\"\" /> </customFields> </playoutItem> </playoutData></onAir>"];
    
    xmlParser.delegate = self;
    
    self.xmlParsedExpectation = [[XCTestExpectation alloc] initWithDescription:@"XML document has been parsed"];
    [xmlParser parse];
    
    [self waitForExpectations:@[self.xmlParsedExpectation] timeout:10.0];
    
    XCTAssertNotNil(self.parsedDocument,@"parsed document should have a value");
    
    AIMPlayoutItem *parseditem = [self.parsedDocument.playoutItems lastObject];
    
    XCTAssertNotNil(parseditem,@"parsed document should have a playout item");
    
    XCTAssert(parseditem.status == AIMPlayoutItemStatus_PLAYING, @"item status should be playing");
    XCTAssert(parseditem.type == AIMPlayoutItemType_SONG, @"item type should be song");
    XCTAssert(parseditem.customFields.count == 0,@"item should not have any custom fields");
    XCTAssertNotNil(parseditem.time,@"should have a time");
    XCTAssertNotNil(parseditem.duration,@"should have a duration");
    
    XCTAssert([parseditem.title isEqualToString:@"The Way You Used To Do"], @"epg title invalid -> %@",parseditem.title);
    XCTAssert([parseditem.artist isEqualToString:@"Queens Of The Stone Age"], @"epg artist invalid -> %@",parseditem.artist);
    XCTAssert([parseditem.album isEqualToString:@"The Way You Used To Do {Single}"], @"epg album invalid -> %@",parseditem.album);
    NSString *imageURL = @"http://www.abc.net.au/triplej/albums/56045/covers/190.jpg";
    XCTAssert([parseditem.imageURL isEqualToString:imageURL], @"epg imageurl invalid -> %@",parseditem.imageURL);
}

- (void) testXMLParserPlayoutItemEmptyCustomFieldsTag{
    
    
    AIMOnAirXMLParser *xmlParser = [[AIMOnAirXMLParser alloc] initWithRawString:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?> <onAir><playoutData> <playoutItem time=\"2017-06-23T10:04:20+10:00\" duration=\"00:03:24\" title=\"The Way You Used To Do\" artist=\"Queens Of The Stone Age\" album=\"The Way You Used To Do {Single}\" status=\"playing\" type=\"song\" imageUrl=\"http://www.abc.net.au/triplej/albums/56045/covers/190.jpg\"> <customFields></customFields> </playoutItem> </playoutData></onAir>"];
    
    xmlParser.delegate = self;
    
    self.xmlParsedExpectation = [[XCTestExpectation alloc] initWithDescription:@"XML document has been parsed"];
    [xmlParser parse];
    
    [self waitForExpectations:@[self.xmlParsedExpectation] timeout:10.0];
    
    XCTAssertNotNil(self.parsedDocument,@"parsed document should have a value");
    
    AIMPlayoutItem *parseditem = [self.parsedDocument.playoutItems lastObject];
    
    XCTAssertNotNil(parseditem,@"parsed document should have a playout item");
    

}


- (void) parser:(id<AIMOnAirDocumentParser>)parser didFinishParsingWithObject:(AIMOnAirDocument *)onAirDocument{
    
    self.parsedDocument = onAirDocument;
    [self.xmlParsedExpectation fulfill];
}

- (void) parser:(id<AIMOnAirDocumentParser>)parser didFailWithError:(NSError *)error{
    
    self.parsingError = error;
    [self.xmlParsedExpectation fulfill];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
