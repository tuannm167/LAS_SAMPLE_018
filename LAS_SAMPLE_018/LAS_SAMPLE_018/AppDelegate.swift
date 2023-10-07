//
//  AppDelegate.swift
//  LAS_SAMPLE_018
//
//  Created by Minh Tuan on 16/07/2023.
//

import UIKit
import AVFAudio
import MediaPlayer

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    lazy var mainPlayer: PlayMusicVC = {
        let player = PlayMusicVC()
        player.modalPresentationStyle = .fullScreen
        return player
    }()
    
    static let shared: AppDelegate = {
        return UIApplication.shared.delegate as! AppDelegate
    }()
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        RealmService.shared.configuration()

        if #available(iOS 13.0, *) {
            // SceneDelegate.swift will config
        }
        else {
            let root: TabbarVC = UIStoryboard.createController()
            let navi = UINavigationController(rootViewController: root)
            navi.setNavigationBarHidden(true, animated: false)
            
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.rootViewController = navi
            window?.makeKeyAndVisible()
        }
        CPlayer.shared.initSession()
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
}

