//
//  LoggingViewKit
//
//  MIT License
//
//  Copyright (c) 2022-present Hituzi Ando. All rights reserved.
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
#elif TARGET_OS_MAC
#import <AppKit/AppKit.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface LGVLoggingAttribute : NSObject
/**
 * The name to identify the view.
 */
@property (nonatomic, copy, readonly, nullable) NSString *name;
/**
 * Tells whether the logging is enabled.
 */
@property (nonatomic, readonly) BOOL loggingEnabled;
/**
 * The target view recorded.
 */
@property (nonatomic, readonly, nullable) id view;
/**
 * The appendix information.
 */
@property (nonatomic, copy, nullable) NSDictionary *info;
#if TARGET_OS_IOS
/**
 * The touch event.
 */
@property (nonatomic, nullable) UIEvent *event;
/**
 * A set of touches to record a click event with a point that a user touched.
 */
@property (nonatomic, nullable) NSSet<UITouch *> *touches;
#elif TARGET_OS_MAC
/**
 * The mouse event.
 */
@property (nonatomic, nullable) NSEvent *event;
#endif
/**
 * Creates an object that has specified name to identify the view.
 *
 * @param view A target view.
 * @param name A name to identify the view.
 * @param enabled Tells whether the logging is enabled.
 */
+ (instancetype) attributeWithView:(nullable id)view
                              name:(nullable NSString *)name
                    loggingEnabled:(BOOL)enabled;
/**
 * Creates an object that has specified name to identify the view. The logging is always enabled.
 *
 * @param view A target view.
 * @param name A name to identify the view.
 */
+ (instancetype) attributeWithView:(nullable id)view
                              name:(nullable NSString *)name;
/**
 * Creates an object that has specified name to identify the log item.
 *
 * @param name A name to identify the log item.
 * @param enabled Tells whether the logging is enabled.
 */
+ (instancetype) attributeWithName:(nullable NSString *)name
                    loggingEnabled:(BOOL)enabled;
/**
 * Creates an object that has specified name to identify the log item. The logging is always enabled.
 *
 * @param name A name to identify the log item.
 */
+ (instancetype) attributeWithName:(nullable NSString *)name;

@end

NS_ASSUME_NONNULL_END
