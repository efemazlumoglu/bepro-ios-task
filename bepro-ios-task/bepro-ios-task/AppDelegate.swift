//
//  AppDelegate.swift
//  bepro-ios-task
//
//  Created by Efe Mazlumoğlu on 18.03.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var supportedOrientation: UIInterfaceOrientationMask = [.portrait, .landscape]
    // i use window since we are not usign storyboards however the launchscreen storyboard is still appearing i did not remove that.
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = .white
        window?.rootViewController = ViewController() // add viewcontroller as root view controller since we do not have another view controller
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask { // support orientation portrait and landscape
        return supportedOrientation
    }
    
     
    
}

