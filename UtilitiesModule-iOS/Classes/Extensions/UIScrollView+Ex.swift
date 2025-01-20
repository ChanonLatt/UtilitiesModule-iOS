//
//  UIScrollView+Ex.swift
//  UtilitiesModule-iOS
//
//  Created by ITD-Latt Chanon on 26/12/24.
//

import UIKit

// MARK: - General

public extension UIScrollView {
    
    var isContentReachedTop: Bool {
        contentOffset.y <= .zero
    }
    
    var isContentReachedBottom: Bool {
        return (self.contentOffset.y + self.frame.height) >= self.contentSize.height
    }
    
    var shortContentHeight: Bool {
        contentSize.height < frame.height
    }
    
    var isContentAlmostReachedBottom: Bool {
        let currentOffset = contentOffset.y
        let maximumOffset = contentSize.height - frame.size.height
        let deltaOffset = maximumOffset - currentOffset
        return deltaOffset < 42.0
    }
    
    var isScrollingByHuman: Bool {
        isDragging || isDecelerating
    }
    
    func addTopBounceAreaView(color: UIColor = .white) {
        var frame = UIScreen.main.bounds
        frame.origin.y = -frame.size.height
        let view = UIView(frame: frame)
        view.backgroundColor = color
        self.addSubview(view)
    }
    
    func scrollToTop() {
        let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(desiredOffset, animated: true)
    }
}

// MARK: - Chainable

public extension UIScrollView {
    
    @discardableResult
    func chainableSetPaggingEnabled(_ enable: Bool = true) -> Self {
        isPagingEnabled = enable
        return self
    }
    
    @discardableResult
    func chainableKeyboardDismissMode(_ mode: KeyboardDismissMode) -> Self {
        keyboardDismissMode = mode
        return self
    }
    
    @discardableResult
    func chainableIsScrollEnabled(_ enable: Bool) -> Self {
        isScrollEnabled = enable
        return self
    }
    
    @discardableResult
    func chainableShowVerticalIndicator(_ show: Bool = true) -> Self {
        showsVerticalScrollIndicator = show
        return self
    }
    
    @discardableResult
    func chainableShowHorizontalIndicator(_ show: Bool = true) -> Self {
        showsHorizontalScrollIndicator = show
        return self
    }
    
    @discardableResult
    func chainableTopContentInset(_ inset: CGFloat) -> Self {
        contentInset.top = inset
        return self
    }
    
    @discardableResult
    func chainableBottomContentInset(_ inset: CGFloat) -> Self {
        contentInset.bottom = inset
        return self
    }
    
    @discardableResult
    func chainableContentInset(_ insets: UIEdgeInsets) -> Self {
        contentInset = insets
        return self
    }
}
