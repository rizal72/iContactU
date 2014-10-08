//
//  AppDelegate.swift
//  Test
//
//  Created by Riccardo Sallusti on 06/09/14.
//  Copyright (c) 2014 Riccardo Sallusti. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        UINavigationBar.appearance().barTintColor = UIColor(hexString: "ef3c39")
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        if BreezeStore.iCloudAvailable() {
            BreezeStore.setupiCloudStoreWithContentNameKey("iCloud\(BreezeStore.appName)", localStoreName: "\(BreezeStore.appName)", transactionLogs: "iCloud_transactions_logs")
            println("iCloud store created.")
        } else {
            BreezeStore.setupStoreWithName("\(BreezeStore.appName)", storeType: NSSQLiteStoreType, options: [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true])
            println("local store created.")
        }
        
        var version:NSString = UIDevice.currentDevice().systemVersion as NSString;
        if  version.doubleValue >= 8 {
            // ios 8 code
            
            let notificationTypes:UIUserNotificationType = UIUserNotificationType.Alert | UIUserNotificationType.Badge | UIUserNotificationType.Sound
            let notificationSettings:UIUserNotificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: nil)
            
            UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        }
        else{
            // FOR IOS7 IT IS NOT NECESSARY
            /*
            UIApplication.sharedApplication().registerForRemoteNotificationTypes(UIRemoteNotificationType.Badge | UIRemoteNotificationType.Sound | UIRemoteNotificationType.Alert)*/
        }
        
        //UIApplication.sharedApplication().cancelAllLocalNotifications()
        let notificationsCount = UIApplication.sharedApplication().scheduledLocalNotifications.count
        println("ALL SCHEDULED NOTIFICATIONS: \(notificationsCount)")
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        //self.saveContext()
    }
    
}

