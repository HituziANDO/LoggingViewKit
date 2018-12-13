//
//  UIView+LGVLogging.h
//  LoggingViewKit
//
//  Created by Masaki Ando on 2018/12/12.
//  Copyright (c) 2018 Hituzi Ando. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (LGVLogging)

@property (nonatomic, copy, nullable, setter=lgv_setName:) NSString *lgv_name;
@property (nonatomic, setter=lgv_setLogging:, getter=lgv_isLogging) BOOL lgv_logging;
/**
 * 指定した数値でタッチ領域を拡張します
 *
 * e.g.)
 * button.tappableInsets = UIEdgeInsetsMake(-20.f, -20.f, -20.f, -20.f);
 */
@property (nonatomic, setter=lgv_setTouchableInsets:) UIEdgeInsets lgv_touchableInsets;
/**
 * タッチ領域を拡張したboundsを返します(read-only)
 */
@property (nonatomic, readonly) CGRect lgv_touchableFrame;

@end

NS_ASSUME_NONNULL_END
