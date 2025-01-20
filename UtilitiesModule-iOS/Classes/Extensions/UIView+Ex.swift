//
//  UIView+Ex.swift
//  UtilitiesModule-iOS
//
//  Created by ITD-Latt Chanon on 26/12/24.
//

import UIKit
import SnapKit

// MARK: - Initializer

extension UIView {
    convenience init(_ color: UIColor) {
        self.init()
        chainableBackgroundColor(color)
    }
    
    convenience init<T>(_ object: inout T?) {
        self.init()
        chainableReferenceTo(&object)
    }
}

// MARK: - General

public extension UIView {
    
    func enableUserInteraction() {
        isUserInteractionEnabled = true
    }
    
    func disableUserInteraction() {
        isUserInteractionEnabled = false
    }
    
    func scaleToFitSelfSize() {
        bounds.size = fittedSelfSize()
    }
    
    func fittedSelfSize() -> CGSize {
        setNeedsLayout()
        layoutIfNeeded()
        let rec = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return CGSize(width: rec.width, height: rec.height)
    }
    
    func radiusCorners(_ corners: CACornerMask, radius: CGFloat) {
        layer.maskedCorners = corners
        self.cornerRadius = radius
    }
    
    func toCircleRadius() {
        DispatchQueue.main.async { [unowned self] in
            cornerRadius = height * 0.5
        }
    }
    
    var cornerRadius: CGFloat {
        get {
            if let background = (self as? UIStackView)?.stackBackgroundView {
                return background.cornerRadius
            } else {
                return layer.cornerRadius
            }
        }
        
        set {
            if let background = (self as? UIStackView)?.stackBackgroundView {
                background.cornerRadius = newValue
                background.clipsToBounds = true
            } else {
                layer.cornerRadius = newValue
                clipsToBounds = true
            }
        }
    }
    
    var borderWidth: CGFloat {
        get {
            if let background = (self as? UIStackView)?.stackBackgroundView {
                return background.borderWidth
            } else {
                return layer.borderWidth
            }
        }
        set {
            if let background = (self as? UIStackView)?.stackBackgroundView {
                background.borderWidth = newValue
            } else {
                layer.borderWidth = newValue
            }
        }
    }
    
    var borderColor: UIColor? {
        get {
            if let background = (self as? UIStackView)?.stackBackgroundView {
                return background.borderColor
            } else {
                return layer.borderColor == nil ? nil : UIColor(cgColor: layer.borderColor!)
            }
        }
        
        set {
            if let background = (self as? UIStackView)?.stackBackgroundView {
                background.borderColor = newValue
            } else {
                layer.borderColor = newValue?.cgColor
            }
        }
    }
    
    var isNotHidden: Bool {
        get {
            !isHidden
        }
        
        set {
            isHidden = !newValue
        }
    }
    
    func showByAlpha(_ show: Bool = true) {
        alpha = show ? 1 : 0
    }
    
    func hideByAlpha(_ hide: Bool = true) {
        alpha = hide ? 0 : 1
    }
    
    func showSelf() {
        if isHidden {
            isHidden = false
        }
    }
    
    func hideSelf() {
        if !isHidden {
            isHidden = true
        }
    }
    
    var width: CGFloat {
        frame.width
    }
    
    var height: CGFloat {
        frame.height
    }
    
    var x: CGFloat {
        frame.origin.x
    }
    
    var y: CGFloat {
        frame.origin.y
    }
    
    var maxX: CGFloat {
        frame.maxX
    }
    
    var maxY: CGFloat {
        frame.maxY
    }
    func setHeight(_ h: CGFloat) {
        frame.size.height = h
    }
    
    func setWidth(_ w: CGFloat) {
        frame.size.width = w
    }
    
    func setX(_ x: CGFloat) {
        frame.origin.x = x
    }
    
    func setY(_ y: CGFloat) {
        frame.origin.y = y
    }
    
