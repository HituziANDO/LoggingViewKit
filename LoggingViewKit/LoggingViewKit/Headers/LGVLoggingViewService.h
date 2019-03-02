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

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LGVError;
@class LGVLog;
@class LGVLoggingViewService;

@protocol LGVDatabase;
@protocol LGVLogging;

UIKIT_EXTERN NSString *const LGVErrorDomain;

@protocol LGVLoggingViewServiceDelegate <NSObject>
@optional
/**
 *
 * @param service The service object
 * @param log The log of occurred event
 * @param view The target view
 * @param event Occurred event
 */
- (void)loggingViewService:(LGVLoggingViewService *)service
               willSaveLog:(LGVLog *)log
                    ofView:(id <LGVLogging>)view
                 withEvent:(nullable UIEvent *)event;
/**
 *
 * @param service The service object
 * @param log The saved log
 * @param view The target view
 * @param event Occurred event
 * @param error nil if success, otherwise error object
 */
- (void)loggingViewService:(LGVLoggingViewService *)service
                didSaveLog:(LGVLog *)log
                    ofView:(id <LGVLogging>)view
                 withEvent:(nullable UIEvent *)event
                     error:(nullable LGVError *)error;

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
 *
 */
@property (nonatomic, nullable) id <LGVDatabase> database;

/**
 *
 * @return The singleton object
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
 *
 */
- (void)loggingView:(id <LGVLogging>)loggingView
       touchesBegan:(NSSet<UITouch *> *)touches
          withEvent:(nullable UIEvent *)event;
/**
 *
 */
- (void)loggingView:(id <LGVLogging>)loggingView
       touchesEnded:(NSSet<UITouch *> *)touches
          withEvent:(nullable UIEvent *)event;

@end

NS_ASSUME_NONNULL_END
