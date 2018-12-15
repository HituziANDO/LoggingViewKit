//
//  LGVLogging.h
//  LoggingViewKit
//
//  Created by Masaki Ando on 2018/12/14.
//  Copyright (c) 2018 Hituzi Ando. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LGVLogging <NSObject>
/**
 * The name to identify the view.
 */
- (nullable NSString *)loggingName;
/**
 * True if logging is enabled, otherwise false.
 */
- (BOOL)isLogging;
/**
 * Touchable bounds.
 */
- (CGRect)touchableBounds;
/**
 * Touchable frame.
 */
- (CGRect)touchableFrame;

@end

NS_ASSUME_NONNULL_END
