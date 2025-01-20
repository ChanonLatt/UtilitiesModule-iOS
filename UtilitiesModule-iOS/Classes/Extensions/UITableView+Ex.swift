//
//  UITableView+Ex.swift
//  UtilitiesModule-iOS
//
//  Created by ITD-Latt Chanon on 27/12/24.
//

import UIKit

// MARK: - General

public extension UITableView {
    
    func reloadTableSizeWithAnimate(_ statement: (() -> Void)? = nil) {
        beginUpdates()
        statement?()
        endUpdates()
    }
    
    func reloadTableSizeWithoutAnimate(_ statement: (() -> Void)? = nil) {
        UITableView.performWithoutAnimation {
            beginUpdates()
            statement?()
            endUpdates()
        }
    }
    
    func reloadDataWithoutAnimate() {
        UITableView.performWithoutAnimation {
            beginUpdates()
            reloadData()
            endUpdates()
        }
    }
    
    func scrollTopTop(animated: Bool = true) {
        scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: animated)
    }
    
    func removeTableHeaderTopPadding() {
        if #available(iOS 15, *) {
            sectionHeaderTopPadding = .zero
        }
    }
    
    func registerNibs(_ cells: [UITableViewCell.Type]) {
        cells.forEach({ registerNib($0.self) })
    }
    
    func registerNib(_ cell: UITableViewCell.Type) {
        if let nibPath = Bundle.main.path(forResource: cell.identifier, ofType: "nib") {
            register(UINib(nibName: cell.identifier, bundle: nil), forCellReuseIdentifier: cell.identifier)
        } else {
            registerCell(cell.self)
        }
    }
    
    func registerCells(_ cells: [UITableViewCell.Type]) {
        cells.forEach({
            registerCell($0.self)
        })
    }
    
    func registerCell(_ cell: UITableViewCell.Type) {
        register(cell.self, forCellReuseIdentifier: cell.identifier)
    }
    
    func register<T: UITableViewCell>(cell: T.Type) {
        register(UINib(nibName: cell.identifier, bundle: nil), forCellReuseIdentifier: T.identifier)
    }
    // swiftlint:disable force_cast
    func dequeue<T: UITableViewCell>(withType type: T.Type) -> T {
        dequeueReusableCell(withIdentifier: type.identifier) as! T
    }
    
    // Variable-height UITableView tableHeaderView with autolayout
    func layoutTableHeaderView(defaultHeight: Double? = nil) {
        guard let headerView = self.tableHeaderView else { return }
        headerView.translatesAutoresizingMaskIntoConstraints = false
        let headerWidth = headerView.bounds.size.width
        let temporaryWidthConstraint = headerView.widthAnchor.constraint(equalToConstant: headerWidth)
        
        headerView.addConstraint(temporaryWidthConstraint)
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        
        let headerSize = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        var actualHeight = headerSize.height
        if let defaultHeight {
            actualHeight = actualHeight < defaultHeight ? defaultHeight : actualHeight
        }
        var frame = headerView.frame
        frame.size.height = actualHeight
        headerView.frame = frame
        
        self.tableHeaderView = headerView
        
        headerView.removeConstraint(temporaryWidthConstraint)
        headerView.translatesAutoresizingMaskIntoConstraints = true
    }
    
    func setEmptyMessage(_ message: String) {
        
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 50))
        UIView.transition(with: messageLabel,
                          duration: 0.25,
                          options: .transitionCrossDissolve,
                          animations: {
            messageLabel.text = message
        }, completion: nil)
        messageLabel.textColor = UIColor.gray
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "PublicSans-Bold", size: 15.0)
        messageLabel.sizeToFit()
        self.backgroundView = messageLabel;
        self.separatorStyle = .none;
    }
    func setEmptyMessage1(_ message: String) {
        let messageLabel = CustomLabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 50))
        UIView.transition(with: messageLabel,
                          duration: 0.25,
                          options: .transitionCrossDissolve,
                          animations: {
            messageLabel.text = message
        }, completion: nil)
        messageLabel.textColor = UIColor(red: 0.17, green: 0.51, blue: 0.75, alpha: 1)
        messageLabel.numberOfLines = 0;
        messageLabel.alpha = 0.52
        messageLabel.textAlignment = .left;
        messageLabel.font = UIFont(name: "PublicSans-Bold", size: 15.0)
        messageLabel.sizeToFit()
        self.backgroundView = messageLabel;
        self.separatorStyle = .none;
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
    
    public func reloadData(_ completion: @escaping ()->()) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }, completion:{ _ in
            completion()
        })
    }
    
    func scroll(to: ScrollDirection, animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            let numberOfSections = self.numberOfSections
            let numberOfRows = self.numberOfRows(inSection: numberOfSections-1)
            switch to{
            case .top:
                if numberOfRows > 0 {
                    let indexPath = IndexPath(row: 0, section: 0)
                    self.scrollToRow(at: indexPath, at: .top, animated: animated)
                }
                break
            case .bottom:
                if numberOfRows > 0 {
                    let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
                    self.scrollToRow(at: indexPath, at: .bottom, animated: animated)
                }
                break
            }
        }
    }
    
    func showActivityIndicator() {
        DispatchQueue.main.async {
            if #available(iOS 13.0, *) {
                let activityView = UIActivityIndicatorView(style: .medium)
                self.backgroundView = activityView
                activityView.color = .init(hexString: "#008348")
                activityView.startAnimating()
            } else {
                let activityView = UIActivityIndicatorView.init(style: .whiteLarge)
                activityView.color = .init(hexString: "#008348")
                self.backgroundView = activityView
                activityView.startAnimating()
            }
        }
    }
    
    func hideActivityIndicator() {
        DispatchQueue.main.async {
            self.backgroundView = nil
        }
    }
    
    func indicatorView() -> UIActivityIndicatorView{
        var activityIndicatorView = UIActivityIndicatorView()
        if self.tableFooterView == nil {
            let indicatorFrame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 80)
            activityIndicatorView = UIActivityIndicatorView(frame: indicatorFrame)
            activityIndicatorView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
            
            if #available(iOS 13.0, *) {
                activityIndicatorView.style = .large
            } else {
                // Fallback on earlier versions
                activityIndicatorView.style = .whiteLarge
            }
            
            activityIndicatorView.color = .systemPink
            activityIndicatorView.hidesWhenStopped = true
            
            self.tableFooterView = activityIndicatorView
            return activityIndicatorView
        }
        else {
            return activityIndicatorView
        }
    }
    
    func addLoading(_ indexPath:IndexPath, closure: @escaping (() -> Void)){
        indicatorView().startAnimating()
        if let lastVisibleIndexPath = self.indexPathsForVisibleRows?.last {
            if indexPath == lastVisibleIndexPath && indexPath.row == self.numberOfRows(inSection: 0) - 1 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    closure()
                }
            }
        }
    }
    
    func stopLoading() {
        if self.tableFooterView != nil {
            self.indicatorView().stopAnimating()
            self.tableFooterView = nil
        }
        else {
            self.tableFooterView = nil
        }
    }
}

