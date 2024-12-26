//
//  UIApplication+Ex.swift
//  UtilitiesModule-iOS
//
//  Created by ITD-Latt Chanon on 26/12/24.
//

import Foundation

// MARK: - General

public extension UIApplication {
    
    var topViewController: UIViewController? {
        guard var topController = keyWindow?.rootViewController else {
            return nil
        }
        
        while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
        }
        
        if let navigationController = topController as? UINavigationController {
            topController = navigationController.viewControllers.last ?? UIViewController()
        }
        
        return topController
    }
}
    
// MARK: - Static

public extension UIApplication {
    
    class func getAppInfo()->String {
        let dictionary = Bundle.main.infoDictionary!
        //           let version = dictionary["CFBundleShortVersionString"] as! String
        let build = dictionary["CFBundleVersion"] as! String
        // return version + "(" + build + ")"
        return build
    }
    
    class func openURL(_ str : String) {
        guard let url = URL(string: str) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
}
