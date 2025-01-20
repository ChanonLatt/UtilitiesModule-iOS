//
//  UIButton+Ex.swift
//  UtilitiesModule-iOS
//
//  Created by ITD-Latt Chanon on 27/12/24.
//

import UIKit

private var originalButtonText: String?
private var activityIndicator: UIActivityIndicatorView!

// MARK: - General

public extension UIButton {
    
    func setTitleWithoutAnimate(title: String?) {
        UIView.performWithoutAnimation {
            self.setTitle(title, for: .normal)
            self.layoutIfNeeded()
        }
    }
    
    func setAttrTitleWithoutAnimate(title: NSAttributedString?) {
        UIView.performWithoutAnimation {
            self.setAttributedTitle(title, for: .normal)
            self.layoutIfNeeded()
        }
    }
    
    func underline() {
        guard let text = self.titleLabel?.text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedString.Key.underlineColor,
                                      value: titleColor(for: .normal)!,
                                      range: NSRange(location: 0, length: text.utf16.count))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor,
                                      value: titleColor(for: .normal)!,
                                      range: NSRange(location: 0, length: text.utf16.count))
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: NSRange(location: 0, length: text.utf16.count))
        setAttrTitleWithoutAnimate(title: attributedString)
    }
    
    func showLoading() {
        originalButtonText = self.titleLabel?.text
        self.setTitle("", for: .normal)
        
        if (activityIndicator == nil) {
            activityIndicator = createActivityIndicator()
        }
        
        showSpinning()
    }
    
    func hideLoading() {
        self.setTitle(originalButtonText, for: .normal)
        activityIndicator.stopAnimating()
    }
    
    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.lightGray
        return activityIndicator
    }
    
    func showSpinning() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        centerActivityIndicatorInButton()
        activityIndicator.startAnimating()
    }
}

// MARK: - Chainable

public extension UIButton {
    
    @discardableResult
    func chainableFont(_ font: UIFont) -> Self {
        titleLabel?.chainableFont(font)
        return self
    }
    
    @discardableResult
    func chainableTitleColor(_ color: UIColor, for state: UIButton.State = .normal) -> Self {
        setTitleColor(color, for: state)
        return self
    }
    
    @discardableResult
    func chainableImage(_ image: UIImage, for state: UIButton.State = .normal) -> Self {
        setImage(image, for: state)
        return self
    }
    
    @discardableResult
    func chainableTitle(_ title: String, for state: UIButton.State = .normal) -> Self {
        setTitle(title, for: state)
        return self
    }
    
    @discardableResult
    func chainableImageLeftWithTitleRight() -> Self {
        semanticContentAttribute = .forceLeftToRight
        return self
    }
    
    @discardableResult
    func chainableTitleLeftWithImageRight() -> Self {
        semanticContentAttribute = .forceRightToLeft
        return self
    }
    
    @discardableResult
    func chainableTitleAndImageSpacing(_ space: CGFloat) -> Self {
        let insetAmount = space / 2
        let isRTL = UIView.userInterfaceLayoutDirection(for: semanticContentAttribute) == .rightToLeft
        if isRTL {
           imageEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
           titleEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
           contentEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: -insetAmount)
        } else {
           imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
           titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
           contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
        }
        return self
    }
}

private extension UIButton {
    
    func centerActivityIndicatorInButton() {
        let xCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: activityIndicator, attribute: .centerX, multiplier: 1, constant: 0)
        self.addConstraint(xCenterConstraint)
        
        let yCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: activityIndicator, attribute: .centerY, multiplier: 1, constant: 0)
        self.addConstraint(yCenterConstraint)
    }
}
