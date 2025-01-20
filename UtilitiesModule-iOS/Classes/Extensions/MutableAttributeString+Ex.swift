
//
//  Untitled.swift
//  Pods
//
//  Created by ITD-Latt Chanon on 20/1/25.
//

import UIKit

public extension NSMutableAttributedString {
    
    @discardableResult
    func chainableSetColor(_ textToFind: String? = nil, with color: UIColor) -> Self {
        chainableSetAttribute(textToFind ?? string, with: [.foregroundColor: color])
        return self
    }
    
    @discardableResult
    func chainableSetFont(_ textToFind: String? = nil, with font: UIFont) -> Self {
        chainableSetAttribute(textToFind ?? string, with: [.font: font])
        return self
    }
    
    @discardableResult
    func chainableSetAttribute(_ textToFind: String? = nil, with attributes: [NSAttributedString.Key: Any]) -> Self {
        let range = self.mutableString.range(of: textToFind ?? string, options: .caseInsensitive)
        if range.location != NSNotFound {
            attributes.forEach {
                addAttribute($0.0, value: $0.1, range: range)
            }
        }
        return self
    }
}
