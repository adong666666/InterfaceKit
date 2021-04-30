//
// The MIT License (MIT)
//
// Copyright (c) 2021 Saidong Zhang (https://zsd.name/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

//swiftlint:disable all

#if os(macOS)

import SwiftUI

// MARK: - NSInterfaceView

/// The `NSInterfaceView` struct helps you to use AppKit NSView or its
/// derived class in project using SwiftUI.`NSInterfaceView` is a type that represents
/// part of your app's user interface using AppKit and provides modifiers that you use to configure views.
///
/// You create custom views by declaring types that conform to the ``View``
/// protocol. Implement the required ``View/body-swift.property`` computed
/// property to provide the content for your custom view. Then you can present your AppKitt
/// View by using `NSInterfaceView(MyView())` , as follows.
///
///     struct MyView: View {
///         var body: some View {
///             NSInterfaceView(MyView())
///         }
///     }
///
/// The ``View`` protocol provides a large set of modifiers, defined as protocol
/// methods with default implementations, that you use to position and configure
/// views in the layout of your app. Modifiers typically work by wrapping the
/// view instance on which you call them in another view with the specified
/// characteristics. For example, adding the ``View/opacity(_:)`` modifier to a
/// interface view returns a new view with some amount of transparency:
///
///     NSInterfaceView(MyView())
///         .opacity(0.5) // Display partially transparent interface view.
///
/// It is recommended to use `ZStack` with `NSInterfaceView` , as follows.
///
///     ZStack {
///         NSInterfaceView(MyView())
///         MySwiftUIView()
///     }
///
/// A wrapper that you use to integrate an AppKit view into your SwiftUI view
/// hierarchy.
///
/// Use an `NSInterfaceView` instance to create and manage an
/// <doc://com.apple.documentation/documentation/AppKit/NSView> object in your SwiftUI
/// interface. Adopt this protocol in one of your app's custom instances, and
/// use its methods to create, update, and tear down your view. The creation and
/// update processes parallel the behavior of SwiftUI views, and you use them to
/// configure your view with your app's current state information. Use the
/// teardown process to remove your view cleanly from your SwiftUI. For example,
/// you might use the teardown process to notify other objects that the view is
/// disappearing.
///
/// To add your view into your SwiftUI interface, create your
/// ``NSInterfaceView`` instance and add it to your SwiftUI interface. The
/// system calls the methods of your representable instance at appropriate times
/// to create and update the view. The following example shows the inclusion of
/// a `NSInterfaceView` in the view hierarchy.
///
///     struct ContentView: View {
///        var body: some View {
///           ZStack {
///              Text("Global Sales")
///              NSInterfaceView(MyNSView())
///           }
///        }
///     }
///
/// The system doesn't automatically communicate changes occurring within your
/// view controller to other parts of your SwiftUI interface. When you want your
/// view controller to coordinate with other SwiftUI views, you must provide a
/// ``NSViewControllerRepresentable/Coordinator`` object to facilitate those
/// interactions. For example, you use a coordinator to forward target-action
/// and delegate messages from your view controller to any SwiftUI views.
public struct NSInterfaceView: NSViewRepresentable {
    
    /// The type of view to present.
    public var nsInterfaceView: NSView
    
    /// A `closure` helps you finish some special things like work to be done in AppKit interface.
    public var callback: (() -> Void)?
    
    public init(_ nsInterfaceView: NSView = NSView(), _ callback: (() -> Void)? = nil) {
        self.nsInterfaceView = nsInterfaceView
        self.callback = callback
        
        /// Execute the closure, if it exists.
        (callback ?? {})()
    }
    
    /// Creates the view object and configures its initial state.
    ///
    /// You must implement this method and use it to create your view object.
    /// Configure the view using your app's current data and contents of the
    /// `context` parameter. The system calls this method only once, when it
    /// creates your view for the first time. For all subsequent updates, the
    /// system calls the ``NSViewRepresentable/updateNSView(_:context:)``
    /// method.
    ///
    /// - Parameter context: A context structure containing information about
    ///   the current state of the system.
    ///
    /// - Returns: Your AppKit view configured with the provided information.
    public func makeNSView(context: Context) -> NSView { nsInterfaceView }
    
    /// Updates the state of the specified view with new information from
    /// SwiftUI.
    ///
    /// When the state of your app changes, SwiftUI updates the portions of your
    /// interface affected by those changes. SwiftUI calls this method for any
    /// changes affecting the corresponding AppKit view. Use this method to
    /// update the configuration of your view to match the new state information
    /// provided in the `context` parameter.
    ///
    /// - Parameters:
    ///   - nsView: Your custom view object.
    ///   - context: A context structure containing information about the current
    ///     state of the system.
    public func updateNSView(_ nsView: NSView, context: Context) {}
    
    /// A return type for function `makeCoordinator`.
    open class Coordinator: NSObject {}
    
    /// Creates the custom instance that you use to communicate changes from
    /// your view to other parts of your SwiftUI interface.
    ///
    /// Implement this method if changes to your view might affect other parts
    /// of your app. In your implementation, create a custom Swift instance that
    /// can communicate with other parts of your interface. For example, you
    /// might provide an instance that binds its variables to SwiftUI
    /// properties, causing the two to remain synchronized. If your view doesn't
    /// interact with other parts of your app, you don't have to provide a
    /// coordinator.
    ///
    /// SwiftUI calls this method before calling the
    /// ``NSViewRepresentable/makeNSView(context:)`` method. The system provides
    /// your coordinator instance either directly or as part of a context
    /// structure when calling the other methods of your representable instance.
    public func makeCoordinator() -> Coordinator { Coordinator() }
}
// MARK: - NSInterfaceViewController

