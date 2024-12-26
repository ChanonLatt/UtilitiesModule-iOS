//
//  AESUtils.swift
//  GenieMobile
//
//  Created by ITD-Latt Chanon on 24/12/24.
//

import Foundation
import CommonCrypto

class AESUtils {
    /// added by Chanon
    class func aesEncryptPlainText(_ text: String) -> String {
        let data = text.data(using: .utf8)
        let key = UserDefaultUtils.string(forKey: .aesEncryptKey, sharedAppGroup: .appAndWidget) ?? ""
        let keyData = key.data(using:String.Encoding.utf8)!
        guard let encryptedData = try? aesCBCEncrypt(data: data!, key:keyData) else{
            return ""
        }
        return encryptedData.base64EncodedString()
    }
    /// added by Chanon
    class func aesCBCEncrypt(data: Data, key: Data) throws -> Data {
        // Validate key length for AES (128, 192, or 256 bits)
        guard key.count == kCCKeySizeAES128 || key.count == kCCKeySizeAES192 || key.count == kCCKeySizeAES256 else {
            throw NSError(domain: "InvalidKeyLength", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid key length"])
        }
        
        // Create an initialization vector (IV)
        let ivSize = kCCBlockSizeAES128
        let iv = Data((0..<ivSize).map { _ in UInt8.random(in: 0...255) })
        
        // Prepare the output buffer
        let outputLength = data.count + kCCBlockSizeAES128
        var outputBuffer = Data(count: outputLength)
        
        var numBytesEncrypted: size_t = 0
        
        // Perform AES encryption
        let status = outputBuffer.withUnsafeMutableBytes { outputBytes in
            data.withUnsafeBytes { dataBytes in
                key.withUnsafeBytes { keyBytes in
                    iv.withUnsafeBytes { ivBytes in
                        CCCrypt(
                            CCOperation(kCCEncrypt), // Encrypt
                            CCAlgorithm(kCCAlgorithmAES), // AES
                            CCOptions(kCCOptionPKCS7Padding), // PKCS7 Padding
                            keyBytes.baseAddress, // Key
                            key.count, // Key length
                            ivBytes.baseAddress, // IV
                            dataBytes.baseAddress, // Input data
                            data.count, // Input data length
                            outputBytes.baseAddress, // Output buffer
                            outputLength, // Output buffer length
                            &numBytesEncrypted // Actual bytes encrypted
                        )
                    }
                }
            }
        }
        
        // Check encryption status
        guard status == kCCSuccess else {
            throw NSError(domain: "EncryptionError", code: Int(status), userInfo: [NSLocalizedDescriptionKey: "Encryption failed with status \(status)"])
        }
        
        // Combine IV and encrypted data
        return iv + outputBuffer.prefix(numBytesEncrypted)
    }


    class  func aesCBCDecrypt(data:Data, keyData:Data) throws -> Data?
    {
        let keyLength = keyData.count
        let validKeyLengths = [kCCKeySizeAES128, kCCKeySizeAES192, kCCKeySizeAES256]
        if (validKeyLengths.contains(keyLength) == false) {
            throw AESError.KeyError(("Invalid key length", keyLength))
        }
        
        let ivSize = kCCBlockSizeAES128;
        let clearLength = size_t(data.count - ivSize)
        guard clearLength > 0 else { return nil}
        var clearData = Data(count:clearLength)
        
        var numBytesDecrypted :size_t = 0
        let options   = CCOptions(kCCOptionPKCS7Padding)
        
        let cryptStatus = clearData.withUnsafeMutableBytes {cryptBytes in
            data.withUnsafeBytes {dataBytes in
                keyData.withUnsafeBytes {randominitialvector in
                    CCCrypt(CCOperation(kCCDecrypt),
                            CCAlgorithm(kCCAlgorithmAES128),
                            options,
                            randominitialvector, keyLength,
                            dataBytes,
                            dataBytes+kCCBlockSizeAES128, clearLength,
                            cryptBytes, clearLength,
                            &numBytesDecrypted)
                }
            }
        }
        
        if UInt32(cryptStatus) == UInt32(kCCSuccess) {
            clearData.count = numBytesDecrypted
        }
        else {
            throw AESError.CryptorError(("Decryption failed", Int(cryptStatus)))
        }
        return clearData;
    }
    class func aesDecryptPlainText(_ text: String) -> String {
        guard let data2 = Data(base64Encoded: text, options: .ignoreUnknownCharacters) else {
            return text
        }
        let key = UserDefaultUtils.string(forKey: .aesEncryptKey, sharedAppGroup: .appAndWidget) ?? ""
        let keyData   = key.data(using:String.Encoding.utf8)!
        guard let decryptData = try? aesCBCDecrypt(data:data2, keyData:keyData) else{
            return ""
        }
        return String(data: decryptData, encoding: .utf8) ?? ""
    }

}

extension AESUtils {
    enum AESError: Error {
        case KeyError((String, Int))
        case IVError((String, Int))
        case CryptorError((String, Int))
    }
}
