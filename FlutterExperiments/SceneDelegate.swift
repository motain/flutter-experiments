//
//  SceneDelegate.swift
//  FlutterExperiments
//
//  Created by Bruno Pastre on 02.12.24.
//

import UIKit
import Flutter
import FlutterPluginRegistrant

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    let engines = FlutterEngineGroup(name: "multiple-flutters", project: nil)
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        UIViewController.swizzle()
        FlutterEngine.swizzle()
        FlutterMethodChannel.swizzle()
        FlutterBasicMessageChannel.swizzle()

        let window = UIWindow(windowScene: scene)
        let tabBar = UITabBarController()
        window.rootViewController = tabBar
        
        tabBar.viewControllers = [
            SingleFlutterViewController(withRoute: "/home", withEngineGroup: engines),
            SingleFlutterViewController(withRoute: "/profile", withEngineGroup: engines),
        ]
        
        window.makeKeyAndVisible()
        self.window = window
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}


final class DummyViewController: UIViewController {
    private let string: String

    init(_ string: String) {
        self.string = string
        super.init(nibName: nil, bundle: nil)
        
        tabBarItem = UITabBarItem(title: string, image: nil, tag: string.hashValue)
    }
    
    override func viewDidLoad() {
        let label = UILabel()
        
        label.text = string
        view.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SingleFlutterViewController: FlutterViewController {
  private var channel: FlutterMethodChannel?

    init(withRoute initialRoute: String, withEngineGroup engineGroup: FlutterEngineGroup) {
    let newEngine = engineGroup.makeEngine(withEntrypoint: nil, libraryURI: nil, initialRoute: initialRoute)
    GeneratedPluginRegistrant.register(with: newEngine)
    super.init(engine: newEngine, nibName: nil, bundle: nil)
    
    tabBarItem = UITabBarItem(title: initialRoute, image: nil, tag: initialRoute.hashValue)
  }

  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func onCountUpdate(newCount: Int64) {
    if let channel = channel {
      channel.invokeMethod("setCount", arguments: newCount)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }
}

class FLPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let factory = FLNativeViewFactory(messenger: registrar.messenger())
        registrar.register(factory, withId: "<platform-view-type>")
    }
}


class FLNativeViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return FLNativeView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger)
    }

    /// Implementing this method is only necessary when the `arguments` in `createWithFrame` is not `nil`.
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
          return FlutterStandardMessageCodec.sharedInstance()
    }
}

class FLNativeView: NSObject, FlutterPlatformView {
    private var _view: UIView

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?
    ) {
        _view = UIView()
        super.init()
        // iOS views can be created here
        createNativeView(view: _view)
    }

    func view() -> UIView {
        return _view
    }

    func createNativeView(view _view: UIView){
        _view.backgroundColor = UIColor.blue
        let nativeLabel = UILabel()
        nativeLabel.text = "Native text from iOS"
        nativeLabel.textColor = UIColor.white
        nativeLabel.textAlignment = .center
        nativeLabel.frame = CGRect(x: 0, y: 0, width: 180, height: 48.0)
        _view.addSubview(nativeLabel)
    }
}


extension UIViewController {
    @objc func trackedViewDidLoad() {
        print("Tracked this screen:----- \(type(of: self))")
        trackedViewDidLoad()
    }
    static func swizzle() {
        let originalSelector = #selector(Self.viewDidLoad)
        let swizzledSelector = #selector(Self.trackedViewDidLoad)
        let originalMethod = class_getInstanceMethod(self, originalSelector)
        let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
        method_exchangeImplementations(originalMethod!, swizzledMethod!)
    }
}

extension FlutterEngine {
    @objc func tracked_destroyContext() {
        print("destroyContext | Tracked: \(type(of: self))")
        tracked_destroyContext()
    }
    
    static func swizzle() {
        trackDestroyContext(originalSelector: #selector(destroyContext),
                            swizzledSelector: #selector(FlutterEngine.tracked_destroyContext))

        trackDestroyContext(originalSelector: #selector(FlutterEngine.destroyContext),
                            swizzledSelector: #selector(FlutterEngine.tracked_destroyContext))
    }

    static func trackDestroyContext(originalSelector: Selector, swizzledSelector: Selector) {
        let originalMethod = class_getInstanceMethod(FlutterEngine.self, originalSelector)
        let swizzledMethod = class_getInstanceMethod(FlutterEngine.self, swizzledSelector)
        method_exchangeImplementations(originalMethod!, swizzledMethod!)
    }

}

extension FlutterMethodChannel {
    @objc func tracked_invokerMethod(_ x: String, _ args: Any?) {
        print("invokerMethod | Tracked: \(type(of: self))", x, args)
        tracked_invokerMethod(x, args)
    }

    @objc func tracked_invokerMethodWithResult(_ x: String, _ args: Any?,_ result: FlutterResult?) {
        print("invokerMethodResult | Tracked: \(type(of: self))", x, args, result)
        tracked_invokerMethodWithResult(x, args, result)
    }

    static func swizzle() {
        trackDestroyContext(originalSelector: #selector(invokeMethod(_:arguments:)),
                            swizzledSelector: #selector(tracked_invokerMethod))

        trackDestroyContext(originalSelector: #selector(invokeMethod(_:arguments:result:)),
                            swizzledSelector: #selector(tracked_invokerMethodWithResult))

        trackDestroyContext(originalSelector: #selector(invokeMethod(_:arguments:result:)),
                            swizzledSelector: #selector(tracked_invokerMethodWithResult))
    }

    static func trackDestroyContext(originalSelector: Selector, swizzledSelector: Selector) {
        let originalMethod = class_getInstanceMethod(Self.self, originalSelector)
        let swizzledMethod = class_getInstanceMethod(Self.self, swizzledSelector)
        method_exchangeImplementations(originalMethod!, swizzledMethod!)
    }

}

extension FlutterBasicMessageChannel {
    @objc func tracked_sendNoReply(_ message: Any?) {
        print("send message | Tracked: \(type(of: self))", message)
        tracked_sendNoReply(message)
    }
    
    @objc func tracked_send(_ message: Any?, _ reply: FlutterReply?) {
        print("send message with reply | Tracked: \(type(of: self))", message, reply)
        tracked_send(message, reply)
    }

    static func swizzle() {
        trackDestroyContext(originalSelector: #selector(sendMessage(_:)),
                            swizzledSelector: #selector(tracked_sendNoReply))

        trackDestroyContext(originalSelector: #selector(sendMessage(_:reply:)),
                            swizzledSelector: #selector(tracked_send))
    }
    
    static func trackDestroyContext(originalSelector: Selector, swizzledSelector: Selector) {
        let originalMethod = class_getInstanceMethod(Self.self, originalSelector)
        let swizzledMethod = class_getInstanceMethod(Self.self, swizzledSelector)
        method_exchangeImplementations(originalMethod!, swizzledMethod!)
    }
}