/// The `NSInterfaceViewController` struct helps you to use AppKit NSViewController or its
/// derived class in project using SwiftUI. `NSInterfaceViewController` is a type that
/// represents part of your app's user interface using AppKit and provides
/// modifiers that you use to configure views.
///
/// You create custom views by declaring types that conform to the ``View``
/// protocol. Implement the required ``View/body-swift.property`` computed
/// property to provide the content for your custom view. Then you can present your AppKit
/// ViewController View by using `NSInterfaceViewController(MyViewController())` , as follows.
///
///     struct MyView: View {
///         var body: some View {
///             NSInterfaceViewController(MyViewController())
///         }
///     }
///
/// The ``View`` protocol provides a large set of modifiers, defined as protocol
/// methods with default implementations, that you use to position and configure
/// views in the layout of your app. Modifiers typically work by wrapping the
/// view instance on which you call them in another view with the specified
/// characteristics. For example, adding the ``View/opacity(_:)`` modifier to a
/// interface view returns a new view with some amount of transparency:
///
///     NSInterfaceViewController(MyViewController())
///         .opacity(0.5) // Display partially transparent interface view.
///
/// It is recommended to use `ZStack` with `NSInterfaceViewController` , as follows.
///
///     ZStack {
///         NSInterfaceViewController(MyViewController())
///         MySwiftUIView()
///     }
///
/// A wrapper that you use to integrate an AppKit view controller into your
/// SwiftUI interface.
///
/// Use an ``NSViewControllerRepresentable`` instance to create and manage an
/// <doc://com.apple.documentation/documentation/AppKit/NSViewController> object in your
/// SwiftUI interface. Adopt this protocol in one of your app's custom
/// instances, and use its methods to create, update, and tear down your view
/// controller. The creation and update processes parallel the behavior of
/// SwiftUI views, and you use them to configure your view controller with your
/// app's current state information. Use the teardown process to remove your
/// view controller cleanly from your SwiftUI. For example, you might use the
/// teardown process to notify other objects that the view controller is
/// disappearing.
///
/// To add your view controller into your SwiftUI interface, create your
/// `NSViewControllerRepresentable` instance and add it to your SwiftUI
/// interface. The system calls the methods of your custom instance at
/// appropriate times.
///
/// The system doesn't automatically communicate changes occurring within your
/// view controller to other parts of your SwiftUI interface. When you want your
/// view controller to coordinate with other SwiftUI views, you must provide a
/// ``NSViewControllerRepresentable/Coordinator`` instance to facilitate those
/// interactions. For example, you use a coordinator to forward target-action
/// and delegate messages from your view controller to any SwiftUI views.
public struct NSInterfaceViewController: NSViewControllerRepresentable {
    
    /// The type of view controller to present.
    public var nsInterfaceViewController: NSViewController
    
    /// A `closure` helps you finish some special things like work to be done in AppKit interface.
    public var callback: (() -> Void)?
    
    // MARK: Initialization
    
    /// Creates an `NSInterfaceViewController` instance from the specified parameters.
    ///
    /// - Parameters:
    ///   - nsInterfaceViewController: The`NSViewController`type. The type of view controller you want to present in project.
    ///   - callback: The`(() -> Void)?`type which helps you call some method.
    public init(_ nsInterfaceViewController: NSViewController = NSViewController(), _ callback: (() -> Void)? = nil) {
        self.nsInterfaceViewController = nsInterfaceViewController
        self.callback = callback
        
        /// Execute the closure, if it exists.
        (callback ?? {})()
    }
    
    /// Creates the view controller object and configures its initial state.
    ///
    /// You must implement this method and use it to create your view controller
    /// object. Create the view controller using your app's current data and
    /// contents of the `context` parameter. The system calls this method only
    /// once, when it creates your view controller for the first time. For all
    /// subsequent updates, the system calls the
    /// ``NSViewControllerRepresentable/updateNSViewController(_:context:)``
    /// method.
    ///
    /// - Parameter context: A context structure containing information about
    ///   the current state of the system.
    ///
    /// - Returns: Your AppKit view controller configured with the provided
    ///   information.
    public func makeNSViewController(context: Context) -> NSViewController { nsInterfaceViewController }
    
    /// Updates the state of the specified view controller with new information
    /// from SwiftUI.
    ///
    /// When the state of your app changes, SwiftUI updates the portions of your
    /// interface affected by those changes. SwiftUI calls this method for any
    /// changes affecting the corresponding AppKit view controller. Use this
    /// method to update the configuration of your view controller to match the
    /// new state information provided in the `context` parameter.
    ///
    /// - Parameters:
    ///   - nsViewController: Your custom view controller object.
    ///   - context: A context structure containing information about the current
    ///     state of the system.
    public func updateNSViewController(_ nsViewController: NSViewController, context: Context) {}
    
    /// A return type for function `makeCoordinator`.
    open class Coordinator: NSObject {}
    
    /// Creates the custom object that you use to communicate changes from your
    /// view controller to other parts of your SwiftUI interface.
    ///
    /// Implement this method if changes to your view controller might affect
    /// other parts of your app. In your implementation, create a custom Swift
    /// instance that can communicate with other parts of your interface. For
    /// example, you might provide an instance that binds its variables to
    /// SwiftUI properties, causing the two to remain synchronized. If your view
    /// controller doesn't interact with other parts of your app, providing a
    /// coordinator is unnecessary.
    ///
    /// SwiftUI calls this method before calling the
    /// ``NSViewControllerRepresentable/makeNSViewController(context:)`` method.
    /// The system provides your coordinator instance either directly or as part
    /// of a context structure when calling the other methods of your
    /// representable instance.
    public func makeCoordinator() -> Coordinator { Coordinator() }
}

#endif
