//
//  UIImage+Ex.swift
//  UtilitiesModule-iOS
//
//  Created by ITD-Latt Chanon on 26/12/24.
//

import Foundation
import UIKit

public extension UIImage {
//    Creates a UIImage given a UIColor
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}
