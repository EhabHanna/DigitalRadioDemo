//
//  DigitalRadioDemoTests.m
//  DigitalRadioDemoTests
//
//  Created by Ehab Hanna on 23/6/17.
//  Copyright © 2017 Ehab Hanna. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AIMOnAirDocument.h"

@interface DigitalRadioDemoTests : XCTestCase

@end

@implementation DigitalRadioDemoTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
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
    [test setObject:@"http://www.abc.net.au/triplej/albums/56045/covers/190.jpg" forKey:@"imageURL"];
    
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

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
