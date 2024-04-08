# LoggingViewKit

![release](https://img.shields.io/github/v/release/HituziANDO/LoggingViewKit?display_name=tag)
![Pod Platform](https://img.shields.io/cocoapods/p/LoggingViewKit.svg?style=flat)
[![Pod Version](https://img.shields.io/cocoapods/v/LoggingViewKit.svg?style=flat)](https://cocoapods.org/pods/LoggingViewKit)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)

LoggingViewKit is a framework records a user's click operation.

## Include in Your Project

### Swift Package Manager

LoggingViewKit is available through Swift Package Manager. To install it using Xcode, specify the git URL for LoggingViewKit.

```
https://github.com/HituziANDO/LoggingViewKit
```

### CocoaPods

LoggingViewKit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "LoggingViewKit"
```

### Carthage

LoggingViewKit is available through [Carthage](https://github.com/Carthage/Carthage). To install it, simply add the following line to your Cartfile:

```
github "HituziANDO/LoggingViewKit"
```

## Import framework

```swift
import LoggingViewKit
```

## Usage

1. Programmatically write click event
	
	In following code, `buttonPressed` method is set to the action method of UIButton.
	
	```swift
	@objc func buttonPressed(_ sender: Any) {
       // Records a click event.
       let attr = LGVLoggingAttribute(view: sender,
                                      name: "SampleButton",
                                      loggingEnabled: true)
       attr.info = ["more-info": "test"]
       LGVLoggingViewService.shared().click(attr)
   }
	```

1. Start recording

	```swift	
	LGVLoggingViewService.shared().startRecording()
	```

1. Stop recording

	```swift
	LGVLoggingViewService.shared().stopRecording()
	```

1. Read all logs

	```swift
	let logs = LGVLoggingViewService.shared().allLogs()
	```

1. Delete all logs

	```swift
	LGVLoggingViewService.shared().deleteAllLogs()
	```

More info, see my [sample project](https://github.com/HituziANDO/LoggingViewKit/tree/master/Sample).

### Use Storyboard

If you use the storyboard, you can set UI class such as `LGVButton` in the storyboard.

![screenshot1](./readme-images/screenshot1.png)

LoggingViewKit has following UI classes by default.

- Button
- Label
- SegmentedControl
- Slider
- Stepper
- Switch
- View

1. Set arbitrary name to Logging Name field

	![screenshot2](./readme-images/screenshot2.png)
	
	**[NOTE]** Recommend setting a unique name.
	
1. Select `On` in Logging field to record the view
	
	**[NOTE]** If you select `Off` or `Default`, the view is not target to record.

## Sample Log

LoggingViewKit records logs like the following log.

```
{
    ID = 47;
    eventType = "click";
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

## Dump View Hierarchy

LoggingViewKit can dump the hierarchy of specified view to Xcode console. The sample log is following.

```
2019-04-02 12:11:59.876292+0900 LoggingViewSwiftSample[8616:19026371] ===ViewHierarchy===
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

### Usage

```swift
override func viewDidLoad() {
    super.viewDidLoad()

    #if DEBUG
    // Dumps hierarchy of the root view.
    LGVViewHierarchy.dump(view)
    #endif
}
```

**[NOTE]** Recommend that you enclose with `#if DEBUG ~ #endif`. Then LoggingViewKit dumps logs only in Debug build.

**How to Enable DEBUG Flag:**

1. Open Build Settings > Swift Compiler - Custom Flags > Other Swift Flags section
1. Add `-DDEBUG` flag to Debug row
