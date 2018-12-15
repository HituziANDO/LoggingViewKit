//
//  LGVLoggingViewService.h
//  LoggingViewKit
//
//  Created by Masaki Ando on 2018/12/12.
//  Copyright (c) 2018 Hituzi Ando. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LGVLoggingViewService;

@protocol LGVLogging;

@protocol LGVLoggingViewServiceDelegate <NSObject>
/**
 *
 * @param service The service object
 * @param view The target view
 * @param event Occurred event
 * @param info The appendix information
 */
- (void)loggingViewService:(LGVLoggingViewService *)service
             saveLogOfView:(id <LGVLogging>)view
                 withEvent:(nullable UIEvent *)event
                      info:(NSDictionary *)info;

@end

@interface LGVLoggingViewService : NSObject
/**
 *
 */
@property (nonatomic, weak, nullable) id <LGVLoggingViewServiceDelegate> delegate;

/**
 *
 * @return The singleton object
 */
+ (instancetype)sharedService;

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
