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

- (void) testReturn_Counter_as_nil_If_Service_Not_Started {
    [LGVLoggingViewService.sharedService stopRecording];

    XCTAssertFalse(LGVLoggingViewService.sharedService.isRecording);

    XCTAssertNil([LGVLoggingViewService.sharedService counterWithName:@"TestCounter3"]);
}

@end
