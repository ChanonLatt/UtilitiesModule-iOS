//
//  Numeric+Ex.swift
//  UtilitiesModule-iOS
//
//  Created by ITD-Latt Chanon on 26/12/24.
//

import Foundation

// MARK: - General

public extension Numeric {
    
    var toString: String {
        String(describing: self)
    }
}

public extension BinaryFloatingPoint {
    
    var isPositive: Bool {
        self > 0
    }
    
    var toDouble: Double {
        Double(self)
    }
}

public extension BinaryInteger {
    
    var toInt: Int {
        Int(self)
    }
    
    var toDouble: Double {
        Double(self)
    }
}

// MARK: - Numberic + Format

public extension BinaryFloatingPoint {
    
    func indianCurrency() -> String {
        let formatter = NumberFormatter()              // Cache this, NumberFormatter creation is expensive.
        formatter.locale = Locale(identifier: "en_US") // Here indian locale with english language is used
        formatter.numberStyle = .decimal               // Change to `.currency` if needed
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        let asd = formatter.string(from: NSNumber(floatLiteral: Double(self)))
        return asd ?? ""
    }
    
    func dollarCurrency() -> String {
        let formatter = NumberFormatter()              // Cache this, NumberFormatter creation is expensive.
        formatter.locale = Locale(identifier: "en_US") // Here indian locale with english language is used
        formatter.numberStyle = .decimal               // Change to `.currency` if needed
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        let asd = formatter.string(from: NSNumber(floatLiteral: Double(self)))
        return asd ?? ""
    }
}
