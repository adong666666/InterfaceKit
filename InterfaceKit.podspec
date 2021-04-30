Pod::Spec.new do |s|
  s.name             = "InterfaceKit"
  s.version          = "5.4.0"
  s.summary          = "InterfaceKit helps you use interface of UIKit, AppKit and WatchKit in SwiftUI interface easily"
  s.description      = <<-DESC
This is supported by [Saidong Zhang](https://zsd.name)

its intention is to help people use interface of UIKit, AppKit and WatchKit in SwiftUI interface easily.
/// You create custom views by declaring types that conform to the ``View``
/// protocol. Implement the required ``View/body-swift.property`` computed
/// property to provide the content for your custom view. Then you can present your UIKit
/// ViewController View by using `InterfaceView(MyView())` , as follows.
```
///
///     struct MyView: View {
///         var body: some View {
///             InterfaceView(MyView())
///         }
///     }
///
```
/// The ``View`` protocol provides a large set of modifiers, defined as protocol
/// methods with default implementations, that you use to position and configure
/// views in the layout of your app. Modifiers typically work by wrapping the
/// view instance on which you call them in another view with the specified
/// characteristics. For example, adding the ``View/opacity(_:)`` modifier to a
/// interface view returns a new view with some amount of transparency:
```
///
///     InterfaceView(MyView())
///         .opacity(0.5) // Display partially transparent interface view.
///
```
/// It is recommended to use `ZStack` with `InterfaceView` , as follows.
```
///
///     ZStack {
///         InterfaceView(MyView())
///         MySwiftUIView()
///     }
///
```
                        DESC
  s.homepage         = "https://github.com/adong666666/InterfaceKit"
  s.license          = 'MIT'
  s.author           = { "Saidong Zhang" => "3440217568@qq.com" }
  s.source           = { :git => "https://github.com/adong666666/InterfaceKit.git", :tag => s.version.to_s }

  s.requires_arc          = true

  s.ios.deployment_target = '13.0'
  s.osx.deployment_target = '10.15'
  s.watchos.deployment_target = '6.0'
  s.tvos.deployment_target = '13.0'

  s.source_files          = 'Sources/InterfaceKit/*.swift'
  s.exclude_files         = ''

  s.frameworks = 'SwiftUI'
  s.swift_version = '5.4'
  # UIKit
  s.subspec 'UIKit' do |sp|
    sp.source_files  = 'Sources/InterfaceKit/UIInterface.swift'
  end
  # AppKit
  s.subspec 'AppKit' do |sp|
    sp.source_files  = 'Sources/InterfaceKit/NSInterface.swift'
  end
  # WatchKit
  s.subspec 'WatchKit' do |sp|
    sp.source_files  = 'Sources/InterfaceKit/WKInterface.swift'
  end
end
