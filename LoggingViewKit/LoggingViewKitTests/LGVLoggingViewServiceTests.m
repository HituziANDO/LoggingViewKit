//
//  LGVLoggingViewServiceTests.m
//  LoggingViewKitTests
//
//  Created by Masaki Ando on 2024/04/05.
//  Copyright © 2024 Hituzi Ando. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <LoggingViewKit/LoggingViewKit-Swift.h>
#import <LoggingViewKit/LoggingViewKit.h>

@interface LGVLoggingViewServiceTests : XCTestCase

@end

@implementation LGVLoggingViewServiceTests

- (void) setUp {
    [LGVSQLiteDatabase deleteTestDatabase];
    LGVLoggingViewService.sharedService.database = [LGVSQLiteDatabase testDatabase];
    [LGVLoggingViewService.sharedService deleteAllLogs];
    [LGVLoggingViewService.sharedService startRecording];
}

- (void) tearDown {
    [LGVLoggingViewService.sharedService stopRecording];
    [LGVLoggingViewService.sharedService deleteAllLogs];
    LGVLoggingViewService.sharedService.database = nil;
    [LGVSQLiteDatabase deleteTestDatabase];
}

- (void) testSave_Click_Event {
    XCTestExpectation *exp = [self expectationWithDescription:@""];

    LGVLoggingAttribute *attr = [LGVLoggingAttribute attributeWithName:@"TestButton"];

    [LGVLoggingViewService.sharedService click:attr completionHandler:^{
         NSArray<LGVLog *> *logs = [LGVLoggingViewService.sharedService allLogs];
         XCTAssertEqual(1, logs.count);

         LGVLog *log = logs.firstObject;
         XCTAssertEqualObjects(@"click", log.eventType);
         XCTAssertEqualObjects(@"TestButton", log.name);

         [exp fulfill];
     }];

    [self waitForExpectations:@[exp] timeout:1];
}

- (void) testSave_Custom_Event {
    XCTestExpectation *exp = [self expectationWithDescription:@""];

    LGVLoggingAttribute *attr = [LGVLoggingAttribute attributeWithName:@"TestLog"];

    [LGVLoggingViewService.sharedService customEvent:@"test_event" attribute:attr completionHandler:^{
         NSArray<LGVLog *> *logs = [LGVLoggingViewService.sharedService allLogs];
         XCTAssertEqual(1, logs.count);

         LGVLog *log = logs.firstObject;
         XCTAssertEqualObjects(@"test_event", log.eventType);
         XCTAssertEqualObjects(@"TestLog", log.name);

         [exp fulfill];
     }];

    [self waitForExpectations:@[exp] timeout:1];
}

- (void) testIncrement_Counter {
    LVKCounter *counter = [LGVLoggingViewService.sharedService counterWithName:@"TestCounter1"];

    XCTAssertEqual(0, counter.count);

    XCTAssertTrue([counter increase]);
    XCTAssertTrue([counter increase]);
    XCTAssertTrue([counter increase]);

    XCTAssertEqual(3, counter.count);
    XCTAssertEqual(3, [LGVLoggingViewService.sharedService counterWithName:@"TestCounter1"].count);
    XCTAssertEqualObjects(@"TestCounter1", counter.name);
}

- (void) testReset_Counter {
    LVKCounter *counter = [LGVLoggingViewService.sharedService counterWithName:@"TestCounter2"];

    [counter increase];
    [counter increase];
    [counter increase];
    XCTAssertEqual(3, counter.count);

    XCTAssertTrue([counter resetWithInitialValue:1]);

    XCTAssertEqual(1, counter.count);
    XCTAssertEqual(1, [LGVLoggingViewService.sharedService counterWithName:@"TestCounter2"].count);
}

- (void) testReturn_Counter_As_nil_If_Service_Not_Started {
    [LGVLoggingViewService.sharedService stopRecording];

    XCTAssertFalse(LGVLoggingViewService.sharedService.isRecording);

    XCTAssertNil([LGVLoggingViewService.sharedService counterWithName:@"TestCounter3"]);
}

- (void) testCan_Increase_Once_A_Day {
    LVKCounter *counter = [LGVLoggingViewService.sharedService counterWithName:@"TestCounter"];

    XCTAssertEqual(0, counter.count);

    XCTAssertTrue([counter increaseWithCondition:LVKIncrementConditionOnceADay]);
    XCTAssertFalse([counter increaseWithCondition:LVKIncrementConditionOnceADay]);

    XCTAssertEqual(1, counter.count);
    XCTAssertEqual(1, [LGVLoggingViewService.sharedService counterWithName:@"TestCounter"].count);
}

- (void) testGet_All_Counters {
    LVKCounter *counter1 = [LGVLoggingViewService.sharedService counterWithName:@"TestCounter1"];
    LVKCounter *counter2 = [LGVLoggingViewService.sharedService counterWithName:@"TestCounter2"];

    [counter1 increase];
    [counter1 increase];
    [counter2 increase];

    NSArray<LVKCounter *> *counters = [LGVLoggingViewService.sharedService allCounters];
    XCTAssertEqual(2, counters.count);
    XCTAssertEqual(2, counters.firstObject.count);
    XCTAssertEqual(1, counters.lastObject.count);
}

- (void) testReturn_Empty_Array_Of_Counters_If_Service_Not_Started {
    LVKCounter *counter1 = [LGVLoggingViewService.sharedService counterWithName:@"TestCounter1"];
    LVKCounter *counter2 = [LGVLoggingViewService.sharedService counterWithName:@"TestCounter2"];

    [counter1 increase];
    [counter2 increase];

    XCTAssertEqual(2, [LGVLoggingViewService.sharedService allCounters].count);

    [LGVLoggingViewService.sharedService stopRecording];

    XCTAssertFalse(LGVLoggingViewService.sharedService.isRecording);
    XCTAssertEqual(0, [LGVLoggingViewService.sharedService allCounters].count);
}

@end
