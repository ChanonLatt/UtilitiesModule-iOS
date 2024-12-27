//
//  Bundle+Ex.swift
//  UtilitiesModule-iOS
//
//  Created by ITD-Latt Chanon on 27/12/24.
//

import Foundation

public extension Bundle {
    
    func getAppInfo() -> String {
        let dictionary = infoDictionary!
        //           let version = dictionary["CFBundleShortVersionString"] as! String
        let build = dictionary["CFBundleVersion"] as! String
        // return version + "(" + build + ")"
        return build
    }
    
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
