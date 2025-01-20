//
//  String+Ex.swift
//  UtilitiesModule-iOS
//
//  Created by ITD-Latt Chanon on 26/12/24.
//

import UIKit
import CommonCrypto

// MARK: - General

public extension String {
    
    var findImage: UIImage? {
        UIImage(named: self)
    }
    
    var isValidPassword: Bool {
        let regex = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$"
        return range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    func utf8DecodedString()-> String {
        let data = self.data(using: .utf8)
        let message = String(data: data!, encoding: .nonLossyASCII) ?? ""
        return message
    }
    
    func utf8EncodedString()-> String {
        let messageData = self.data(using: .nonLossyASCII)
        let text = String(data: messageData!, encoding: .utf8) ?? ""
        return text
    }
    
    func convertToDictionary() -> [String: Any]? {
        if let data = data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func containsEmoji() -> Bool {
        for scalar in unicodeScalars {
            if !scalar.properties.isEmoji { continue }
            return true
        }

        return false
    }
    
    func stringByRemovingEmoji() -> String {
      return String(self.filter { !$0.isEmoji() })
    }
    
    func removeSpecialKhmerCharsFromString() -> String {
        let validChars = Set("កខគឃងចឆជឈញដឋឌឍណតថទធនបផពភមយរលវឝឞសហឡអ")
        return filter { validChars.contains($0) }
    }
    
    func containsKhmerCharacters() -> Bool {
        // Define the Unicode character range for Khmer script
        let khmerCharacterSet = CharacterSet(charactersIn: "\u{1780}-\u{17FF}\u{19E0}-\u{19FF}\u{17B6}\u{17C9}\u{17BE}\u{17C1}-\u{17C3}\u{17B7}-\u{17BD}\u{17C4}-\u{17C6}\u{17CA}")
        
        // Check if the string contains any characters in the Khmer character set
        return rangeOfCharacter(from: khmerCharacterSet) != nil
    }
    
    func countKhmerCharacters() -> Int {
        // Define the Unicode character range for Khmer script
        let khmerCharacterSet = CharacterSet(charactersIn: "\u{1780}-\u{17FF}\u{19E0}-\u{19FF}\u{17B6}\u{17C9}\u{17BE}\u{17C1}-\u{17C3}\u{17B7}-\u{17BD}\u{17C4}-\u{17C6}\u{17CA}")
        
        // Initialize a counter for Khmer characters
        var khmerCharacterCount = 0
        
        // Iterate over each character in the string
        for scalar in unicodeScalars {
            // Check if the character is in the Khmer character set
            if khmerCharacterSet.contains(scalar) {
                khmerCharacterCount += 1
            }
        }
        
        return khmerCharacterCount
    }
    
    func removeSpecialCharsFromMonth() -> String {
        let validChars = Set("1234567890")
        return filter { validChars.contains($0) }
    }
    
    func isTextFieldOnlyWhitespace() -> Bool {
        trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    func insertSpacesEveryFourDigitsIntoString(andPreserveCursorPosition cursorPosition: inout Int) -> String {
        var stringWithAddedSpaces = ""
        let cursorPositionInSpacelessString = cursorPosition
        
        for i in stride(from: 0, to: count, by: 1) {
            if i > 0 && (i % 3) == 0 {
                stringWithAddedSpaces.append(" ")
                if i < cursorPositionInSpacelessString {
                    cursorPosition += 1
                }
            }
            let characterToAdd = self[index(startIndex, offsetBy: i)]
            stringWithAddedSpaces.append(characterToAdd)
        }
        
        return stringWithAddedSpaces
    }
    
    func removeSpecialCharsFromString() -> String {
        let validChars = Set("1234567890.")
        return String(filter { validChars.contains($0) })
    }
    
    func removeNoneDigits(andPreserveCursorPosition cursorPosition: inout Int) -> String {
        var digitsOnlyString = ""
        let originalCursorPosition = cursorPosition
        
        for i in Swift.stride(from: 0, to: count, by: 1) {
            let characterToAdd = self[index(startIndex, offsetBy: i)]
            if characterToAdd >= "0" && characterToAdd <= "9" {
                digitsOnlyString.append(characterToAdd)
            }
            else if i < originalCursorPosition {
                cursorPosition -= 1
            }
        }
        
        return digitsOnlyString
    }
    
    /// Moved from `class func stringReplace(string: String) -> String{`
    func removeComma() -> String {
        replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
    }
    
    func removeLeadingZeros() -> String {
        let trimmedText = trimmingCharacters(in: .whitespaces)
        let textWithoutLeadingZeros = trimmedText.replacingOccurrences(of: "^0+", with: "", options: .regularExpression)
        return textWithoutLeadingZeros.isEmpty ? "0" : textWithoutLeadingZeros
    }
    
    //MARK:- setip Attributed string
    func setupAttributeString(Range : String,
                              type: String,
                              color: UIColor?,
                              size: CGFloat,
                              fontname : String? = "Poppins-Medium") -> NSAttributedString{
        let underlineAttriString = NSMutableAttributedString(string: self)
        let range1 = (self as NSString).range(of: Range)
        if type == "underline" && color != nil{
            underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range1)
            underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value:color!, range: range1)
        }else if type == "font" && color != nil{
            underlineAttriString.addAttribute(NSAttributedString.Key.font, value:  UIFont.init(name: fontname!, size: size) as Any, range: range1)
            underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value:color!, range: range1)
        }else if type == "underline" && color == nil{
            underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range1)
        }else if type == "foreground color"{
            underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value:color!, range: range1)
        }
        else if type == "background color"{
            underlineAttriString.addAttribute(NSAttributedString.Key.backgroundColor, value:color!, range: range1)
        }
        else if type == "strike" && color != nil{
            underlineAttriString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: range1)
            underlineAttriString.addAttribute(NSAttributedString.Key.strikethroughColor, value: color!, range: range1)
            underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value:color!, range: range1)
        }
        else if type == "strike" && color == nil{
            underlineAttriString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: range1)
        }
        return underlineAttriString
    }
    
    func SetupAttributeString1(Range : String,
                               type: String,
                               color: UIColor?,
                               size: CGFloat,
                               fontname : String? = "Poppins-Regular") -> NSAttributedString{
        let underlineAttriString = NSMutableAttributedString(string: self)
        let range1 = (self as NSString).range(of: Range)
        if type == "underline" && color != nil{
            underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range1)
            underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value:color!, range: range1)
        }else if type == "font" && color != nil{
            underlineAttriString.addAttribute(NSAttributedString.Key.font, value:  UIFont.init(name: fontname!, size: size) as Any, range: range1)
            underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value:color!, range: range1)
        }else if type == "underline" && color == nil{
            underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range1)
        }else if type == "foreground color"{
            underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value:color!, range: range1)
            underlineAttriString.addAttribute(NSAttributedString.Key.font, value:  UIFont.init(name: fontname!, size: size) as Any, range: range1)
        }
        else if type == "background color"{
            underlineAttriString.addAttribute(NSAttributedString.Key.backgroundColor, value:color!, range: range1)
        }
        else if type == "strike" && color != nil{
            underlineAttriString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: range1)
            underlineAttriString.addAttribute(NSAttributedString.Key.strikethroughColor, value: color!, range: range1)
            underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value:color!, range: range1)
        }
        else if type == "strike" && color == nil{
            underlineAttriString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: range1)
        }
        return underlineAttriString
        
    }
    
    func toDictionary() -> NSDictionary? {
        //        let string = "[{\"form_id\":3465,\"canonical_name\":\"df_SAWERQ\",\"form_name\":\"Activity 4 with Images\",\"form_desc\":null}]"
        
        var dictonary:NSDictionary = NSDictionary()
        
        if let data = data(using: String.Encoding.utf8){
            
            do {
                dictonary = try (JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String:AnyObject] as NSDictionary?)!
            } catch {
                print(error.localizedDescription)
            }
        }
        
        return dictonary
    }
    
    func sha256() -> String {
        guard let inputData = data(using: .utf8) else { return "" }
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        inputData.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(inputData.count), &hash)
        }
        return hash.map { String(format: "%02x", $0) }.joined()
    }
    
    var digitsOnly: String {
        return components(separatedBy: NSCharacterSet.init(charactersIn: "0123456789.").inverted).joined(separator: "")
    }
    
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    
    // Function to add newlines to long strings
    func wrapped(at width: Int) -> String {
        var result = ""
        var currentLineWidth = 0
        for word in self.split(separator: " ") {
            currentLineWidth += word.count
            if currentLineWidth > width {
                result += "\n"
                currentLineWidth = word.count
            }
            result += " " + word
        }
        return result.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var toDouble: Double {
        Double(self) ?? .zero
    }
}

