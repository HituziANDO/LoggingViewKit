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

#import "LGVLoggingAttribute.h"

@implementation LGVLoggingAttribute

+ (instancetype) attributeWithView:(id)view
                              name:(NSString *)name
                    loggingEnabled:(BOOL)enabled {
    return [[LGVLoggingAttribute alloc] initWithView:view
                                                name:name
                                      loggingEnabled:enabled];
}

+ (instancetype) attributeWithView:(id)view name:(NSString *)name {
    return [self attributeWithView:view name:name loggingEnabled:YES];
}

+ (instancetype) attributeWithName:(NSString *)name loggingEnabled:(BOOL)enabled {
    return [[LGVLoggingAttribute alloc] initWithView:nil
                                                name:name
                                      loggingEnabled:enabled];
}

+ (instancetype) attributeWithName:(NSString *)name {
    return [self attributeWithName:name loggingEnabled:YES];
}

- (instancetype) initWithView:(id)view
                         name:(NSString *)name
               loggingEnabled:(BOOL)enabled {
    if (self = [super init]) {
        _view = view;
        _name = name;
        _loggingEnabled = enabled;
    }

    return self;
}

@end
