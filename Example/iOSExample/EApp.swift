import SwiftUI
import MapKit

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
