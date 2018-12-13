//
//  LGVSegmentedControl.h
//  LoggingViewKit
//
//  Created by Masaki Ando on 2018/12/12.
//  Copyright (c) 2018 Hituzi Ando. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LGVSegmentedControl : UISegmentedControl

@property (nonatomic, copy, nullable, setter=lgv_setName:) IBInspectable NSString *lgv_name;
@property (nonatomic, setter=lgv_setLogging:, getter=lgv_isLogging) IBInspectable BOOL lgv_logging;

@end

NS_ASSUME_NONNULL_END
