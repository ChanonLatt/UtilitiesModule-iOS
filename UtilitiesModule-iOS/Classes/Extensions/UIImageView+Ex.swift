//
//  UIImageView+Ex.swift
//  UtilitiesModule-iOS
//
//  Created by ITD-Latt Chanon on 26/12/24.
//

import UIKit

// MARK: - Initializers

public extension UIImageView {
    
    convenience init(_ image: UIImage?) {
        self.init()
        self.image = image
    }
    
    convenience init(_ image: String?) {
        self.init()
        self.image = image?.findImage
    }
}

// MARK: - Chainable

public extension UIImageView {
    
    @discardableResult
    func chainableImage(_ image: UIImage?) -> Self {
        self.image = image
        return self
    }
    
    @discardableResult
    func chainableImage(_ image: String?) -> Self {
        self.image = image?.findImage
        return self
    }
}
