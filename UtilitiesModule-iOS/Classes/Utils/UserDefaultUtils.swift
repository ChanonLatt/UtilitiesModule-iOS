//
//  UserDefaultUtils.swift
//  GenieMobile
//
//  Created by ITD-Latt Chanon on 24/12/24.
//

import Foundation

extension UserDefaultUtils {
    
    /// UserDefaults keys
    enum UserDefaultsKey: String {
        case aesEncryptKey = "encryptkey"
        case widgetAccountInfo
    }
    
    /// Shared data between apps
    enum SharedAppGroup: String {
        case appAndWidget = "group.com.amret.shared"
    }
}

public class UserDefaultUtils: NSObject {
    
    static func remove(for key: UserDefaultsKey, sharedAppGroup: SharedAppGroup? = nil) {
        remove(for: key.rawValue, sharedAppGroup: sharedAppGroup)
    }
    
    static func remove(for key: String, sharedAppGroup: SharedAppGroup? = nil) {
        Self.defaults(sharedAppGroup).removeObject(forKey: key)
    }
    
    static func setData(value: Data?,
                        for key: UserDefaultsKey,
                        sharedAppGroup: SharedAppGroup? = nil) {
        Self.defaults(sharedAppGroup).set(value, forKey: key.rawValue)
    }
    
    static func setString(value: String?,
                          forKey key: UserDefaultsKey,
                          sharedAppGroup: SharedAppGroup? = nil) {
        Self.defaults(sharedAppGroup).set(value ?? "", forKey: key.rawValue)
    }
    
    static func setBool(value: Bool,
                        forKey key: UserDefaultsKey,
                        sharedAppGroup: SharedAppGroup? = nil) {
        Self.defaults(sharedAppGroup).set(value, forKey: key.rawValue)
    }
    
    static func data(for key: UserDefaultsKey, sharedAppGroup: SharedAppGroup? = nil) -> Data? {
        Self.defaults(sharedAppGroup).data(forKey: key.rawValue)
    }
    
    static func string(forKey key: UserDefaultsKey, sharedAppGroup: SharedAppGroup? = nil) -> String? {
        Self.defaults(sharedAppGroup).string(forKey: key.rawValue)
    }
    
    static func bool(forKey key: UserDefaultsKey, sharedAppGroup: SharedAppGroup? = nil) -> Bool {
        Self.defaults(sharedAppGroup).bool(forKey: key.rawValue)
    }
}

extension UserDefaultUtils {
    private static func defaults(_ sharedAppGroup: SharedAppGroup? = nil) -> UserDefaults {
        if let sharedAppGroup {
            return UserDefaults(suiteName: sharedAppGroup.rawValue) ?? defaults()
        } else {
            return UserDefaults.standard
        }
    }
}
