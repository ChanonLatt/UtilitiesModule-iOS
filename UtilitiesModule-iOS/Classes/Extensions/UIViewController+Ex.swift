//
//  UIScrollView+Ex.swift
//  UtilitiesModule-iOS
//
//  Created by ITD-Latt Chanon on 26/12/24.
//

import UIKit

public extension UIViewController {
    
    func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChild(viewController)
        // Add Child View as Subview
        view.addSubview(viewController.view)
        view.sendSubviewToBack(viewController.view)
        // Define Constraints
        NSLayoutConstraint.activate([
            viewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            viewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            viewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        // Notify Child View Controller
        viewController.didMove(toParent: self)
    }

    func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParent: nil)
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        // Notify Child View Controller
        viewController.removeFromParent()
    }

    func fixBackgroundSegmentControl(_ segmentControl: UISegmentedControl) {
        if #available(iOS 13.0, *) {
            // Just to be sure it is full loaded
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                for i in 0 ... (segmentControl.numberOfSegments - 1) {
                    let backgroundSegmentView = segmentControl.subviews[i]
                    // It is not enogh changing the background color. It has some kind of shadow layer
                    backgroundSegmentView.isHidden = true
                }
            }
        }
    }
}
