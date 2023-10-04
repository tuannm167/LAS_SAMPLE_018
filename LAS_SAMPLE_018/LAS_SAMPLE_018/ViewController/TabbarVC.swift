//
//  TabbarVC.swift
//  LAS_SAMPLE_018
//
//  Created by Minh Tuan on 16/07/2023.
//

import UIKit

class TabbarVC: UITabBarController {
    
    // MARK: - properties
    private var miniPlayerShowing: Bool = false
    lazy var miniPlayer: MiniPlayer = {
        let player = MiniPlayer.loadFromNib()
        return player
    }()
    
    // MARK: - life-cycle view controller
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let homeVC: HomeVC = HomeVC()
        homeVC.tabBarItem = UITabBarItem(title: "Home",
                                         image: UIImage(named: "ic_tab_home_inactive")?.withRenderingMode(.alwaysOriginal),
                                         selectedImage: UIImage(named: "ic_tab_home_active")?.withRenderingMode(.alwaysOriginal))
        
        let wallpaperVC: WallpaperVC = WallpaperVC()
        wallpaperVC.tabBarItem = UITabBarItem(title: "Wallpaper",
                                              image: UIImage(named: "ic_tab_wallpaper_inact")?.withRenderingMode(.alwaysOriginal),
                                              selectedImage: UIImage(named: "ic_tab_wallpaper_active")?.withRenderingMode(.alwaysOriginal))
        
        let makeVideoVC: MakeVideoVC = MakeVideoVC()
        makeVideoVC.tabBarItem = UITabBarItem(title: "Make Video",
                                              image: UIImage(named: "ic_tab_makevideo_inact")?.withRenderingMode(.alwaysOriginal),
                                              selectedImage: UIImage(named: "ic_tab_makevideo_active")?.withRenderingMode(.alwaysOriginal))
        
        viewControllers = [homeVC, wallpaperVC, makeVideoVC]
        
        styleTabbar()
        
        miniPlayerShowing = false
        miniPlayer.onOpenMainPlayer = { [weak self] in
            self?.openMainPlayer()
        }
        miniPlayer.frame = CGRect(x: 0,
                                  y: self.view.frame.size.height,
                                  width: self.tabBar.frame.size.width,
                                  height: MiniPlayer.height)
        view.insertSubview(miniPlayer, belowSubview: self.tabBar)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    func showMiniPlayerIfNeed() {
        if miniPlayerShowing { return }
        
        miniPlayerShowing = true
        UIView.animate(withDuration: 0.3) {
            self.miniPlayer.frame = CGRect(x: 0,
                                           y: self.tabBar.frame.origin.y - MiniPlayer.height,
                                           width: self.tabBar.frame.size.width,
                                           height: MiniPlayer.height)
        } completion: { _ in
            NotificationCenter.default.post(name: .show_mini_player, object: self.miniPlayer.frame.size.height)
        }
    }
    
    func hideMiniPlayer() {
        miniPlayerShowing = false
        UIView.animate(withDuration: 0.3) {
            self.miniPlayer.frame = CGRect(x: 0,
                                           y: self.view.frame.size.height,
                                           width: self.tabBar.frame.size.width,
                                           height: MiniPlayer.height)
        } completion: { _ in
            NotificationCenter.default.post(name: .hide_mini_player, object: nil)
        }
    }
    
    private func openMainPlayer() {
        
        NotificationCenter.default.post(name: .show_main_player, object: nil)
        self.present(AppDelegate.shared.mainPlayer, animated: true)
        
    }
    
    private func styleTabbar() {
        let backgroundTabbar = UIColor.white
        if #available(iOS 13.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = backgroundTabbar
            
            setTabBarItemColors(appearance.stackedLayoutAppearance)
            setTabBarItemColors(appearance.inlineLayoutAppearance)
            setTabBarItemColors(appearance.compactInlineLayoutAppearance)
            
            tabBar.standardAppearance = appearance
            
            if #available(iOS 15.0, *) {
                tabBar.scrollEdgeAppearance = appearance
            }
        }
        else {
            //Set the background color
            UITabBar.appearance().backgroundColor = backgroundTabbar
            tabBar.backgroundImage = UIImage()   //Clear background
            
            //Set the item tint colors
            tabBar.tintColor = .white
            tabBar.unselectedItemTintColor = .lightGray
            
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.45)], for: .normal)
        }
    }
    
    @available(iOS 13.0, *)
    private func setTabBarItemColors(_ itemAppearance: UITabBarItemAppearance) {
        // https://stackoverflow.com/questions/69318520/ipados-15-uitabbar-title-cut-off
        
        itemAppearance.normal.iconColor = UIColor.black.withAlphaComponent(0.45)
        itemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.black.withAlphaComponent(0.45), .paragraphStyle: NSParagraphStyle.default]
        
        itemAppearance.selected.iconColor = .black
        itemAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.black, .paragraphStyle: NSParagraphStyle.default]
    }
    
}