    func click(handler: @escaping ()->Void ) {
        let tap = TapGesture(target: self, action: #selector(didTapCallback(_:)))
        tap.handler = handler
        
        isUserInteractionEnabled = true
        addGestureRecognizer(tap)
    }
    
    func assignTo<T>(_ object: inout T?) {
        object = self as? T
    }
    
    func addToSuperView(_ view: UIView?, at index: Int? = nil) {
        if let index {
            view?.insertSubview(self, at: index)
        } else {
            view?.addSubview(self)
        }
    }
    
    func applyShadow(shadowColor: UIColor = .black.withAlphaComponent(0.08),
                     opacity: Float = 1,
                     offset: CGPoint = CGPoint(x: 1, y: 1),
                     cornerRadius: CGFloat = 6.0) {
        layer.frame = bounds
        layer.masksToBounds = false
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = CGSize(width: offset.x, height: offset.y)
        layer.shadowRadius = cornerRadius
    }
    
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

// MARK: - Chainable + Layout

extension UIView {
    
    @discardableResult
    func chainableFrame(_ frame: CGRect) -> Self {
        self.frame = frame
        return self
    }
    
    @discardableResult
    func chainableRemoveConstraints() -> Self {
        snp.removeConstraints()
        return self
    }
    
    /// Pin child Horizontal Center stack view
    @discardableResult
    func chainablePinTopBottomToStackView() -> Self {
        chainableAwaitMakeConstraints {
            $0.top.bottom.equalToSuperview()
        }
        return self
    }
    
    /// Pin child Horizontal Center stack view
    @discardableResult
    func chainablePinTopToStackView() -> Self {
        chainableAwaitMakeConstraints {
            $0.top.equalToSuperview()
        }
        return self
    }
    
    /// Pin child of Horizontal Center stack view
    @discardableResult
    func chainablePinBottomToStackView() -> Self {
        chainableAwaitMakeConstraints {
            $0.bottom.equalToSuperview()
        }
        return self
    }
    
    /// Wait until child has superview first
    @discardableResult
    func chainableAwaitMakeConstraints(_ constraints: @escaping (ConstraintMaker) -> Void) -> Self {
        DispatchQueue.main.async { [unowned self] in
            guard superview.isNotNil else {
                return
            }
            snp.makeConstraints(constraints)
        }
        return self
    }
    
    @discardableResult
    func chainableMakeConstraints(_ constraints: (ConstraintMaker) -> Void) -> Self {
        snp.makeConstraints(constraints)
        return self
    }
    
    @discardableResult
    func chainableUpdateConstraints(_ constraints: (ConstraintMaker) -> Void) -> Self {
        snp.updateConstraints(constraints)
        return self
    }
    
    @discardableResult
    func chainableSize(_ size: CGSize) -> Self {
        snp.makeConstraints {
            $0.size.equalTo(size)
        }
        return self
    }
    
    @discardableResult
    func chainableSize(_ size: CGFloat) -> Self {
        snp.makeConstraints {
            $0.size.equalTo(size)
        }
        return self
    }
    
    @discardableResult
    func chainableWidth(_ width: CGFloat) -> Self {
        snp.makeConstraints {
            $0.width.equalTo(width)
        }
        return self
    }
    
    @discardableResult
    func chainableHeight(_ height: CGFloat) -> Self {
        snp.makeConstraints {
            $0.height.equalTo(height).priority(999)
        }
        return self
    }
    
    @discardableResult
    func chainableLeadingEqualToSuperView(_ inset: CGFloat = 0.0) -> Self {
        snp.makeConstraints {
            $0.leading.equalToSuperview().inset(inset)
        }
        return self
    }
    
    @discardableResult
    func chainableTrailingEqualToSuperView(_ inset: CGFloat = 0.0) -> Self {
        snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(inset)
        }
        return self
    }
    
    @discardableResult
    func chainableTopEqualToSuperView(_ inset: CGFloat = 0.0) -> Self {
        snp.makeConstraints {
            $0.top.equalToSuperview().inset(inset)
        }
        return self
    }
    
    @discardableResult
    func chainableTopMarginEqualToSuperView(_ inset: CGFloat = 0.0) -> Self {
        snp.makeConstraints {
            if let superViewMarginTopConstraint = superview?.layoutMarginsGuide.snp.top {
                $0.top.equalTo(superViewMarginTopConstraint).inset(inset)
            } else {
                $0.top.equalToSuperview().inset(inset)
            }
        }
        return self
    }
    
    @discardableResult
    func chainableBottomEqualToSuperView(_ inset: CGFloat = 0.0) -> Self {
        snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(inset)
        }
        return self
    }
    
    @discardableResult
    func chainableBottomMarginEqualToSuperView(_ inset: CGFloat = 0.0) -> Self {
        snp.makeConstraints {
            if let superViewMarginBottomConstraint = superview?.layoutMarginsGuide.snp.bottom {
                $0.bottom.equalTo(superViewMarginBottomConstraint).inset(inset)
            } else {
                $0.bottom.equalToSuperview().inset(inset)
            }
        }
        return self
    }
    
    @discardableResult
    func chainableEdgesEqualToSuperView(_ inset: CGFloat = 0) -> Self {
        snp.makeConstraints {
            $0.edges.equalToSuperview().inset(inset)
        }
        return self
    }
    
