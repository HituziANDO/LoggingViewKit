# LoggingViewKit

LoggingViewKit is a library tracking a user operation.

## Include in Your Project

### Carthage

LoggingViewKit is available through [Carthage](https://github.com/Carthage/Carthage). To install it, simply add the following line to your Cartfile:

```
github "HituziANDO/LoggingViewKit"
```

### CocoaPods

LoggingViewKit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "LoggingViewKit"
```

#### Swift Package Manager

LoggingViewKit is available through Swift Package Manager. To install it using Xcode, specify the git URL for LoggingViewKit.

```
https://github.com/HituziANDO/LoggingViewKit
```

## Supported View

- Button
- Label
- SegmentedControl
- Slider
- Stepper
- Switch
- View

## Quick Usage

1. Set LGV UI class in the storyboard

	![screenshot1](./readme-images/screenshot1.png)
	
1. Set arbitrary name to loggingName

	![screenshot2](./readme-images/screenshot2.png)
	
	**[NOTE]** Recommend setting a unique name.
	
1. Select `On` to record the view
	
	**[NOTE]** If you select `Off` or `Default`, the view is not target to record.

1. Import framework
	
	**Swift**
	
	```swift
	import LoggingViewKit
	```
	
	**Objective-C**
	
	```objc
	#import <LoggingViewKit/LoggingViewKit.h>
	```

1. Start recording
	
	**Swift**
	
	```swift	
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
	
	**Objective-C**
	
	```objc	
	@implementation AppDelegate
	
	- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
		
		[[LGVLoggingViewService sharedService] startRecording];
		
		return YES;
	}
	```	

5. Stop recording
	
	**Swift**
	
	```swift
	LGVLoggingViewService.shared().stopRecording()
	```
	
	**Objective-C**
	
	```objc
	[[LGVLoggingViewService sharedService] stopRecording];
	```

6. Read all logs
	
	**Swift**
	
	```swift
	let logs = LGVLoggingViewService.shared().allLogs()
	```
	
	**Objective-C**
	
	```objc
	NSArray<LGVLog *> *logs = [[LGVLoggingViewService sharedService] allLogs];
	```

7. Delete all logs
	
	**Swift**
	
	```swift
	LGVLoggingViewService.shared().deleteAllLogs()
	```
	
	**Objective-C**
	
	```objc
	[[LGVLoggingViewService sharedService] deleteAllLogs];
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

## Utility

### Dump View Hierarchy

LoggingViewKit can dump the hierarchy of specified view to Xcode console. The sample log is following.

```
2019-04-02 12:11:59.876292+0900 LoggingViewSwiftSample[8616:19026371] ===LGVUtility ViewHierarchy===
UIView
  LGVView(loggingName: (null))
    LGVButton(loggingName: SampleButton)
    LGVSwitch(loggingName: SampleSwitch)
      UISwitchModernVisualElement
        UIView
          UIView
        UIView
          UIView
        UIView
          UIImageView
          UIImageView
        UIImageView
    LGVSegmentedControl(loggingName: SampleSegmentedControl)
      UISegment
        UISegmentLabel
        UIImageView
      UISegment
        UISegmentLabel
        UIImageView
      UISegment
        UISegmentLabel
        UIImageView
      UISegment
        UISegmentLabel
        UIImageView
    LGVStepper(loggingName: SampleStepper)
      _UIStepperButton
      _UIStepperButton
      UIImageView
    LGVLabel(loggingName: SampleLabel)
    LGVView(loggingName: SampleView)
      LGVButton(loggingName: TestButton)
    LGVSlider(loggingName: SampleSlider)
```

#### Usage

**Swift**

```swift
override func viewDidLoad() {
    super.viewDidLoad()

    #if DEBUG
    // Dumps hierarchy of the root view.
    LGVUtility.printViewHierarchy(view)
    #endif
}
```

**[NOTE]** Recommend that you enclose with `#if DEBUG ~ #endif`. Then LoggingViewKit dumps logs only in Debug build.

**How to Enable DEBUG Flag:**

1. Open Build Settings > Swift Compiler - Custom Flags > Other Swift Flags section
1. Add `-DDEBUG` flag to Debug row

**Objective-C**

```objc
- (void)viewDidLoad {
    [super viewDidLoad];

#ifdef DEBUG
    // Dumps the hierarchy of the root view.
    [LGVUtility printViewHierarchy:self.view];
#endif
}
```

**[NOTE]** Recommend that you enclose with `#ifdef DEBUG ~ #endif`. Then LoggingViewKit dumps logs only in Debug build.