// MARK: - Static

public extension String {
    
    static func getUUid() -> String{
        UUID().uuidString
    }
    
    static func stringWidth(text: String,
                            font: UIFont,
                            height: CGFloat) -> Double {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font
        ]
        let attributedText = NSAttributedString(string: text, attributes: attributes)
        let constraintBox = CGSize(width: .greatestFiniteMagnitude, height: height)
        let textWidth = attributedText.boundingRect(with: constraintBox, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).width.rounded(.up)
        
        return textWidth
    }
    
    static func random(digits: Int) -> String {
        var number = String()
        for _ in 1...digits {
            number += "\(Int.random(in: 1...9))"
        }
        return number
    }
    
    static func generateRandomAlphanumericString(length: Int) -> String {
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map { _ in letters.randomElement()! })
    }
}


// MARK: - Formatting

public extension String {
    
    func converAmount(currency: String) -> String{
        let newStr = self
        if currency == "KHR"{
            //            var str1 = ""
            var str2 = ""
            if newStr.contains("."){
                let numOccurrences = newStr.filter{ $0 == "." }.count
                if numOccurrences > 1{
                    str2 = ""
                    str2 = newStr.replacingOccurrences(of: ".", with: "")
                    //                    txt_amt.text = str2
                    str2 = str2.toDouble.indianCurrency()
                    return str2
                }
                else{
                    let fullNameArr = newStr.components(separatedBy: ("."))
                    //                str1 = fullNameArr[0]
                    str2 = fullNameArr[1]
                    str2 = ""
                    //                str2 = "\(fullNameArr[0])\(fullNameArr[1])"//old
                    str2 = "\(fullNameArr[0])"
                    //                    txt_amt.text = str2
                    str2 = str2.toDouble.indianCurrency()
                    return str2
                }
            }
            else{
                str2 = ""
                str2 = newStr
                //                txt_amt.text = str2
                str2 = str2.toDouble.indianCurrency()
                return str2
            }
        }
        else{
            var str1 = ""
            var str2 = ""
            if newStr.contains("."){
                let numOccurrences = newStr.filter{ $0 == "." }.count
                if numOccurrences > 1{
                    let count = newStr.components(separatedBy: ("."))// prints out 2
                    var str2 = ""
                    for i in 0..<numOccurrences{
                        str2 = "\(str2)\(count[i])"
                    }
                    str2 = str2.toDouble.indianCurrency()
                    let number = count[numOccurrences]
                    if number.count > 2{
                        let index = number.count - 2
                        let endIndex = number.index(number.endIndex, offsetBy: -index)
                        let truncated = number.substring(to: endIndex)
                        str2 = "\(str2).\(truncated)"
                        //                    txt_amt.text = str2
                        return str2
                    }
                    else{
                        str2 = "\(str2).\(count[numOccurrences])"
                        //                    txt_amt.text = str2
                        return str2
                    }
                }
                else{
                    let fullNameArr = newStr.components(separatedBy: ("."))
                    str1 = fullNameArr[0]
                    str2 = fullNameArr[1]
                    str1 = str1.toDouble.indianCurrency()
                    if str2.count > 2{
                        let index = str2.count - 2
                        let endIndex = str2.index(str2.endIndex, offsetBy: -index)
                        let truncated = str2.substring(to: endIndex)
                        str2 = ""
                        str2 = "\(str1).\(truncated)"
                        //                txt_amt.text = str2
                        return str2
                    }
                    else{
                        str2 = ""
                        str2 = "\(str1).\(fullNameArr[1])"
                        //                txt_amt.text = str2
                        return str2
                    }
                }
            }
            else{
                str2 = ""
                str2 = newStr
                str2 = str2.toDouble.indianCurrency()
                //            txt_amt.text = str2
                return str2
            }
        }
    }
    
