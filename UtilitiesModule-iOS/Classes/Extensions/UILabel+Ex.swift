//
//  UILabel+Ex.swift
//  Pods
//
//  Created by ITD-Latt Chanon on 20/1/25.
//

import UIKit

// MARK: - General

public extension UILabel {
    
    func underline() {
        guard let text = text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedString.Key.underlineColor,
                                      value: textColor ?? .black,
                                      range: NSRange(location: 0, length: text.utf16.count))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor,
                                      value: textColor ?? .black,
                                      range: NSRange(location: 0, length: text.utf16.count))
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: NSRange(location: 0, length: text.utf16.count))
        attributedText = attributedString
    }
}

// MARK: - Chainable

public extension UILabel {
    
    @discardableResult
    func chainableLineHeight(_ lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) -> Self {

        guard let labelText = self.text else {
            return self
        }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        paragraphStyle.alignment = textAlignment

        let attributedString:NSMutableAttributedString
        if let labelattributedText = attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
            attributedString.addAttribute(NSAttributedString.Key.font,
                                          value: font ?? .systemFont(ofSize: 14.0),
                                          range: NSRange(location: 0, length: attributedString.length))
        }

        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        self.attributedText = attributedString
        return self
    }

    @discardableResult
    func chainableUnderLine() -> Self {
        underline()
        return self
    }
    
    @discardableResult
    func chainableText(_ textString: String?) -> Self {
        text = textString
        return self
    }
    
    @discardableResult
    func chainableAttributedText(_ attributedString: NSAttributedString?) -> Self {
        attributedText = attributedString
        return self
    }
    
    @discardableResult
    func chainableTextColor(_ color: UIColor) -> Self {
        textColor = color
        return self
    }
    
    @discardableResult
    func chainableFont(_ labelFont: UIFont) -> Self {
        font = labelFont
        return self
    }
    
    @discardableResult
    func chainableTextAlignment(_ alignment: NSTextAlignment) -> Self {
        textAlignment = alignment
        return self
    }
    
    @discardableResult
    func chainableTextAlignLeft() -> Self {
        textAlignment = .left
        return self
    }
    
    @discardableResult
    func chainableTextAlignRight() -> Self {
        textAlignment = .right
        return self
    }
    
    @discardableResult
    func chainableTextAlignCenter() -> Self {
        textAlignment = .center
        return self
    }
    
    @discardableResult
    func chainableNumberOfLine(_ lines: Int) -> Self {
        numberOfLines = lines
        return self
    }
    
    @discardableResult
    func chainableSingleLine() -> Self {
        numberOfLines = 1
        return self
    }
    
    @discardableResult
    func chainableDoubleLines() -> Self {
        numberOfLines = 2
        return self
    }
    
    @discardableResult
    func chainableUlimitedLines() -> Self {
        numberOfLines = 0
        return self
    }
}

// MARK: - UIView + Blur

public extension UIView {
    
    func blur(_ blurRadius: Double = 2.4) {
        getBlurryImage(blurRadius) { [weak self] blurredImage in
            DispatchQueue.main.async { [weak self] in
                if let self {
                    self.unblur()
                    let blurredImageView = UIImageView(image: blurredImage)
                    blurredImageView.translatesAutoresizingMaskIntoConstraints = false
                    blurredImageView.tag = 100
                    blurredImageView.contentMode = .center
                    blurredImageView.backgroundColor = .white
                    self.addSubview(blurredImageView)
                    NSLayoutConstraint.activate([
                        blurredImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0.0),
                        blurredImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0.0),
                        blurredImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
                        blurredImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
                    ])
                }
            }
        }
    }
    
    func unblur() {
        subviews.forEach { subview in
            if subview.tag == 100 {
                subview.removeFromSuperview()
            }
        }
    }
    
    private func getBlurryImage(_ blurRadius: Double = 2.5, completion: @escaping ((UIImage?) -> Void)) {
        UIGraphicsBeginImageContext(bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            layer.render(in: context)
            guard let image = UIGraphicsGetImageFromCurrentImageContext(),
                  let blurFilter = CIFilter(name: "CIGaussianBlur") else {
                UIGraphicsEndImageContext()
                return
            }
            UIGraphicsEndImageContext()
            blurFilter.setDefaults()
            blurFilter.setValue(CIImage(image: image), forKey: kCIInputImageKey)
            blurFilter.setValue(blurRadius, forKey: kCIInputRadiusKey)
            
            DispatchQueue.global(qos: .background).async {
                let context = CIContext(options: nil)
                if let blurOutputImage = blurFilter.outputImage,
                   let cgImage = context.createCGImage(blurOutputImage, from: blurOutputImage.extent) {
                    let convertedImage = UIImage(cgImage: cgImage)
                    completion(convertedImage)
                }
            }
        }
    }
}

// MARK: - Initializers

public extension UILabel {

    convenience init(_ text: String?) {
        self.init(frame: .zero)
        self.text = text
    }
}
