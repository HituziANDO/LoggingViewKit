# LoggingViewKit

***LoggingViewKit is a library for recording which view a user touched.***

## Include in your iOS app

### CocoaPods

LoggingViewKit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "LoggingViewKit"
```

### Manual Installation

1. Downloads latest [LoggingViewKit](https://github.com/HituziANDO/LoggingViewKit/releases)
1. Drags & Drops LoggingViewKit.framework into your Xcode project
1. Adds `-all_load` to Build Settings > Linking > Other Linker Flags

## Supported View

- Button
- Label
- SegmentedControl
- Slider
- Stepper
- Switch
- View

## Quick Usage

1. Sets LGV UI class in the storyboard

	![screenshot1](./README/images/screenshot1.png)
	
1. Sets arbitrary name to loggingName

	![screenshot2](./README/images/screenshot2.png)
	
	**[NOTE]** Recommend setting a unique name.
	
1. Selects `On` to record the view
	
	**[NOTE]** If selects `Off` or `Default`, the view is not target to record.

1. Starts recording

	**Objective-C**
	
	```objc
	#import <LoggingViewKit/LoggingViewKit.h>
	
	...
	
	@implementation AppDelegate
	
	- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
		
		[[LGVLoggingViewService sharedService] startRecording];
		
		return YES;
	}
	```	
	
	**Swift**
	
	```swift
	import LoggingViewKit
	
	@UIApplicationMain
	class AppDelegate: UIResponder, UIApplicationDelegate {
	
		...
	
		func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
	
			LGVLoggingViewService.shared().startRecording()
	
			return true
		}
		
		...
		
	}
	```

5. Stops recording

	**Objective-C**
	
	```objc
	[[LGVLoggingViewService sharedService] stopRecording];
	```
	
	**Swift**
	
	```swift
	LGVLoggingViewService.shared().stopRecording()
	```
	
6. Reads all logs

	**Objective-C**
	
	```objc
	NSArray<LGVLog *> *logs = [[LGVLoggingViewService sharedService] allLogs];
	```
	
	**Swift**
	
	```swift
	let logs = LGVLoggingViewService.shared().allLogs()
	```
	
7. Deletes all logs
	
	**Objective-C**
	
	```objc
	[[LGVLoggingViewService sharedService] deleteAllLogs];
	```
	
	**Swift**
	
	```swift
	LGVLoggingViewService.shared().deleteAllLogs()
	```

More info, see my [sample project](https://github.com/HituziANDO/LoggingViewKit/tree/master/Sample).

## Sample Log

LoggingViewKit records the following log.

```
{
    ID = 47;
    absoluteClickX = "124.3333282470703";
    absoluteClickY = "189.6666564941406";
    clickX = "108.3333282470703";
    clickY = "145.6666564941406";
    createdAt = "2018-12-25 23:02:13 +0000";
    info =     {
        newValue = 2;
    };
    key = "7F34859D-2164-4B4B-B896-EA9D3D826C92";
    name = SampleSegmentedControl;
}
```
