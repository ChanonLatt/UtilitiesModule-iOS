//
//  UICollectionView+Ex.swift
//  UtilitiesModule-iOS
//
//  Created by ITD-Latt Chanon on 20/1/25.
//

import UIKit

// MARK: - General

public extension UICollectionView {
    
    func registerNibs(_ cells: [UICollectionViewCell.Type]) {
        cells.forEach({ registerNib($0.self) })
    }
    
    func registerNib(_ cell: UICollectionViewCell.Type) {
        if let nibPath = Bundle.main.path(forResource: cell.identifier, ofType: "nib") {
            register(UINib(nibName: cell.identifier, bundle: nil), forCellWithReuseIdentifier: cell.identifier)
        } else {
            registerCell(cell.self)
        }
    }
    
    func registerCells(_ cells: [UICollectionViewCell.Type]) {
        cells.forEach({
            registerCell($0.self)
        })
    }
    
    func registerCell(_ cell: UICollectionViewCell.Type) {
        register(cell.self, forCellWithReuseIdentifier: cell.identifier)
    }
    
    func register<T: UICollectionViewCell>(cell: T.Type) {
        register(UINib(nibName: cell.identifier, bundle: nil), forCellWithReuseIdentifier: T.identifier)
    }
    
    func dequeue<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        return (dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as? T)!
    }
    
    func dequeue<T: UICollectionViewCell>(for cellType: T.Type, at indexPath: IndexPath) -> T {
        return (dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as? T)!
    }
}

public extension Int {
    
    var atFirstSection: IndexPath {
        IndexPath(row: self, section: 0)
    }
}


// MARK: - Chainable

public extension UICollectionView {
    
    @discardableResult
    func chainableRegisterCell(_ cell: UICollectionViewCell.Type) -> Self {
        registerNib(cell)
        return self
    }
    
    @discardableResult
    func chainableRegisterCells(_ cells: [UICollectionViewCell.Type]) -> Self {
        registerNibs(cells)
        return self
    }
    
    @discardableResult
    func chainableDelegate(_ delegate: UICollectionViewDelegate) -> Self {
        self.delegate = delegate
        return self
    }
    
    @discardableResult
    func chainableDataSource(_ datasource: UICollectionViewDataSource) -> Self {
        self.dataSource = datasource
        return self
    }
}
