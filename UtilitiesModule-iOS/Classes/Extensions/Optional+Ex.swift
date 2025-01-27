//
//  Optional+Ex.swift
//  UtilitiesModule-iOS
//
//  Created by ITD-Latt Chanon on 26/12/24.
//

import Foundation

public extension Optional {
    
    func unwrap( _ execute: (Wrapped)->Void) {
        if let value = self {
            execute(value)
        }
    }
    
    var isNil: Bool {
        self == nil
    }
    
    var isNotNil: Bool {
        !isNil
    }
}


public extension Optional where Wrapped == String {
    
    var isNilorEmpty: Bool {
        isNil || self == ""
    }
    
    var isNotNilNotEmpty: Bool {
        !isNilorEmpty
    }
    
    var wrappedAndEmptyStringIfNil: String {
        self ?? ""
    }
}
