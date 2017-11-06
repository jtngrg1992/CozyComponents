//
//  AppDelegate.swift
//  CozyComponents
//
//  Created by Jatin Garg on 05/11/17.
//  Copyright © 2017 Jatin Garg. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        let viewController = ViewController()
        window?.rootViewController = viewController
        
        NMGFlashMessage.shared.configureDialog(titleFont: UIFont(name: "Avenir-Heavy", size: 20)!,
                                               messageFont: UIFont(name: "Avenir", size: 15)!,
                                               titleFontColor: UIColor.init(red: 80.0/255.0, green: 85.0/255.0, blue: 88.0/255.0, alpha: 1),
                                               messageFontColor: UIColor.init(red: 80.0/255.0, green: 85.0/255.0, blue: 88.0/255.0, alpha: 1),
                                               errorImage: #imageLiteral(resourceName: "error"),
                                               successImage: #imageLiteral(resourceName: "snap"),
                                               neutralImage: #imageLiteral(resourceName: "success"),
                                               headerColor: .white,
                                               backgroundColor: UIColor.init(red: 1, green: 1, blue: 1, alpha: 1),
                                               actionBackgroundColor: UIColor.init(red: 246.0/255.0, green: 86.0/255.0, blue: 86.0/255.0, alpha: 1),
                                               actionFont: UIFont(name: "Avenir-Heavy", size: 17)!,
                                               actionColor: .white)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