    @discardableResult
    func chainableEdgesEqualToSuperView(left: CGFloat = 0, right: CGFloat = 0, top: CGFloat = 0, bottom: CGFloat = 0) -> Self {
        snp.makeConstraints {
            $0.leading.equalToSuperview().inset(left)
            $0.top.equalToSuperview().inset(top)
            $0.trailing.equalToSuperview().inset(right)
            $0.bottom.equalToSuperview().inset(bottom)
        }
        return self
    }
    
    @discardableResult
    func chainableMarginsEqualToSuperView(_ inset: CGFloat = 0) -> Self {
        snp.makeConstraints {
            if let superViewMarginTopConstraint = superview?.layoutMarginsGuide.snp.top {
                $0.top.equalTo(superViewMarginTopConstraint).inset(inset)
            } else {
                $0.top.equalToSuperview().inset(inset)
            }
            if let superViewMarginBottomConstraint = superview?.layoutMarginsGuide.snp.bottom {
                $0.bottom.equalTo(superViewMarginBottomConstraint).inset(inset)
            } else {
                $0.bottom.equalToSuperview().inset(inset)
            }
            $0.leading.trailing.equalToSuperview().inset(inset)
        }
        return self
    }
}

// MARK: - Chainable + Helpers

public extension UIView {
    
    enum GradientDirection {
        case leftToRight
        case rightToLeft
        case topToBottom
        case bottomToTop
    }
    
    @discardableResult
    func gradientBackground(from color1: UIColor,
                            to color2: UIColor,
                            direction: GradientDirection) -> Self {
        let gradient = CAGradientLayer()
        gradient.colors = [color1.cgColor, color2.cgColor]
        
        switch direction {
        case .leftToRight:
            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
            
        case .rightToLeft:
            gradient.startPoint = CGPoint(x: 1.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 0.0, y: 0.5)
            
        case .bottomToTop:
            gradient.startPoint = CGPoint(x: 0.5, y: 1.0)
            gradient.endPoint = CGPoint(x: 0.5, y: 0.0)
            
        default:
            break
        }
        
        DispatchQueue.main.async {
            gradient.frame = self.bounds
            if let stack = self as? UIStackView {
                stack.layer.insertSublayer(gradient, at: 0)
            } else {
                self.layer.insertSublayer(gradient, at: 0)
            }
        }
        return self
    }
    
    @discardableResult
    func chainableSendSelfToBackInSuperView() -> Self {
        superview?.sendSubviewToBack(self)
        return self
    }
    
    @discardableResult
    func chainableEnableUserInteraction() -> Self {
        isUserInteractionEnabled = true
        return self
    }
    
    @discardableResult
    func chainableDisableUserInteraction() -> Self {
        isUserInteractionEnabled = false
        return self
    }
    
    @discardableResult
    func chainableApplyShadow(shadowColor: UIColor = .black.withAlphaComponent(0.08),
                              opacity: Float = 1,
                              offset: CGPoint = CGPoint(x: 1, y: 1),
                              cornerRadius: CGFloat = 4.0) -> Self {
        applyShadow(shadowColor: shadowColor,
                    opacity: opacity,
                    offset: offset,
                    cornerRadius: cornerRadius)
        return self
    }
    
    @discardableResult
    func chainableClick(_ handler: @escaping ()->Void) -> Self {
        click(handler: handler)
        return self
    }
    
    @discardableResult
    func chainableClipToBounds(_ clip: Bool = true) -> Self {
        clipsToBounds = clip
        return self
    }
    
    @discardableResult
    func chainableContentMode(_ contentMode: ContentMode) -> Self {
        self.contentMode = contentMode
        return self
    }
    
    @discardableResult
    func chainableBackgroundColor(_ color: UIColor) -> Self {
        if let stack = self as? UIStackView {
            stack.setStackBackgroundColor(color: color)
        } else {
            backgroundColor = color
        }
        return self
    }
    
    @discardableResult
    func chainableAlpha(_ alpha: CGFloat) -> Self {
        self.alpha = alpha
        return self
    }
    
    @discardableResult
    func chainableHiddenSelf(_ hidden: Bool = true) -> Self {
        isHidden = hidden
        return self
    }
    
    @discardableResult
    func chainableHiddenOpacity(_ hidden: Bool = true) -> Self {
        alpha = hidden ? 0.0 : 1
        return self
    }
    
    @discardableResult
    func chainableTintColor(_ color: UIColor) -> Self {
        tintColor = color
        return self
    }
    
