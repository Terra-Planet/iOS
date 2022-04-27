//
//  AppDelegate.swift
//  Terra Planet
//
//  Created by f0go on 22/03/2022.
//

import UIKit
import NodeMobile

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let httpUsername = UUID().uuidString
    let httpPassword = UUID().uuidString
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Network.shared.setCredentials(httpUsername, httpPassword)
        NodeRunner.runNode(httpUsername, withPassword: httpPassword)
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        NodeRunner.stopHttpServer()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        NodeRunner.startHttpServer()
        KeyChainManager.shared.loadWallet { status in
            if !status {
                DispatchQueue.main.sync {
                    let vc = UIStoryboard(name: "BlockScreen", bundle: nil).instantiateViewController(withIdentifier: "BlockScreenVC")
                    UIApplication.topViewController()!.present(vc, animated: false)
                }
            }
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {

    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

