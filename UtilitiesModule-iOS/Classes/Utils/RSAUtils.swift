//
//  File.swift
//  GenieOnboard
//
//  Created by Apple on 01/08/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

public struct RSA {
    
    static func RSAEncryption(_ strRSA : String) -> String{
        if UserDefaults.standard.value(forKey: "public_key") != nil{
            let RSAKey = UserDefaults.standard.value(forKey: "public_key") as! String
            guard let Text = RSA.encrypt(string: strRSA, publicKey: RSAKey) else { return strRSA }
            return Text
        }
        return strRSA
    }
    
    static func encrypt(string: String, publicKey: String?) -> String? {
        guard let publicKey = publicKey else { return nil }
        let key =  publicKey.replacingOccurrences(of: "\r\n", with: "")
        let keyString = key.replacingOccurrences(of: "-----BEGIN PUBLIC KEY-----", with: "").replacingOccurrences(of: "-----END PUBLIC KEY-----", with: "")
        guard let data = Data(base64Encoded: keyString) else { return nil }
        
        var attributes: CFDictionary {
            return [kSecAttrKeyType         : kSecAttrKeyTypeRSA,
                    kSecAttrKeyClass        : kSecAttrKeyClassPublic,
                    kSecAttrKeySizeInBits   : 2048,
                    kSecReturnPersistentRef : true] as CFDictionary
        }
        
        var error: Unmanaged<CFError>? = nil
        guard let secKey = SecKeyCreateWithData(data as CFData, attributes, &error) else {
            return nil
        }
        return encryptNew(string: string, publicKey: secKey)
    }
    
    static func encryptNew(string: String, publicKey: SecKey) -> String? {
        let buffer = [UInt8](string.utf8)
        
        var keySize   = SecKeyGetBlockSize(publicKey)
        var keyBuffer = [UInt8](repeating: 0, count: keySize)
        
        // Encrypto  should less than key length
        guard SecKeyEncrypt(publicKey, SecPadding.PKCS1, buffer, buffer.count, &keyBuffer, &keySize) == errSecSuccess else { return nil }
        let str = Data(bytes: keyBuffer, count: keySize).base64EncodedString()
        return  str
    }
    
    enum AESError: Error {
        case KeyError((String, Int))
        case IVError((String, Int))
        case CryptorError((String, Int))
    }
}
