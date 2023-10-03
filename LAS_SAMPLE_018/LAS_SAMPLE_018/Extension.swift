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
    
    var tabbar: TabbarVC? {
        for item in navigationTopMost?.viewControllers ?? [] {
            if let tab = item as? TabbarVC {
                return tab
            }
        }
        return nil
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

//extension UICollectionReusableView {
//    static var cellID: String {
//        return String(describing: self)
//    }
//}

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

extension Float64 {
    func timeFormat() -> String {
        let countTimeFormat = "%02d:%02d"
        let countTimeFormatWithHour = "%02d:%02d:%02d"
        let secondsPerHour = 3600
        let secondsPerMinute = 60
        
        var tmpTime = Int(self)
        let hours = tmpTime / secondsPerHour
        tmpTime -= hours * secondsPerHour
        let minutes = tmpTime / secondsPerMinute
        tmpTime -= minutes * secondsPerMinute
        let seconds = tmpTime
        if hours <= 0 {
            return String(format: countTimeFormat, minutes, seconds)
        } else {
            return String(format: countTimeFormatWithHour, hours, minutes, seconds)
        }
    }
}


import Photos

extension PHAsset {
    
    var getImageMaxSize : UIImage {
        var thumbnail = UIImage()
        let imageManager = PHImageManager.default()
        let option = PHImageRequestOptions()
        option.isSynchronous = true
        imageManager.requestImage(for: self, targetSize: CGSize.init(width: 720, height: 1080), contentMode: .aspectFit, options: option, resultHandler: { image, _ in
            thumbnail = image!
        })
        return thumbnail
    }
    
    
    var getImageThumb : UIImage {
        var thumbnail = UIImage()
        let imageManager = PHImageManager.default()
        let option = PHImageRequestOptions()
        option.isSynchronous = true
        imageManager.requestImage(for: self, targetSize: CGSize.init(width: 400, height: 400), contentMode: .aspectFit, options: option, resultHandler: { image, _ in
            thumbnail = image!
        })
        return thumbnail
    }
}

extension UIImage {
    
    func isEqualToImage(image: UIImage) -> Bool {
        let data1: NSData = self.pngData()! as NSData
        let data2: NSData = image.pngData()! as NSData
        return data1.isEqual(data2)
    }
    
}

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        if #available(iOS 11, *) {
                    self.clipsToBounds = true
                    self.layer.cornerRadius = radius
                    var masked = CACornerMask()
                    if corners.contains(.topLeft) { masked.insert(.layerMinXMinYCorner) }
                    if corners.contains(.topRight) { masked.insert(.layerMaxXMinYCorner) }
                    if corners.contains(.bottomLeft) { masked.insert(.layerMinXMaxYCorner) }
                    if corners.contains(.bottomRight) { masked.insert(.layerMaxXMaxYCorner) }
                    self.layer.maskedCorners = masked
                }
                else {
                    let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
                    let mask = CAShapeLayer()
                    mask.path = path.cgPath
                    layer.mask = mask
                }
     }
 }


let columns: CGFloat = UIDevice.current.is_iPhone ? 3 : 5
let padding: CGFloat = UIDevice.current.is_iPhone ? 16 : 64


extension Notification.Name {
    
    
    static let show_mini_player = Notification.Name("show_mini_player")
    static let hide_mini_player = Notification.Name("hide_mini_player")
    
    static let show_main_player = Notification.Name("show_main_player")
    static let hide_main_player = Notification.Name("hide_main_player")
}
