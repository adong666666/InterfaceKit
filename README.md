# InterfaceKit
========================

[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/InterfaceKit.svg)](https://img.shields.io/cocoapods/v/InterfaceKit.svg)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
<a href="https://github.com/apple/swift-package-manager" alt="Swift Package Manager Compatible" title="InterfaceKit on Swift Package Manager"><img src="https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg" /></a>
<img src="https://img.shields.io/badge/platforms-iOS%20%7C%20macOS%20%7C%20tvOS%20%7C%20watchOS%20%7C%20Linux-333333.svg" alt="Supported Platforms: iOS, macOS, tvOS, watchOS & Linux" />
<a href="https://zsd.name" target="_blank"><img src="https://github.com/adong666666/InterfaceKit/workflows/InterfaceKit%20CI/badge.svg?branch=master" alt="Build Status" /></a>
[![Language](http://img.shields.io/badge/language-Swift-brightgreen.svg?style=flat
)](https://developer.apple.com/swift)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat
)](http://mit-license.org)
[![Issues](https://img.shields.io/github/issues/adong666666/InterfaceKit.svg?style=flat
)](https://github.com/adong666666/InterfaceKit/issues?state=open)
[![QQ](https://img.shields.io/badge/QQ-3440217568-yellow.svg?style=flat)]()
[![GitHub stars](https://img.shields.io/github/stars/adong666666/InterfaceKit.svg)](https://github.com/adong666666/InterfaceKit/stargazers)

`One line of code` to implement interfaces of `UIKit,AppKit,and WatchKit` in `SwiftUI` interface!

##### ![cn](https://github.com/adong666666/InterfaceKit/raw/master/Pictures/China.png) Chinese (Simplified): [中文文档](https://github.com/adong666666/InterfaceKit/blob/master/README.zh-Hans.md)
##### Code interpretation document: [https://github.com/adong666666/InterfaceKitDoc](https://github.com/adong666666/InterfaceKitDoc)(or this repository's `Docs`)

The basic idea of InterfaceKit is that we want some user interface abstraction layer that sufficiently encapsulates actually calling UIKit,AppKit,and WatchKit directly. It should be simple enough that common things are easy, but comprehensive enough that complicated things are also easy.

You can check out more about the project direction in the [vision document](https://github.com/adong666666/InterfaceKit/blob/master/Vision.md).
```none
                    ┌──────────────┐
                    │   SwiftUI    │
                    └──────▲───────┘
                           │        
┌──────────────────────────┴───────────────────────────┐
│                    InterfaceKit                      │
└───────▲──────────────────▲───────────────────▲───────┘
        │                  │                   │        
┌───────┴──────┐    ┌──────┴───────┐    ┌──────┴───────┐
│     UIKit    │    │    AppKit    │    │   WatchKit   │
└──────────────┘    └──────────────┘    └──────────────┘
```

- [Features](#features)
- [Usage](#usage)
- [Requirements](#requirements)
- [Communication](#communication)
- [Status](#status)
- [Installation](#installation)
- [FAQ](#faq)
- [Credits](#credits)
- [Donations](#donations)
- [Contributing](#contributing)
- [License](#license)
- [History](#history)

## Features

- [x] use interface of UIKit in SwiftUI interface 
- [x] use interface of AppKit in SwiftUI interface
- [x] use interface of WatchKit in SwiftUI interface

## Usage

### Universal

#### For iOS or tvOS:

- To present UIView.
```swift
InterfaceView(MyUIView())
```

- To present UIViewController.
```swift
InterfaceViewController(MyUIViewController())
```

#### For macOS:

- To present NSView.
```swift
NSInterfaceView(MyNSView())
```

- To present NSViewController.
```swift
NSInterfaceViewController(MyNSViewController())
```

#### For watchOS:

- To present WKInterfaceObject. 

```swift
WKInterfaceView(MyWKInterfaceObject())
```

#### eg.

```swift
import SwiftUI
import InterfaceKit

struct MyInterfaceView: View {
    var body: some View {
        ZStack {
            InterfaceViewController(MyViewController())
            InterfaceView(MyView())
            SwiftUIView()
        }
    }
}

#if DEBUG
struct MyInterfaceView_Previews: PreviewProvider {
    static var previews: some View {
        MyInterfaceView()
    }
}
#endif
```

### With Closure

You can do something while presenting SwiftUI view.

- For Example

```swift
InterfaceViewController(MyUIViewController.shared, {
    print("Hello World")
    MyUIViewController.shared.delegate = SomeViewControler.shared
    MyUIViewController.shared.view.alpha = 0.5
    MyUIViewController.shared.view.backgroundColor = .white
    MyUIViewController.someFunction()
    networkRequest()
    JSONParsing()
    downloadFile()
    showProgress()
    makeToast()
    databaseOperation()
    //do something
    ...
})
.navigationBarBackButtonHidden(false)
.navigationBarHidden(false)
.navigationBarTitle(I18n.localizedString("Title"), displayMode: .large)
```

### Multiple platforms

InterfaceKit makes it clearer for multiple platforms programming.
- For Example

```swift
import SwiftUI
import MapKit
import InterfaceKit

let kStr = "Hello World"
#if os(iOS) || os(tvOS)
    typealias OSViewController = UIViewController
    typealias OSView = UILabel
    typealias OSInterfaceView = InterfaceView
    typealias OSInterfaceVC = InterfaceViewController
    let kBounds = UIScreen.main.bounds as CGRect?
#elseif os(macOS)
    typealias OSViewController = NSViewController
    typealias OSView = NSTextField
    typealias OSInterfaceView = NSInterfaceView
    typealias OSInterfaceVC = NSInterfaceViewController
    let kBounds = NSScreen.main?.frame
#endif

@main
struct EApp: App {
    var body: some Scene {
        WindowGroup {
            ZStack {
                #if !os(watchOS)
                    OSInterfaceView(MKMapView())
                    OSInterfaceView(MyView(), { print(kStr) })
                    OSInterfaceVC(MyVC())
                #else
                    WKInterfaceView(WKInterfaceMap(), { print(kStr) })
                #endif
                Text(kStr).foregroundColor(.purple)
            }
        }
    }
}

#if !os(watchOS)
class MyVC: OSViewController {
    #if os(iOS) || os(tvOS)
        override func viewDidLoad() {
            let lbl = MyView()
            lbl.textAlignment = .right
            view.addSubview(lbl)
        }
    #elseif os(macOS)
        override func loadView() { view = MyView() }
    #endif
}

class MyView: OSView {
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: kBounds!.height / 2 - 60, width: kBounds!.width, height: 40))
        #if os(iOS) || os(tvOS)
            text = kStr
        #elseif os(macOS)
            stringValue = kStr
        #endif
    }
    
    required init?(coder: NSCoder) { fatalError() }
}
#endif
```

## Requirements

- iOS 13.0+ / macOS 10.15+ / tvOS 13.0+ / watchOS 6.0+
- Xcode 11+
- Swift 5.1+

## Communication

- QQ Group: 1027277979
- If you'd like to contact me, use mail:3440217568@qq.com or QQ:3440217568 or WeChat:adongenjoylife or telephone:15674119605.
- If you found a bug, and can provide steps to reliably reproduce it, please open an issue.
- If you have a feature request, please open an issue.
- If you want to contribute, please submit a pull request.

## Status

This project is actively under development. We consider it ready for production use.

## Installation

Below is a table that shows which version of InterfaceKit you should use for your Swift version.

| Swift | InterfaceKit   | 
| ----- | -------------- |
| 5.X   | >= 5.4.0       | 

InterfaceKit supports multiple methods for installing the library in a project.

### Copy to your project

Clone the repository by running the following command:
```
git clone https://github.com/adong666666/InterfaceKit.git --depth=1
```

Copy the Swift files in `InterfaceKit` folder to your project.
<div align="center"><img src="https://github.com/adong666666/InterfaceKit/raw/master/Pictures/copy_files.png" alt="Copy files" /></div>

- If for iOS or tvOS project, you can copy the file `UIInterface.swift`.
- If for macOS project, you can copy the file `NSInterface.swift`.
- If for watchOS project, you can copy the file `WKInterface.swift`.

### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. If you have not installed CocoaPods, just install it with the following command:
```
$ gem install cocoapods
```

<br />
You need a `Podfile` to Integrate InterfaceKit into your Xcode project with CocoaPods. If you do not have a Podfile, just create one or use the Podfile provided in `PodfileExample` folder by this repository. Podfile is as follows.

```ruby
# Podfile
source 'https://github.com/CocoaPods/Specs.git'
# platform:ios, '13.0'
use_frameworks!
inhibit_all_warnings!

target 'YOUR_TARGET_NAME' do
    pod 'InterfaceKit'
end

# post_install do |installer_representation|
#   installer_representation.pods_project.targets.each do |target|
#     target.build_configurations.each do |config|
#       config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
#     end
#   end
# end
```

Replace `YOUR_TARGET_NAME` with your project name.
To integrate InterfaceKit into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'InterfaceKit'
```

Maybe you have not update CocoaPods, then `InterfaceKit` may not be found, you can run `pod update` to update CocoaPods, or just run the following command. 

```ruby
pod 'InterfaceKit', :git => 'https://github.com/adong666666/InterfaceKit.git'
```

- If just for iOS or tvOS project, you can specify it in your `Podfile`:
```ruby
pod 'InterfaceKit/UIKit'
``` 

- If just for mac project, you can specify it in your `Podfile`:
```ruby
pod 'InterfaceKit/AppKit'
``` 

- If just for watchOS project, you can specify it in your `Podfile`:
```ruby
pod 'InterfaceKit/WatchKit'
``` 

- If you want to use the newest release of the framework, you can specify it in your `Podfile`:
```ruby
pod 'InterfaceKit', :git => 'https://github.com/adong666666/InterfaceKit.git'
``` 

- If you want to use the `specific` release of the framework, you can specify it like following in your `Podfile`:
```ruby
pod 'InterfaceKit', :git => 'https://github.com/adong666666/InterfaceKit.git', :branch => 'master'#, commit: "b7e1facdedd8fe16d04ef5f47c4697e89bad9f27", '~> 5.4.0', :tag => '5.4.0'
``` 

Then, in the `Podfile` directory(Make sure that your Podfile and your xcodeproj file are in the same directory), run the following command:
```
$ pod install
```

<div align="center"><img src="https://github.com/adong666666/InterfaceKit/raw/master/Pictures/PodfileLocation.png" alt="Podfile Location" /></div>

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.
1. To integrate InterfaceKit into your Xcode project using Carthage, specify it in your `Cartfile`(If you don't have Cartfile, just create one or use the Cartfile provided by this repository in `CartfileExample` folder):
```ogdl
github "adong666666/InterfaceKit" "master"
```

2. Then, in the `Cartfile` directory(Make sure that your Podfile and your xcodeproj file are in the same directory), run `carthage update --use-xcframeworks`. 
   OR
   - For iOS project, Run `carthage update --platform iOS`.
   - For macOS project, Run `carthage update --platform macOS`.
   - For tvOS project, Run `carthage update --platform tvOS`.
   - For watchOS project, Run `carthage update --platform watchOS`. 
<div align="center"><img src="https://github.com/adong666666/InterfaceKit/raw/master/Pictures/CartfileLocation.png" alt="Cartfile Location" /></div>

3. On your application targets’ `"General"` settings tab, in the `"Frameworks,Libraries,and Embedded Content"` section, drag and drop `InterfaceKit` xcframework (or just select the appropriate framework from xcframework) from the Carthage/Build folder on disk.

#### Carthage as a Static Library

Carthage defaults to building InterfaceKit as a Dynamic Library. 

If you wish to build InterfaceKit as a Static Library using Carthage you may use the script below to manually modify the framework type before building with Carthage:

```bash
carthage update InterfaceKit --platform iOS --no-build
sed -i -e 's/MACH_O_TYPE = mh_dylib/MACH_O_TYPE = staticlib/g' Carthage/Checkouts/InterfaceKit/InterfaceKit/InterfaceKit.xcodeproj/project.pbxproj
carthage build InterfaceKit --platform iOS
```

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. It is in early development, but InterfaceKit does support its use on supported platforms.

1. Once you have your Swift package set up, adding InterfaceKit as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`. Then run `swift build`.

```swift
dependencies: [
    .package(url: "https://github.com/adong666666/InterfaceKit.git", .upToNextMajor(from: "5.4.0"))
]
```

OR

1. In Xcode, select File > Swift Packages > Add Package Dependency.
2. Follow the prompts using the URL("https://github.com/adong666666/InterfaceKit.git") for this repository.
<div align="center"><img src="https://github.com/adong666666/InterfaceKit/raw/master/Pictures/SwiftPackageManager.png" alt="Swift Package Manager Configuration" /></div>

### Manually

If you prefer not to use any of the aforementioned dependency managers, you can integrate InterfaceKit into your project manually.

#### Embedded Framework

- Open up Terminal, `cd` into your top-level project directory, and run the following command "if" your project is not initialized as a git repository:

```bash
$ git init
```

- Add InterfaceKit as a git [submodule](https://git-scm.com/docs/git-submodule) by running the following command:

```bash
$ git submodule add https://github.com/adong666666/InterfaceKit.git
```

- Open the `InterfaceKit` folder, and drag the `InterfaceKit.xcodeproj` into the Project Navigator of your application's Xcode project.

    > It should appear nested underneath your application's blue project icon. Whether it is above or below all the other Xcode groups does not matter.

<div align="center"><img src="https://github.com/adong666666/InterfaceKit/raw/master/Pictures/drag_framework.png" alt="Drag and drop xcodeproj" /></div>

- Select the `InterfaceKit.xcodeproj` in the Project Navigator and verify the deployment target matches that of your application target.
- Next, select your application project in the Project Navigator (blue project icon) to navigate to the target configuration window and select the application target under the "Targets" heading in the sidebar.
- In the tab bar at the top of that window, open the `"General"` panel.
- Click on the `+` button under the `"Frameworks,Libraries,and Embedded Content"` section.
- You will see the `InterfaceKit` folder under `Workspace`. There are `InterfaceKit.framework` and  `InterfaceKitTests.xctest` in the `InterfaceKit` folder`

    > Click `InterfaceKit.framework`, and then click `Add`

<div align="center"><img src="https://github.com/adong666666/InterfaceKit/raw/master/Pictures/add_framework.png" alt="Add framework" /></div>

- And that's it!

    > The `InterfaceKit.framework` is automagically added as a target dependency, linked framework and embedded framework in a copy files build phase which is all you need to build on the simulator and a device.

### Unzip,drag and drop

1. Unzip the `InterfaceKit.xcframework.zip` file provided by the repository.
<div align="center"><img src="https://github.com/adong666666/InterfaceKit/raw/master/Pictures/unzip.png" alt="Unzip" /></div>

2. On your application targets’ `“General”` settings tab, in the `"Frameworks,Libraries,and Embedded Content"` section, drag and drop the unzipped file `InterfaceKit.xcframework` (or just select the appropriate framework from InterfaceKit.xcframework).
- If you use `xcfameworks`, just drag and drop `InterfaceKit.xcframework`. `InterfaceKit.xcframework` supports all four platforms(`iOS, macOS, tvOS, watchOS`).
<div align="center"><img src="https://github.com/adong666666/InterfaceKit/raw/master/Pictures/use_xcframeworks.png" alt="Use xcframeworks" /></div>

- If you use `frameworks`, select the appropriate framework from InterfaceKit.xcframework according to the folder name and the platform of your project.
<div align="center"><img src="https://github.com/adong666666/InterfaceKit/raw/master/Pictures/use_frameworks.png" alt="Use frameworks" /></div>

## FAQ

### Why use InterfaceKit?

`One line of code` to implement interfaces of `UIKit,AppKit,and WatchKit` in `SwiftUI` interface! InterfaceKit supports for all four platforms(`iOS, macOS, tvOS, watchOS`). InterfaceKit is `constantly` updated.

## Credits

InterfaceKit is owned and maintained by [Saidong Zhang](https://zsd.name). You can follow him on github at [@Github](https://github.com/adong666666) for project updates and releases. 

### Security Disclosure

If you believe you have identified a security vulnerability with InterfaceKit, you should report it as soon as possible via email to 3440217568@qq.com. 

## Donations

No donation required, but thanks anyway.

## Contributing

Hey! Do you like InterfaceKit? Awesome! We could actually really use your help!

Open source isn't just writing code. InterfaceKit could use your help with any of the following:

- Finding (and reporting!) bugs.
- New feature suggestions.
- Answering questions on issues.
- Documentation improvements.
- Reviewing pull requests.
- Helping to manage issue priorities.
- Fixing bugs/new features.

If any of that sounds cool to you, send a pull request! After your first contribution, we will add you as a member to the repo so you can merge pull requests and help steer the ship :ship: You can read more details about that [in our contributor guidelines](https://github.com/adong666666/InterfaceKit/blob/master/CONTRIBUTING.md).

InterfaceKit's community has a tremendous positive energy, and the maintainers are committed to keeping things awesome. Like [in the CocoaPods community](https://github.com/CocoaPods/CocoaPods/wiki/Communication-&-Design-Rules), always assume positive intent; even if a comment sounds mean-spirited, give the person the benefit of the doubt.

Please note that this project is released with a Contributor Code of Conduct. By participating in this project you agree to abide by [its terms](https://github.com/adong666666/InterfaceKit/blob/master/Code%20of%20Conduct.md).

### Adding new source files

If you add or remove a source file from InterfaceKIt, a corresponding change needs to be made to the `InterfaceKit.xcworkspace` project at the root of this repository. This project is used for Carthage. Don't worry, you'll get an automated warning when submitting a pull request if you forget.

### Help us improve InterfaceKit documentation

Whether you’re a core member or a user trying it out for the first time, you can make a valuable contribution to InterfaceKit by improving the documentation. Help us by:

- sending us feedback about something you thought was confusing or simply missing
- suggesting better wording or ways of explaining certain topics
- sending us a pull request via GitHub
- improving the [Chinese documentation](https://github.com/adong666666/InterfaceKit/blob/master/README.zh-Hans.md)

### Too wordy about the above? Then just do it.

* Fork the repository!
* Create your feature branch: `git checkout -b my-new-feature`
* Commit your changes: `git commit -am 'Add some feature'`
* Push to the branch: `git push origin my-new-feature`
* Submit a pull request
* Other: 
[See CONTRIBUTING.md](https://github.com/adong666666/InterfaceKit/blob/master/CONTRIBUTING.md) for details.

## License

InterfaceKit is released under the MIT license. [See LICENSE](https://github.com/adong666666/InterfaceKit/blob/master/LICENSE.md) for details.

## History

[See CHANGELOG.md](https://github.com/adong666666/InterfaceKit/blob/master/CHANGELOG.md) for details.
