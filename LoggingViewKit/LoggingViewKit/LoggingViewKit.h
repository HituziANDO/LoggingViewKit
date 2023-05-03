//
//  LoggingViewKit.h
//  LoggingViewKit
//
//  Created by Masaki Ando on 2022/07/27.
//

#import <Foundation/Foundation.h>

// ! Project version number for LoggingViewKit.
FOUNDATION_EXPORT double LoggingViewKitVersionNumber;

// ! Project version string for LoggingViewKit.
FOUNDATION_EXPORT const unsigned char LoggingViewKitVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <LoggingViewKit/PublicHeader.h>

#import <LoggingViewKit/LGVDatabase.h>
#import <LoggingViewKit/LGVLog.h>
#import <LoggingViewKit/LGVLogging.h>
#import <LoggingViewKit/LGVLoggingAttribute.h>
#import <LoggingViewKit/LGVLoggingViewService.h>
#import <LoggingViewKit/LGVRealTimeLogger.h>
#import <LoggingViewKit/LGVSQLiteDatabase.h>
#import <LoggingViewKit/LGVViewHierarchy.h>

#if TARGET_OS_IOS
#import <LoggingViewKit/LGVButton.h>
#import <LoggingViewKit/LGVLabel.h>
#import <LoggingViewKit/LGVSegmentedControl.h>
#import <LoggingViewKit/LGVSlider.h>
#import <LoggingViewKit/LGVStepper.h>
#import <LoggingViewKit/LGVSwitch.h>
#import <LoggingViewKit/LGVTextField.h>
#import <LoggingViewKit/LGVTextView.h>
#import <LoggingViewKit/LGVView.h>
#endif
