//
//  LGVLoggingViewService.h
//  LoggingViewKit
//
//  Created by Masaki Ando on 2018/12/12.
//  Copyright (c) 2018 Hituzi Ando. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LGVLoggingViewServiceDelegate <NSObject>
/**
 *
 * @param view
 * @param event
 * @param info
 */
- (void)saveLogOfView:(UIView *)view withEvent:(nullable UIEvent *)event info:(NSDictionary *)info;

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
 * @param view
 * @param touches
 * @param event
 */
- (void)loggingView:(UIView *)view touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event;
/**
 *
 * @param view
 * @param touches
 * @param event
 */
- (void)loggingView:(UIView *)view touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event;

@end

NS_ASSUME_NONNULL_END
