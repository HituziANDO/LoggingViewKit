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

#import "LGVLoggingView.h"

@interface LGVLoggingView ()

@property (nonatomic, copy, nullable) NSString *name;
@property (nonatomic) BOOL loggingEnabled;

@end

@implementation LGVLoggingView

+ (instancetype)named:(NSString *)name loggingEnabled:(BOOL)enabled {
    return [[LGVLoggingView alloc] initWithName:name
                                 loggingEnabled:enabled
                                           info:nil];
}

+ (instancetype)named:(NSString *)name
       loggingEnabled:(BOOL)enabled
                 info:(NSDictionary *)info {
    return [[LGVLoggingView alloc] initWithName:name
                                 loggingEnabled:enabled
                                           info:info];
}

- (instancetype)initWithName:(NSString *)name
              loggingEnabled:(BOOL)enabled
                        info:(NSDictionary *)info {
    if (self = [super init]) {
        _name = name;
        _loggingEnabled = enabled;
        _info = info;
    }

    return self;
}

- (nullable NSString *)loggingName {
    return self.name;
}

- (BOOL)isLogging {
    return self.loggingEnabled;
}

@end