// MARK: - Chainable

public extension UITableView {
    
    @discardableResult
    func chainableSeparatorStyle(_ style: UITableViewCell.SeparatorStyle) -> Self {
        separatorStyle = style
        return self
    }
    
    @discardableResult
    func chainableRemoveTableHeaderTopPadding() -> Self {
        removeTableHeaderTopPadding()
        return self
    }
    
    @discardableResult
    func chainableRegisterCell(_ cell: UITableViewCell.Type) -> Self {
        registerNib(cell)
        return self
    }
    
    @discardableResult
    func chainableRegisterCells(_ cells: [UITableViewCell.Type]) -> Self {
        registerNibs(cells)
        return self
    }
    
    @discardableResult
    func chainableDelegate(_ delegate: UITableViewDelegate) -> Self {
        self.delegate = delegate
        return self
    }
    
    @discardableResult
    func chainableDataSource(_ datasource: UITableViewDataSource) -> Self {
        self.dataSource = datasource
        return self
    }
}

public extension UITableView {
    
    enum ScrollDirection {
        case top, bottom
    }
    
    class CustomLabel: UILabel{
        public override func drawText(in rect: CGRect) {
            super.drawText(in: rect.inset(by: UIEdgeInsets.init(top: 0, left: 40, bottom: 0, right: 0)))
        }
    }
}
