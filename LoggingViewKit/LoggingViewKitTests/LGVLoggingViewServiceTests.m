//
//  LGVLoggingViewServiceTests.m
//  LoggingViewKitTests
//
//  Created by Masaki Ando on 2024/04/05.
//  Copyright © 2024 Hituzi Ando. All rights reserved.
//

#import <XCTest/XCTest.h>

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

@end
