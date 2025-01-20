//
//  UIStackView+Ex.swift
//  UtilitiesModule-iOS
//
//  Created by ITD-Latt Chanon on 20/1/25.
//

import UIKit

// MARK: - General

public extension UIStackView {
    
    /// iOS Version under 13 needs to add new background, cannot set backgroundColor directly
    func setStackBackgroundColor(color: UIColor) {
        subviews.filter({$0 is UIStackViewBackground}).forEach({$0.removeFromSuperview()})
        let subView = UIStackViewBackground(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
    
    var stackBackgroundView: UIStackViewBackground? {
        return subviews.first(where: { $0 is UIStackViewBackground }) as? UIStackViewBackground
    }
    
    func addArrangedSubviews(with views: [UIView]) {
        views.forEach { view in
            self.addArrangedSubview(view)
        }
    }
    
    func set(elements: [UIView]) {
        for subview in arrangedSubviews {
            removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        
        append(elements: elements)
    }
    
    func append(elements: [UIView]) {
        addArrangedSubviews(with: elements)
    }
    
    class UIStackViewBackground: UIView {}
}

// MARK: - Chainable

public extension UIStackView {
    
    @discardableResult
    func set(@UIViewBuilder _ elements: () -> [UIView]) -> Self {
        set(elements: elements())
        return self
    }
    
    @discardableResult
    func append(@UIViewBuilder _ elements: () -> [UIView]) -> Self {
        append(elements: elements())
        return self
    }
    
    @discardableResult
    func chainableSpacing(_ space: CGFloat) -> Self {
        spacing = space
        return self
    }
    
    @discardableResult
    func chainableDistribution(_ distribute: Distribution) -> Self {
        distribution = distribute
        return self
    }
    
    @discardableResult
    func chainableFillDistribution() -> Self {
        distribution = .fill
        return self
    }
    
    @discardableResult
    func chainableFillEqutalDistribution() -> Self {
        distribution = .fillEqually
        return self
    }
    
    @discardableResult
    func chainableEqualCenteringDistribution() -> Self {
        distribution = .equalCentering
        return self
    }
    
    @discardableResult
    func chainableAlignment(_ align: Alignment) -> Self {
        alignment = align
        return self
    }
    
    @discardableResult
    func chainableFillAlignment() -> Self {
        alignment = .fill
        return self
    }
    
    @discardableResult
    func chainableLeadingAlignment() -> Self {
        alignment = .leading
        return self
    }
    
    @discardableResult
    func chainableTrailingAlignment() -> Self {
        alignment = .trailing
        return self
    }
    
    @discardableResult
    func chainableTopAlignment() -> Self {
        alignment = .top
        return self
    }
    
    @discardableResult
    func chainableBottomAlignment() -> Self {
        alignment = .bottom
        return self
    }
    
    @discardableResult
    func chainableCenterAlignment() -> Self {
        alignment = .center
        return self
    }
}

// MARK: - Custom view result builder

@resultBuilder
public struct UIViewBuilder {
    
    public typealias Expression = UIView
    public typealias Component = [UIView]
    
    public static func buildExpression(_ expression: Expression) -> Component {
        return [expression]
    }
    
    public static func buildExpression(_ expression: Component) -> Component {
        return expression
    }
    
    public static func buildExpression(_ expression: Expression?) -> Component {
        guard let expression = expression else { return [] }
        return [expression]
    }
    
    public static func buildBlock(_ children: Component...) -> Component {
        return children.flatMap { $0 }
    }
    
    public static func buildBlock(_ component: Component) -> Component {
        return component
    }
    
    public static func buildOptional(_ children: Component?) -> Component {
        return children ?? []
    }
    
    public static func buildEither(first child: Component) -> Component {
        return child
    }
    
    public static func buildEither(second child: Component) -> Component {
        return child
    }
    
    public static func buildArray(_ components: [Component]) -> Component {
        return components.flatMap { $0 }
    }
}
