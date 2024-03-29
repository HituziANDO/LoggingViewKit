//
//  LoggingViewKit
//
//  MIT License
//
//  Copyright (c) 2018-present Hituzi Ando. All rights reserved.
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

#import "LGVViewHierarchy.h"

void LGVGetViewHierarchy(_LGVView *view, NSInteger depth, NSMutableArray *hierarchy) {
    NSMutableString *indent = [NSMutableString new];

    for (NSInteger i = 0; i < depth; i++) {
        [indent appendString:@"  "];
    }

    NSMutableString *item = [NSMutableString stringWithFormat:@"%@%@", indent, NSStringFromClass(view.class)];

    if ([view respondsToSelector:NSSelectorFromString(@"loggingName")]) {
        SEL sel = NSSelectorFromString(@"loggingName");
        IMP imp = [view methodForSelector:sel];
        NSString *(*func)(id, SEL) = (void *) imp;
        [item appendFormat:@"(loggingName: %@)", func(view, sel)];
    }

    [hierarchy addObject:item];

    if (view.subviews.count > 0) {
        for (_LGVView *v in view.subviews) {
            LGVGetViewHierarchy(v, depth + 1, hierarchy);
        }
    }
}

@implementation LGVViewHierarchy

+ (void) dump:(_LGVView *)view {
    NSMutableArray *hierarchy = [NSMutableArray new];

    LGVGetViewHierarchy(view, 0, hierarchy);
    NSString *str = [hierarchy componentsJoinedByString:@"\n"];
    NSLog(@"===ViewHierarchy===\n%@", str);
}

@end
