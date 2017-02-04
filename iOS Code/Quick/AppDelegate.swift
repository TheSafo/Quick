//
//  AppDelegate.swift
//  Quick
//
//  Created by Jake Saferstein on 2/4/17.
//  Copyright © 2017 Jake Saferstein. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let rootVC = HomeViewController()
        let navVC = UINavigationController(rootViewController: rootVC)
        
        let profBtn = UIButton(type: .custom)
        profBtn.setImage(UIImage(named: "user")?.withRenderingMode(.alwaysTemplate), for: .normal)
        profBtn.addTarget(rootVC, action: #selector(rootVC.profButtonPressed), for: .touchUpInside)
        profBtn.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        profBtn.imageEdgeInsets = UIEdgeInsetsMake(2.5, 2.5, 2.5, 2.5)
        rootVC.navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: profBtn)]
        
        let newOrderBtn = UIButton(type: .custom)
        newOrderBtn.setImage(UIImage(named: "add")?.withRenderingMode(.alwaysTemplate), for: .normal)
        newOrderBtn.addTarget(rootVC, action: #selector(rootVC.orderButtonPressed), for: .touchUpInside)
        newOrderBtn.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        newOrderBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        rootVC.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: newOrderBtn)]
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
        
        let locationManager = CLLocationManager()
        // Ask for Authorisation from the User.
        locationManager.requestAlwaysAuthorization()
        
        CurrentLocation.sharedInstance.startLocationManager()
        
        ServerAPI.sharedInstance.testPutRequestToMarko()
        
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

