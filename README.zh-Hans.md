# InterfaceKit
========================

[![CocoaPods兼容性](https://img.shields.io/cocoapods/v/InterfaceKit.svg)](https://img.shields.io/cocoapods/v/InterfaceKit.svg)
[![Carthage兼容性](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
<a href="https://github.com/apple/swift-package-manager" alt="Swift Package Manager兼容性" title="Swift Package Manager上的InterfaceKit"><img src="https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg" /></a>
<img src="https://img.shields.io/badge/platforms-iOS%20%7C%20macOS%20%7C%20tvOS%20%7C%20watchOS%20%7C%20Linux-333333.svg" alt="平台支持：iOS，macOS，tvOS，watchOS和Linux" />
<a href="https://zsd.name" target="_blank"><img src="https://github.com/adong666666/InterfaceKit/workflows/InterfaceKit%20CI/badge.svg?branch=master" alt="Build Status" /></a>
[![编程语言](http://img.shields.io/badge/language-Swift-brightgreen.svg?style=flat
)](https://developer.apple.com/swift)
[![许可](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat
)](http://mit-license.org)
[![问题](https://img.shields.io/github/issues/adong666666/InterfaceKit.svg?style=flat
)](https://github.com/adong666666/InterfaceKit/issues?state=open)
[![QQ](https://img.shields.io/badge/QQ-3440217568-yellow.svg?style=flat)]()
[![GitHub关注数](https://img.shields.io/github/stars/adong666666/InterfaceKit.svg)](https://github.com/adong666666/InterfaceKit/stargazers)

`一行代码`实现在`SwiftUI`界面使用`UIKit、AppKit和WatchKit`的接口！

##### English: [English Document](https://github.com/adong666666/InterfaceKit/blob/master/README.md)
##### 代码解释文档：[https://github.com/adong666666/InterfaceKitDoc](https://github.com/adong666666/InterfaceKitDoc)（或此存储库的`Docs`）
 
InterfaceKit的基本思想是，我们想要一些用户界面抽象层，它能充分封装直接调用UIKit，AppKit和WatchKit。它应该足够简单，使普通的东西容易，但要足够全面，使复杂的东西也容易。

您可以在[愿景](https://github.com/adong666666/InterfaceKit/blob/master/Vision.zh-Hans.md)中查看有关项目方向的更多信息。
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

- [功能](#功能)
- [使用](#使用)
- [平台](#平台)
- [社区](#社区)
- [状态](#状态)
- [安装](#安装)
- [常见问题](#常见问题)
- [信用](#信用)
- [捐献](#捐献)
- [贡献](#贡献)
- [许可](#许可)
- [版本历史](#版本历史)

## 功能

- [x] 在SwiftUI界面使用UIKit
- [x] 在SwiftUI界面使用AppKit
- [x] 在SwiftUI界面使用WatchKit

## 使用

### 常规用法

#### 对于iOS或tvOS：

- 展示UIView
```swift
InterfaceView(MyUIView())
```

- 展示UIViewController
```swift
InterfaceViewController(MyUIViewController())
```

#### 对于macOS：

- 展示NSView
```swift
NSInterfaceView(MyNSView())
```

- 展示NSViewController
```swift
NSInterfaceViewController(MyNSViewController())
```

#### 对于watchOS：

- 展示WKInterfaceObject

```swift
WKInterfaceView(MyWKInterfaceObject())
```

#### 示例：

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

### 配合闭包使用

展示SwiftuI视图时，您可以执行一些操作。

- 示例

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

### 多平台

InterfaceKit 让多平台编程更加清晰。
- 示例

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

## 平台

- iOS 13.0+ / macOS 10.15+ / tvOS 13.0+ / watchOS 6.0+
- Xcode 11+
- Swift 5.1+

## 交流

- QQ群：1027277979
- 您可以和我联系（邮箱：3440217568@qq.com，QQ：3440217568，微信：adongenjoylife，电话：15674119605）。
- 如果您发现了一个bug，并且可以提供可靠地重现它的步骤，请打开一个问题。
- 如果您有一个特性请求，请打开一个问题。
- 如果您想贡献，请提交一个拉取请求。

## 状态

这个项目正在积极开发中。我们认为它可以用于项目开发。

## 安装

下表显示了您应该根据您的Swift版本使用哪个版本的InterfaceKit。

| Swift | InterfaceKit   | 
| ----- | -------------- |
| 5.X   | >= 5.4.0       | 

InterfaceKit支持多种方法在项目中安装框架。

### 直接拷贝

通过运行以下命令来克隆此存储库：
```
git clone https://github.com/adong666666/InterfaceKit.git --depth=1
```

将github工程中的`InterfaceKit`文件夹下的Swift文件复制到您的工程中。
<div align="center"><img src="https://github.com/adong666666/InterfaceKit/raw/master/Pictures/copy_files.png" alt="拷贝文件" /></div>

- 如果是iOS或tvOS项目，您可以复制文件`UIInterface.swift`。
- 如果是macOS项目，您可以复制文件`NSInterface.swift`。
- 如果是watchOS项目，您可以复制文件`WKInterface.swift`。

### CocoaPods安装

[CocoaPods](https://cocoapods.org) 是Cocoa项目的依赖关系管理器。有关使用和安装说明，请访问他们的网站。如果您还没有安装cocoapods则请先执行如下命令：
```
$ gem install cocoapods
```

<br />
您需要一个`Podfile`文件来通过CocoaPods整合InterfaceKit到您的Xcode工程中去, 如果您没有Podfile，那么直接创建一个Podfile或使用此存储库在`PodfileExample`文件夹中提供的Podfile。Podfile的内容如下：

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

用您的项目名称替换`YOUR_TARGET_NAME`。
要使用CocoaPods将InterfaceKit集成到Xcode项目中，请在`Podfile`中指定它：

```ruby
pod 'InterfaceKit'
```

或许您还没有更新CocoaPods, 那么`InterfaceKit` 可能不会被找到，您可以运行 `pod update`来更新CocoaPods，或者直接运行下面的命令行：

```ruby
pod 'InterfaceKit', :git => 'https://github.com/adong666666/InterfaceKit.git'
```

- 如果只是针对iOS或tvOS项目，您可以在`Podfile`中指定它：
```ruby
pod 'InterfaceKit/UIKit'
``` 

- 如果只是针对macOS项目，您可以在`Podfile`中指定它：
```ruby
pod 'InterfaceKit/AppKit'
``` 

- 如果只是针对watchOS项目，您可以在`Podfile`中指定它：
```ruby
pod 'InterfaceKit/WatchKit'
``` 

- 如果您要使用此框架的最新发布的版本，您可以在`Podfile`中指定它：
```ruby
pod 'InterfaceKit', :git => 'https://github.com/adong666666/InterfaceKit.git'
``` 

- 如果您要使用此框架的`特定的`某一个版本，您可以在`Podfile`中指定它：
```ruby
pod 'InterfaceKit', :git => 'https://github.com/adong666666/InterfaceKit.git', :branch => 'master'#, commit: "b7e1facdedd8fe16d04ef5f47c4697e89bad9f27", '~> 5.4.0', :tag => '5.4.0'
``` 

然后，在`Podfile`所在的目录中（确保Podfile和xcodeproj文件位于同一目录中），运行以下命令：
```
$ pod install
```

<div align="center"><img src="https://github.com/adong666666/InterfaceKit/raw/master/Pictures/PodfileLocation.png" alt="Podfile位置" /></div>

### Carthage

[Carthage](https://github.com/Carthage/Carthage)是一个分散的依赖关系管理器，它构建依赖关系并为您提供二进制框架。
1. 要使用Carthage将InterfaceKit集成到Xcode项目中，请在此您的`Cartfile`中指定它（如果没有Cartfile，只需创建一个或使用此存储库在`CartfileExample`文件夹中提供的Cartfile）：
```ogdl
github "adong666666/InterfaceKit" "master"
```

2. 然后，在`Cartfile`目录中（确保Podfile和xcodeproj文件位于同一目录中），运行`carthage update --use xcframeworks`。
   或者
   - 对于iOS工程, 运行`carthage update --platform iOS`。
   - 对于macOS工程, 运行`carthage update --platform macOS`。
   - 对于tvOS工程, 运行`carthage update --platform tvOS`。
   - 对于watchOS工程, 运行`carthage update --platform watchOS`。 
   <div align="center"><img src="https://github.com/adong666666/InterfaceKit/raw/master/Pictures/CartfileLocation.png" alt="Cartfile 位置" /></div>
   
3. 在您的应用程序目标`“General”`设置选项卡的`“Frameworks,Libraries,and Embedded Content”`部分中，从磁盘上的Carthage/Build文件夹拖放`InterfaceKit`xcframework（或从xcframework中选择合适的framework）。

#### Carthage作为静态库

Carthage默认将InterfaceKit构建为一个动态库。

如果您希望使用Carthage将InterfaceKit构建为静态库，您可以在使用Carthage构建之前使用下面的脚本手动修改框架类型：

```bash
carthage update InterfaceKit --platform iOS --no-build
sed -i -e 's/MACH_O_TYPE = mh_dylib/MACH_O_TYPE = staticlib/g' Carthage/Checkouts/InterfaceKit/InterfaceKit/InterfaceKit.xcodeproj/project.pbxproj
carthage build InterfaceKit --platform iOS
```

### Swift Package Manager

[Swift Package Manager](https://swift.org/package-manager/)是一种用于自动分发Swift代码的工具，并集成到`Swift`编译器中。它处于早期开发阶段，但InterfaceKit仍支持在其支持的平台上使用它。

1. 设置Swift包后，将InterfaceKit添加为依赖项就像将其添加到`package.Swift`的`dependencies`的值一样简单。然后运行`swift build`。

```swift
dependencies: [
    .package(url: "https://github.com/adong666666/InterfaceKit.git", .upToNextMajor(from: "5.4.0"))
]
```

或者

1. 在Xcode中，选择File > Swift Packages > Add Package Dependency。
2. 安装提示操作使用这个URL(“https://github.com/adong666666/InterfaceKit.git”)来集成此框架.
<div align="center"><img src="https://github.com/adong666666/InterfaceKit/raw/master/Pictures/SwiftPackageManager.png" alt="Swift Package Manager配置" /></div>

### 手动设置

如果您不想使用上述任何依赖关系管理器，可以手动将InterfaceKit集成到项目中。

#### 嵌入式框架

- 打开Terminal，`cd`到顶级项目目录，如果您的项目未初始化为git存储库，则运行以下命令：

```bash
$ git init
```

- 通过以下命令来将InterfaceKit添加为git[子模块](https://git-scm.com/docs/git-submodule)：

```bash
$ git submodule add https://github.com/adong666666/InterfaceKit.git
```

- 打开`InterfaceKit`文件夹，将`InterfaceKit.xcodeproj`拖到应用程序Xcode项目的项目导航器中。

    > 它应该嵌套在应用程序的蓝色项目图标下面。它是否高于或低于所有其他Xcode组并不重要。

<div align="center"><img src="https://github.com/adong666666/InterfaceKit/raw/master/Pictures/drag_framework.png" alt="拖放文件" /></div>

- 在项目导航器中选择`InterfaceKit.xcodeproj`，并验证部署目标是否与应用程序目标匹配。
- 接下来，在项目导航器（蓝色项目图标）中选择您的应用程序项目，以导航到目标配置窗口，并在侧边栏的“Targets”标题下选择应用程序目标。
- 在该窗口顶部的选项卡栏中，打开`“General”`面板。
- 单击`“Frameworks,Libraries,and Embedded Content”`部分下的`+`按钮。
- 您将看到`Workspace`下的`InterfaceKit`文件夹，`InterfaceKit`文件夹下有`InterfaceKit.framework`和`InterfaceKitTests.xctest`

    > 点击`InterfaceKit.framework`，然后点击`Add`

<div align="center"><img src="https://github.com/adong666666/InterfaceKit/raw/master/Pictures/add_framework.png" alt="添加框架" /></div>

- 就这样！

    > `InterfaceKit.framework`在复制文件构建阶段自动添加为目标依赖项、链接框架和嵌入式框架，这是在模拟器和设备上构建所需的全部内容。

### 解压，拖拽

1. 解压此存储库提供的`InterfaceKit.xcframework.zip`文件。
<div align="center"><img src="https://github.com/adong666666/InterfaceKit/raw/master/Pictures/unzip.png" alt="解压" /></div>

2. 在应用程序目标的`“General”`设置选项卡上，在`“Frameworks,Libraries,and Embedded Content”`部分，拖放解压缩后的文件`InterfaceKit.xcframework`（或从InterfaceKit.xcframework中选择合适的framework）。
- 如果您使用`xcfamework`，只需拖放`InterfaceKit.xcframework`。`InterfaceKit.xcframework`支持所有四种平台（`iOS、macOS、tvOS、watchOS`）。
<div align="center"><img src="https://github.com/adong666666/InterfaceKit/raw/master/Pictures/use_xcframeworks.png" alt="使用xcframework" /></div>

- 如果您使用`framework`，请根据文件夹名称和项目平台从InterfaceKit.xcframework中选择合适的框架。
<div align="center"><img src="https://github.com/adong666666/InterfaceKit/raw/master/Pictures/use_frameworks.png" alt="使用framework" /></div>

## 常见问题

### 为什么使用 InterfaceKit?

`一行代码`实现在`SwiftUI`界面使用`UIKit、AppKit和WatchKit`的接口！ InterfaceKit 同时支持全部四个平台(`iOS, macOS, tvOS, watchOS`)。InterfaceKit`持续`更新。

## 信用

InterfaceKit 由[张赛东](https://zsd.name)持续更新。 您可以关注他 [@Github](https://github.com/adong666666) 以及时了解工程的更新与发布。

### 安全披露

如果您认为InterfaceKit存在安全漏洞，请您尽快通过邮箱告知：3440217568@qq.com。

## 捐献

不需要捐献，但仍表示感谢。

## 贡献

您喜欢InterfaceKit吗？真好！我们真的需要您的帮助！

开源不仅仅是编写代码。您可以帮我们做以下的任何一件事：

- 查找（和报告）漏洞。
- 新功能建议。
- 回答问题。
- 文件改进。
- 查看拉取请求。
- 帮助管理问题优先级。
- 修复错误/新功能。

如果您觉得这些听起来很酷，发送一个请求！第一次贡献之后，我们会将把您设置为此存储库的成员，以便您可以合并请求，您可以[在我们的投稿人指南中](https://github.com/adong666666/InterfaceKit/blob/master/CONTRIBUTING.zh-Hans.md)阅读更多的细节。

InterfaceKit的社区拥有巨大的正能量，维护人员致力于保持事物的精彩。就像 [在CocoaPods社区](https://github.com/CocoaPods/CocoaPods/wiki/Communication-&-Design-Rules), 总是表现出积极的意图；即使一个评论听起来很刻薄，也要让这个人从怀疑中受益。

请注意，这个项目伴随着贡献者的行为准则而发布。参与此项目即表示您同意遵守[其条款](https://github.com/adong666666/InterfaceKit/blob/master/Code%20of%20Conduct.zh-Hans.md).

### 添加新源文件

如果从InterfaceKIt添加或删除源文件，则需要对此存储库根目录下的`InterfaceKIt.xcworkspace`项目进行相应的更改。这个项目用于迦太基。别担心，如果您忘记了，在提交拉取请求时会自动收到警告。

### 帮助我们改进InterfaceKit的文档

无论您是核心成员还是第一次尝试它的用户，您都可以通过改进文档对InterfaceKit做出有价值的贡献。帮助我们：

- 向我们发送有关您认为混淆或遗漏的内容的反馈
- 建议用更好的措辞或方式来解释某些话题
- 通过GitHub向我们发送拉取请求
- 改进 [英文文档](https://github.com/adong666666/InterfaceKit/blob/master/README.md)

### 上面的话太啰嗦了？ 那么直接看下面吧。

* 分叉此存储库！
* 创建您的分支：`git checkout -b my-new-feature`
* 提交您的更改：`git commit -am 'Add some feature'`
* 推送至该分支：`git push origin my-new-feature`
* 发起拉取请求
* 其他： 
详见[贡献](https://github.com/adong666666/InterfaceKit/blob/master/CONTRIBUTING.zh-Hans.md)。

## 许可

InterfaceKit是在MIT许可下发布的，详见[许可](https://github.com/adong666666/InterfaceKit/blob/master/LICENSE.zh-Hans.md)。

## 版本历史

详见[版本历史](https://github.com/adong666666/InterfaceKit/blob/master/CHANGELOG.zh-Hans.md)。
