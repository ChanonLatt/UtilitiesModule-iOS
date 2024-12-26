//
//  AuthUtils.swift
//  UtilitiesModule-iOS
//
//  Created by ITD-Latt Chanon on 26/12/24.
//

import Foundation

public class AuthUtils {
    class func getidentityToken() -> String? {
        let getidentityToken = UserDefaults.standard.object(forKey: "identity_token") as? String
        return getidentityToken
    }
    class func getKeyToken() -> String? {
        let getidentityToken = UserDefaults.standard.object(forKey: "key_token") as? String
        return getidentityToken
    }
    class func getValueToken() -> String? {
        let getidentityToken = UserDefaults.standard.object(forKey: "value_token") as? String
        return getidentityToken
    }
    
    class func getPinToken() -> String? {
        let getidentityToken = UserDefaults.standard.object(forKey: "pin_token") as? String
        return getidentityToken
    }
    class func getPublicToken() -> String? {
        let getidentityToken = UserDefaults.standard.object(forKey: "public_key") as? String
        return getidentityToken
    }
    class func getOldPublicToken() -> String? {
        
        let getidentityToken = UserDefaults.standard.object(forKey: "old_Public_key") as? String
        return getidentityToken
    }
    class func getOtpPublicKey() -> String? {
        let getidentityToken = UserDefaults.standard.object(forKey: "otp_Public_key") as? String
        return getidentityToken
    }
    class func getLogggedIn() -> Bool? {
        let getidentityToken = UserDefaults.standard.object(forKey: "isLoggedIn") as? Bool
        return getidentityToken
    }
}
