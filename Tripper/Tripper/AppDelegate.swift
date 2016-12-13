//
//  AppDelegate.swift
//  Tripper
//
//  Created by Pinghsien Lin on 11/22/16.
//  Copyright © 2016 vudu. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GMSServices.provideAPIKey("AIzaSyCx-yugcaGPCHgdkTPT3Kl5_kFZ80CFyyA")
        GMSPlacesClient.provideAPIKey("AIzaSyCx-yugcaGPCHgdkTPT3Kl5_kFZ80CFyyA")
        application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil))
     //   Thread.sleep(forTimeInterval: 2.0)
        
        // backgruond fetch calendar events
        application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        
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

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        // To go MapViewController, filtered by city
        if let whereTo: String = notification.userInfo?["action"] as? String {
            
            let nav: UINavigationController = self.window?.rootViewController as! UINavigationController
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"MapViewController") as! MapViewController
            
            if whereTo == "SF" {
                print("should go to map SF")
                vc.setData(city: .sfo)
                nav.pushViewController(vc, animated: true)
            } else if whereTo == "JP" {
                print("should go to map JP")
                vc.setData(city: .nrt)
                nav.pushViewController(vc, animated: true)
            }
        }
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"HomeViewController") as! HomeViewController
        vc.loadCalendars()
        completionHandler(UIBackgroundFetchResult.newData)
    }
}

