//
//  LGVRealTimeLoggerSwift
//
//  MIT License
//
//  Copyright (c) 2019-present Hituzi Ando. All rights reserved.
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

#import "LGVRealTimeLoggerRef.h"

@interface LGVRealTimeLoggerRef ()

@property (nonatomic) Class loggerClass;
@property (nonatomic) id logger;

@end

@implementation LGVRealTimeLoggerRef

- (instancetype)init {
    self = [super init];

    if (self) {
        _loggerClass = NSClassFromString(@"LGVRealTimeLogger");
        SEL sel = NSSelectorFromString(@"sharedLogger");
        IMP method = [_loggerClass methodForSelector:sel];
        id (*func)(id, SEL) = (void *) method;
        _logger = func(_loggerClass, sel);
    }

    return self;
}

#pragma mark - property

- (NSInteger)logLevel {
    SEL sel = NSSelectorFromString(@"logLevel");
    IMP method = [_loggerClass instanceMethodForSelector:sel];
    NSInteger (*func)(id, SEL) = (void *) method;
    return func(_logger, sel);
}

- (void)setLogLevel:(NSInteger)logLevel {
    SEL sel = NSSelectorFromString(@"setLogLevel:");
    IMP method = [_loggerClass instanceMethodForSelector:sel];
    void (*func)(id, SEL, NSInteger) = (void *) method;
    func(_logger, sel, logLevel);
}

- (id)serializer {
    SEL sel = NSSelectorFromString(@"serializer");
    IMP method = [_loggerClass instanceMethodForSelector:sel];
    id (*func)(id, SEL) = (void *) method;
    return func(_logger, sel);
}

- (void)setSerializer:(id)serializer {
    SEL sel = NSSelectorFromString(@"setSerializer:");
    IMP method = [_loggerClass instanceMethodForSelector:sel];
    void (*func)(id, SEL, id) = (void *) method;
    func(_logger, sel, serializer);
}

- (NSArray *)destinations {
    SEL sel = NSSelectorFromString(@"destinations");
    IMP method = [_loggerClass instanceMethodForSelector:sel];
    NSArray *(*func)(id, SEL) = (void *) method;
    return func(_logger, sel);
}

#pragma mark - public method

- (void)addDestination:(id)destination {
    SEL sel = NSSelectorFromString(@"addDestination:");
    IMP method = [_loggerClass instanceMethodForSelector:sel];
    void *(*func)(id, SEL, id) = (void *) method;
    func(_logger, sel, destination);
}

- (void)logWithLevel:(NSInteger)logLevel
            function:(const char *)function
                line:(NSUInteger)line
          dictionary:(nullable NSDictionary *)dictionary {

    SEL sel = NSSelectorFromString(@"logWithLevel:function:line:dictionary:");
    IMP method = [_loggerClass instanceMethodForSelector:sel];
    void *(*func)(id, SEL, NSInteger, const char *, NSUInteger, NSDictionary *_Nullable) = (void *) method;
    func(_logger, sel, logLevel, function, line, dictionary);
}

@end
