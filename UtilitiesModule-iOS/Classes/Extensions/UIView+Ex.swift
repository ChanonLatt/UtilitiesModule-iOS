//
//  UIView+Ex.swift
//  UtilitiesModule-iOS
//
//  Created by ITD-Latt Chanon on 26/12/24.
//

import UIKit

// MARK: - General

public extension UIView {
    
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    func makeSnapshot() -> UIImage? {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(size: frame.size)
            return renderer.image { _ in drawHierarchy(in: bounds, afterScreenUpdates: true) }
        } else {
            return layer.makeSnapshot()
        }
    }
    
    func layoutAnchor (top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, centerX : NSLayoutXAxisAnchor?, centerY : NSLayoutYAxisAnchor? ,paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat, enableInsets: Bool) {
        var topInset: CGFloat
        var bottomInset: CGFloat
        topInset = 0.0
        bottomInset = 0.0
        
        if #available(iOS 11, *), enableInsets {
            let insets = self.safeAreaInsets
            topInset = insets.top
            bottomInset = insets.bottom
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if (top != nil) {
            self.topAnchor.constraint(equalTo: top ?? NSLayoutYAxisAnchor(), constant: paddingTop+topInset).isActive = true
        }
        if (left != nil) {
            self.leftAnchor.constraint(equalTo: left ?? NSLayoutXAxisAnchor(), constant: paddingLeft).isActive = true
        }
        if (right != nil) {
            rightAnchor.constraint(equalTo: right ?? NSLayoutXAxisAnchor(), constant: -paddingRight).isActive = true
        }
        if (bottom != nil) {
            bottomAnchor.constraint(equalTo: bottom ?? NSLayoutYAxisAnchor(), constant: -paddingBottom-bottomInset).isActive = true
        }
        if (centerX != nil) {
            centerXAnchor.constraint(equalTo: centerX ?? NSLayoutXAxisAnchor(), constant: 0.0).isActive = true
        }
        if (centerY != nil) {
            centerYAnchor.constraint(equalTo: centerY ?? NSLayoutYAxisAnchor(), constant: 0.0).isActive = true
        }
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
    }
    
    func setOnClickListener(userInfo: [String:Any], action :@escaping ([String:Any]?) -> Void){
        self.isUserInteractionEnabled = true
        let tapRecogniser = ClickListener(target: self, action: #selector(onViewClicked), userInfo: userInfo, onClick: action)
        tapRecogniser.numberOfTapsRequired = 1
        tapRecogniser.numberOfTouchesRequired = 1
    
        self.addGestureRecognizer(tapRecogniser)
    }
    @objc fileprivate func onViewClicked(_ sender: ClickListener) {
    //    self.isUserInteractionEnabled = false
        sender.onClick?(sender.userInfo)
    }
    
    func setGradientBackground(firstColor: UIColor, secondColor: UIColor,startpoint : CGPoint, endpoint: CGPoint, cornerRadius: NSInteger, offset: CGSize, shadowOpacity: Float, shadowRadius : NSInteger, shadowColor : UIColor) {
        let colorTop =  firstColor
        let colorBottom = secondColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop.cgColor, colorBottom.cgColor]
        gradientLayer.startPoint = startpoint
        gradientLayer.endPoint = endpoint
        gradientLayer.frame = self.bounds
        gradientLayer.cornerRadius = CGFloat(cornerRadius)
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowRadius = CGFloat(shadowRadius)
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.masksToBounds = false
        
        self.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat){
        let path = UIBezierPath(roundedRect:self.bounds, byRoundingCorners:corners, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
    
    func screenshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0.0)
        self.drawHierarchy(in: self.frame, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func createDottedHorizontalLine(_ width: CGFloat, _ color: CGColor) {
        let caShapeLayer = CAShapeLayer()
        caShapeLayer.strokeColor = color
        caShapeLayer.lineWidth = width
        caShapeLayer.lineDashPattern = [3,4]
        let cgPath = CGMutablePath()
        let cgPoint = [CGPoint(x: 0, y: 0), CGPoint(x: frame.width, y: 0)]
        cgPath.addLines(between: cgPoint)
        caShapeLayer.path = cgPath
        layer.addSublayer(caShapeLayer)
    }
    
    func createDottedVerticalLine(_ width: CGFloat, _ color: CGColor) {
        let caShapeLayer = CAShapeLayer()
        caShapeLayer.strokeColor = color
        caShapeLayer.lineWidth = width
        caShapeLayer.lineDashPattern = [3,4]
        let cgPath = CGMutablePath()
        let cgPoint = [CGPoint(x: 0, y: 0), CGPoint(x: 0, y: frame.height)]
        cgPath.addLines(between: cgPoint)
        caShapeLayer.path = cgPath
        layer.addSublayer(caShapeLayer)
    }
}

// MARK: - Static

extension UIView {
    
    static func heightForView(text: String,
                              font: UIFont,
                              width: CGFloat) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byCharWrapping
        label.font = font
        
        let attrString = NSMutableAttributedString(string: text)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 2 // change line spacing between paragraph like 36 or 48
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSMakeRange(0, attrString.length))
        label.attributedText = attrString
        // label.text = text
        label.sizeToFit()
        return label.frame.height
    }
}

fileprivate final class ClickListener: UITapGestureRecognizer {
    var onClick : (([String:Any]?) -> Void)?
    var userInfo: [String:Any]?
    init(target: Any?, action: Selector?, userInfo: [String:Any]? = nil, onClick: (([String:Any]?) -> Void)?) {
        self.userInfo = userInfo
        self.onClick = onClick
        super.init(target: target, action: action)
    }
}

fileprivate extension CALayer {
    func makeSnapshot() -> UIImage? {
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(frame.size, false, scale)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        render(in: context)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        return screenshot
    }
}