    @discardableResult
    func chainableCornerRadius(_ radius: CGFloat) -> Self {
        cornerRadius = radius
        return self
    }
    
    @discardableResult
    func chainableRoundCorners(radius: Double, corners: UIRectCorner) -> Self {
        roundCorners(corners, radius: radius)
        return self
    }
    
    @discardableResult
    func chainableBorderWidth(_ width: CGFloat) -> Self {
        borderWidth = width
        return self
    }
    
    @discardableResult
    func chainableBorderColor(_ color: UIColor) -> Self {
        borderColor = color
        return self
    }
    
    @discardableResult
    func chainableToCircleRadius(by radius: CGFloat? = nil) -> Self {
        if let radius {
            cornerRadius = radius * 0.5
        } else {
            toCircleRadius()
        }
        return self
    }
    
    @discardableResult
    func chainableReferenceTo<T>(_ object: inout T?) -> Self {
        assignTo(&object)
        return self
    }
    
    @discardableResult
    func chainableAddToSuperView(_ superView: UIView?, at index: Int? = nil) -> Self {
        addToSuperView(superView, at: index)
        return self
    }
    
    @discardableResult
    func chainableAddToSuperView(_ superView: UIView?, above subview: UIView) -> Self {
        superView?.insertSubview(self, aboveSubview: subview)
        return self
    }
    
    @discardableResult
    func chainableAddToSuperView(_ superView: UIView?, bellow subview: UIView) -> Self {
        superView?.insertSubview(self, belowSubview: subview)
        return self
    }
    
    @discardableResult
    func chainableHorizontalContentHuggingPriority(_ priority: UILayoutPriority) -> Self {
        setContentHuggingPriority(priority, for: .horizontal)
        return self
    }
    
    @discardableResult
    func chainableHorizontalContentHuggingLowPriority() -> Self {
        setContentHuggingPriority(.defaultLow, for: .horizontal)
        return self
    }
    
    @discardableResult
    func chainableHorizontalContentHuggingHighPriority() -> Self {
        setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return self
    }
    
    @discardableResult
    func chainableHorizontalContentHuggingRequiredPriority() -> Self {
        setContentHuggingPriority(.required, for: .horizontal)
        return self
    }
    
    @discardableResult
    func chainableVerticalContentHuggingPriority(_ priority: UILayoutPriority) -> Self {
        setContentHuggingPriority(priority, for: .vertical)
        return self
    }
    
    @discardableResult
    func chainableVerticalContentHuggingLowPriority() -> Self {
        setContentHuggingPriority(.defaultLow, for: .vertical)
        return self
    }
    
    @discardableResult
    func chainableVerticalContentHuggingHighPriority() -> Self {
        setContentHuggingPriority(.defaultHigh, for: .vertical)
        return self
    }
    
    @discardableResult
    func chainableVerticalContentHuggingRequiredPriority() -> Self {
        setContentHuggingPriority(.required, for: .vertical)
        return self
    }
    
    @discardableResult
    func chainableHorizontalContentCompressionPriority(_ priority: UILayoutPriority) -> Self {
        setContentCompressionResistancePriority(priority, for: .horizontal)
        return self
    }
    
    @discardableResult
    func chainableHorizontalContentCompressionLowPriority() -> Self {
        setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return self
    }
    
    @discardableResult
    func chainableHorizontalContentCompressionHighPriority() -> Self {
        setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return self
    }
    
    @discardableResult
    func chainableHorizontalContentCompressionRequiredPriority() -> Self {
        setContentCompressionResistancePriority(.required, for: .horizontal)
        return self
    }
    
    @discardableResult
    func chainableVerticalContentCompressionPriority(_ priority: UILayoutPriority) -> Self {
        setContentCompressionResistancePriority(priority, for: .vertical)
        return self
    }
    
    @discardableResult
    func chainableVerticalContentCompressionLowPriority() -> Self {
        setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return self
    }
    
    @discardableResult
    func chainableVerticalContentCompressionHighPriority() -> Self {
        setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        return self
    }
    
    @discardableResult
    func chainableVerticalContentCompressionRequiredPriority() -> Self {
        setContentCompressionResistancePriority(.required, for: .vertical)
        return self
    }
}

// MARK: - Static

public extension UIView {
    
    static var identifier: String {
        return String(describing: self)
    }
    
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

// MARK: - gesture on UIView

private extension UIView {
    @objc func didTapCallback(_ sender: TapGesture) {
        sender.handler()
    }
}

private class TapGesture: UITapGestureRecognizer {
    var handler: ()->Void = {}
}
