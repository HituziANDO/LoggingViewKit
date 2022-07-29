//
//  LoggingViewKit
//
//  MIT License
//
//  Copyright (c) 2018-present Hituzi Ando. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LGVError;
@class LGVLog;
@class LGVLoggingViewService;
@class LGVRealTimeLogger;

@protocol LGVDatabase;
@protocol LGVLogging;

FOUNDATION_EXTERN NSString *const LGVErrorDomain;

@protocol LGVLoggingViewServiceDelegate <NSObject>
@optional
/**
 *
 * @param service The service object
 * @param log A log of occurred event
 * @param view A target view
 * @param event Occurred event
 */
- (void)loggingViewService:(LGVLoggingViewService *)service
               willSaveLog:(LGVLog *)log
                    ofView:(id <LGVLogging>)view
                 withEvent:(nullable UIEvent *)event
NS_SWIFT_NAME(loggingViewService(_:willSave:of:with:));
/**
 *
 * @param service The service object
 * @param log A saved log
 * @param view A target view
 * @param event Occurred event
 * @param error nil if success, otherwise error object
 */
- (void)loggingViewService:(LGVLoggingViewService *)service
                didSaveLog:(LGVLog *)log
                    ofView:(id <LGVLogging>)view
                 withEvent:(nullable UIEvent *)event
                     error:(nullable LGVError *)error
NS_SWIFT_NAME(loggingViewService(_:didSave:of:with:error:));

@end

@interface LGVError : NSError

+ (instancetype)errorWithMessage:(nullable NSString *)message;

@end

@interface LGVLoggingViewService : NSObject
/**
 *
 */
@property (nonatomic, weak, nullable) id <LGVLoggingViewServiceDelegate> delegate;
/**
 * The service saves logs to given database.
 */
@property (nonatomic, nullable) id <LGVDatabase> database;
/**
 * If you set the logger object, LoggingViewService outputs a log.
 */
@property (nonatomic, nullable) LGVRealTimeLogger *logger;

/**
 * Returns the singleton instance.
 *
 * @return The singleton instance.
 */
+ (instancetype)sharedService;

/**
 * Starts recording logs.
 */
- (void)startRecording;
/**
 * Stops recording logs.
 */
- (void)stopRecording;
/**
 * Reads all logs in the database.
 */
- (NSArray<LGVLog *> *)allLogs;
/**
 * Deletes all logs in the database.
 */
- (void)deleteAllLogs;
/**
 * Records a click event.
 */
- (void)click:(id <LGVLogging>)loggingView;
/**
 * Records a click event with a point that a user touched.
 */
- (void)click:(id <LGVLogging>)loggingView
  withTouches:(nullable NSSet<UITouch *> *)touches
        event:(nullable UIEvent *)event NS_SWIFT_NAME(click(_:touches:event:));

@end

NS_ASSUME_NONNULL_END
