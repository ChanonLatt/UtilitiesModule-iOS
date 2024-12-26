//
//  LoggerUtils.swift
//  UtilitiesModule-iOS
//
//  Created by ITD-Latt Chanon on 26/12/24.
//

import Foundation

public class LoggerUtils {
    
    class func myPrint(_ items: Any...,
                       separator: String = " ",
                       terminator: String = "\n") {
        print(items[0],
              separator: separator,
              terminator: terminator)
    }
}
