//
//  AppDelegate.swift
//  MusicFinder
//
//  Created by TRAING Serey on 25/03/2017.
//  Copyright © 2017 TRAING Serey. All rights reserved.
//

import UIKit
import SWRevealViewController

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SWRevealViewControllerDelegate {

    var window: UIWindow?
    var navigationController: UINavigationController?
    var viewController: SWRevealViewController?

    var auth = SPTAuth()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        auth.redirectURL = URL(string: "musicfinder-auth://callback")
        auth.sessionUserDefaultsKey = "current session"
        
        let homeVC = HomeVC(nibName: "HomeVC", bundle: nil)
        let leftMenuVC = LeftMenuVC(nibName: "LeftMenuVC", bundle: nil)
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let homeNavigationController = UINavigationController(rootViewController: homeVC)
        let leftMenuNavigationController = UINavigationController(rootViewController: leftMenuVC)
        let revealVC = SWRevealViewController(rearViewController: leftMenuNavigationController, frontViewController: homeNavigationController)
       
        revealVC?.delegate = self;
        self.viewController = revealVC;
        self.window!.rootViewController = self.viewController
        self.window!.makeKeyAndVisible()
        return true
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if auth.canHandle(auth.redirectURL) {
            auth.handleAuthCallback(withTriggeredAuthURL: url, callback: {
            (error, session)  in
                if error != nil {
                    print("error")
                }
                
                let userDefault = UserDefaults.standard
                let sessionData = NSKeyedArchiver.archivedData(withRootObject: session)
                userDefault.set(sessionData, forKey: "SpotifySession")
                userDefault.synchronize()
                NotificationCenter.default.post(name: Notification.Name(rawValue: "loginSuccessfull"), object: nil)
            })
            return true
        }
        return false
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
