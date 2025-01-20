//
//  Array+Ex.swift
//  UtilitiesModule-iOS
//
//  Created by ITD-Latt Chanon on 20/1/25.
//

import Foundation

public extension Array {
    
    func concat(_ elements: Self) -> Self {
        return self + elements
    }
    
    func concat(_ element: Self.Element) -> Self {
        return self + [element]
    }
    
    var isSingleElement: Bool {
        count == 1
    }
    
    func limit(_ max: Int) -> [Element] {
        Array(prefix(max))
    }
    
    var isNotEmpty: Bool {
        !isEmpty
    }
    
    mutating func safeSet(item: Element, for index: Int) {
        if self[safe: index] != nil {
            self[index] = item
        }
    }
    
    mutating func safeSetWithAppend(item: Element, for index: Int) {
        if self[safe: index] != nil {
            self[index] = item
        } else {
            append(item)
        }
    }
    
    subscript (safe index: Int?) -> Element? {
        if let index {
            if index >= 0, index < count {
                return self[index]
            }
        }
        return nil
    }
}
