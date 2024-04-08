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

#if TARGET_OS_IOS
#import <UIKit/UIKit.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@class LGVError;
@class LGVLog;
@class LGVLoggingAttribute;
@class LGVLoggingViewService;
@class LGVRealTimeLogger;
@class LVKCounter;

@protocol LGVDatabase;

FOUNDATION_EXTERN NSString *const LGVErrorDomain;

@protocol LGVLoggingViewServiceDelegate <NSObject>
@optional
/**
 *
 * @param service The service object
 * @param log A log of occurred event
 * @param attribute An attribute of the target view.
 */
- (void) loggingViewService           :(LGVLoggingViewService *)service
                willSaveLog           :(LGVLog *)log
                  attribute           :(LGVLoggingAttribute *) attribute
    NS_SWIFT_NAME(loggingViewService(_:willSave:attribute:));
/**
 *
 * @param service The service object
 * @param log A saved log
 * @param attribute An attribute of the target view.
 * @param error nil if success, otherwise error object
 */
- (void) loggingViewService           :(LGVLoggingViewService *)service
                 didSaveLog           :(LGVLog *)log
                  attribute           :(LGVLoggingAttribute *)attribute
                      error           :(nullable LGVError *) error
    NS_SWIFT_NAME(loggingViewService(_:didSave:attribute:error:));

@end

@interface LGVError : NSError

+ (instancetype) errorWithMessage:(nullable NSString *)message;

@end

@interface LGVLoggingViewService : NSObject
/**
 * The version of this framework.
 */
@property (class, nonatomic, readonly) NSString *versionString;
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
 * Tells whether the service is started.
 */
@property (nonatomic, readonly) BOOL isRecording;

/**
 * Returns the singleton instance.
 *
 * @return The singleton instance.
 */
+ (instancetype) sharedService;

/**
 * Starts the service.
 */
- (void) startRecording;
/**
 * Stops the service.
 */
- (void) stopRecording;
/**
 * Reads all logs in the database.
 */
- (NSArray<LGVLog *> *) allLogs;
/**
 * Reads logs by given event type in the database.
 */
- (NSArray<LGVLog *> *) logsByEventType:(NSString *) eventType NS_SWIFT_NAME(logs(eventType:));
/**
 * Deletes all logs in the database.
 */
- (void) deleteAllLogs;
/**
 * Deletes logs by given event type in the database.
 */
- (void) deleteLogsByEventType:(NSString *) eventType NS_SWIFT_NAME(deleteLogs(eventType:));
/**
 * Records a click event. To save the event is executed asynchronously.
 *
 * @param attribute An attribute of the target view.
 */
- (void) click:(LGVLoggingAttribute *)attribute;
/**
 * Records a click event. To save the event is executed asynchronously.
 *
 * @param attribute An attribute of the target view.
 * @param completionHandler A block to be executed when the click event is saved to the database.
 */
- (void) click:(LGVLoggingAttribute *)attribute completionHandler:(void (^ _Nullable)(void))completionHandler;
/**
 * Records a custom event. To save the event is executed asynchronously.
 *
 * @param eventType An event type. This value is used as a type of the log.
 * @param attribute An attribute of the event.
 */
- (void) customEvent:(NSString *)eventType attribute:(LGVLoggingAttribute *)attribute;
/**
 * Records a custom event. To save the event is executed asynchronously.
 *
 * @param eventType An event type. This value is used as a type of the log.
 * @param attribute An attribute of the event.
 * @param completionHandler A block to be executed when the custom event is saved to the database.
 */
- (void) customEvent:(NSString *)eventType attribute:(LGVLoggingAttribute *)attribute completionHandler:(void (^ _Nullable)(void))completionHandler;
/**
 * Gets the counter of given name. If the service is not started, this method returns nil.
 *
 * @param name A name of the counter.
 * @return A counter object.
 */
- (nullable LVKCounter *) counterWithName:(NSString *) name NS_SWIFT_NAME(counter(name:));
@end

NS_ASSUME_NONNULL_END