    func changeDateFormat() -> String? {
        // Create a DateFormatter to parse the original date string
        let originalDateFormatter = DateFormatter()
        originalDateFormatter.dateFormat = "MMM dd, yyyy"
        originalDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        // Parse the original date string into a Date object
        guard let date = originalDateFormatter.date(from: self) else {
            return nil
        }
        
        // Extract day, month, and year components from the Date object
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MMM"
        let month = monthFormatter.string(from: date)
        let year = calendar.component(.year, from: date)
        
        // Get the ordinal suffix for the day
        let ordinalSuffix: String
        switch day {
        case 11...13:
            ordinalSuffix = "th"
        default:
            switch day % 10 {
            case 1:
                ordinalSuffix = "st"
            case 2:
                ordinalSuffix = "nd"
            case 3:
                ordinalSuffix = "rd"
            default:
                ordinalSuffix = "th"
            }
        }
        
        // Format the new date string
        let formattedDateString = "\(day)\(ordinalSuffix) \(month) - \(year)"
        return formattedDateString
    }
    
    func converDate() -> String{
        let prefixIndex = index(startIndex, offsetBy: 4)
        let year = prefix(upTo: prefixIndex) // Hello
        let date = suffix(2) // playground
        let start = index(startIndex, offsetBy: 4)
        let end = index(endIndex, offsetBy: -2)
        let range = start..<end
        let month = self[range]
        let hole = "\(year)-\(month)-\(date)"
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd, yyyy"
        dateFormatterPrint.timeZone = .none
        
        let date1: NSDate? = dateFormatterGet.date(from: hole) as NSDate?
        return dateFormatterPrint.string(from: date1! as Date)
    }
    /// Moved from `class func splitArray(string :String, type: String) -> String`
    func formatedPrice(for currency: String) -> String{
        let priceParts = components(separatedBy: ("."))
        let numberOnly = priceParts[0]
        let fractionOnly = priceParts[1]
        let formatedNumber = numberOnly.toDouble.dollarCurrency()
        let fullPrice = "\(formatedNumber).\(fractionOnly)"
        if currency == "KHR" {
            return numberOnly.toDouble.indianCurrency()
        } else {
            return fullPrice
        }
    }
    
