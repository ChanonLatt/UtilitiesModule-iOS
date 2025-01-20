//
//  UIPasteboard+Ex.swift
//  UtilitiesModule-iOS
//
//  Created by ITD-Latt Chanon on 26/12/24.
//

import UIKit

public extension UIPasteboard {
    
  static func pasteToClipboard(_ content: String) {
    self.general.string = content
  }

  static func readFromClipboard() -> String? {
    return self.general.string
  }
}
