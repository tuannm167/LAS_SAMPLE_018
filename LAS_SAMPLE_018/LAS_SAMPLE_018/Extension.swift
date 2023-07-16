//
//  Extension.swift
//  LAS_SAMPLE_018
//
//  Created by Minh Tuan on 16/07/2023.
//
import UIKit

extension UIFont {
    static func fontRegular(_ size: CGFloat) -> UIFont? {
        return UIFont(name: "Chillax-Regular", size: size)
    }
    static func fontMedium(_ size: CGFloat) -> UIFont? {
        return UIFont(name: "Chillax-Medium", size: size)
    }
    
    static func fontSemibold(_ size: CGFloat) -> UIFont? {
        return UIFont(name: "Chillax-Semibold", size: size)
    }
    
    static func fontBold(_ size: CGFloat) -> UIFont? {
        return UIFont(name: "Chillax-Bold", size: size)
    }
    
}

extension UIStoryboard {
    static let main = UIStoryboard(name: "Main", bundle: nil)
    
    static func createController<T: UIViewController>() -> T {
        return main.instantiateViewController(withIdentifier: String(describing: T.self)) as! T
    }
}

// MARK: - UIColor
extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(red: (rgb >> 16) & 0xFF, green: (rgb >> 8) & 0xFF, blue: rgb & 0xFF)
    }
}

extension UIWindow {
    static var keyWindow: UIWindow? {
        // iOS13 or later
        if #available(iOS 13.0, *) {
            guard let scene = UIApplication.shared.connectedScenes.first,
                  let sceneDelegate = scene.delegate as? SceneDelegate else { return nil }
            return sceneDelegate.window
        } else {
            // iOS12 or earlier
            guard let appDelegate = UIApplication.shared.delegate else { return nil }
            return appDelegate.window ?? nil
        }
    }
    var navigationTopMost: UINavigationController? {
        return UIWindow.keyWindow?.rootViewController as? UINavigationController
    }
}

extension UIApplication {
    class func getTopController(base: UIViewController? = UIWindow.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopController(base: nav.visibleViewController)
            
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopController(base: selected)
            
        } else if let presented = base?.presentedViewController {
            return getTopController(base: presented)
        }
        return base
    }
}

extension UIDevice {
    var is_iPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
}

extension UIDevice {
    var is_iPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
}

extension String {
    func trimming() -> String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension UICollectionViewCell {
    static var cellId: String {
        return String(describing: self)
    }
}

extension UICollectionReusableView {
    static var cellID: String {
        return String(describing: self)
    }
}

extension UITableViewCell {
    static var cellId: String {
        return String(describing: self)
    }
}

extension UInt64
{
    func toString() -> String
    {
        let myString = String(self)
        return myString
    }
}
