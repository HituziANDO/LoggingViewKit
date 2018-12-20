//
//  LGVLoggingViewService.h
//  LoggingViewKit
//
//  Created by Masaki Ando on 2018/12/12.
//  Copyright (c) 2018 Hituzi Ando. All rights reserved.
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