    // formatting text for currency textField
    func currencyInputFormatting(currencyType: String?) -> String {
    
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
  
        
        if currencyType == "USD" {
//            var number: NSNumber!
           // formatter.decimalSeparator = "."
          //  formatter.currencySymbol = "$"
         //   formatter.currencyDecimalSeparator = "."
          //  formatter.alwaysShowsDecimalSeparator = false
         //   formatter.minimumIntegerDigits = 1
            formatter.groupingSize = 3
            formatter.groupingSeparator = ","
            formatter.maximumFractionDigits = 2
            formatter.minimumFractionDigits = 0
        
           
            var amountWithPrefix = self
            amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
            
//            let double = (amountWithPrefix as NSString).doubleValue
          //  number = NSNumber(value: (double / 100))
            
//            guard number != 0 as NSNumber else {
//                       return ""
//                   }
            let amount = Double((amountWithPrefix as NSString) as Substring)
               
            return formatter.string(from: amount as? NSNumber ?? 0)!

        } else {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
            var number: NSNumber!
            formatter.currencySymbol = "៛"
            formatter.maximumFractionDigits = 0
            formatter.decimalSeparator = ","
            formatter.groupingSeparator = ","
        
            var amountWithPrefix = self
        
            amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
        
            let double = (amountWithPrefix as NSString).doubleValue
            number = NSNumber(value: (double / 100))
            guard number != 0 as NSNumber else {
                       return ""
                   }
               
            return formatter.string(from: double as NSNumber)!

        }
    }
    
    func KHRAmountValid(currencyType: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        var number: NSNumber!
        formatter.currencySymbol = "៛"
        formatter.maximumFractionDigits = 0
    
        var amountWithPrefix = self
    
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
    
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))
        guard number != 0 as NSNumber else {
                   return ""
               }
           
        return formatter.string(from: double as NSNumber)!
    }
}

extension Character {
  fileprivate func isEmoji() -> Bool {
    return Character(UnicodeScalar(UInt32(0x1d000))!) <= self && self <= Character(UnicodeScalar(UInt32(0x1f77f))!)
      || Character(UnicodeScalar(UInt32(0x2100))!) <= self && self <= Character(UnicodeScalar(UInt32(0x26ff))!)
  }
}
