//
//  UICollectionView.swift
//  MusicFinder
//
//  Created by TRAING Serey on 26/03/2017.
//  Copyright © 2017 TRAING Serey. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func registerCellClass(cellClass: AnyClass) {
        let identifier = String(describing: cellClass)
        self.register(cellClass, forCellWithReuseIdentifier: identifier)
    }
    
    func registerCellNib(cellClass: AnyClass) {
        let identifier = String(describing: cellClass)
        let nib = UINib(nibName: identifier, bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: identifier)
    }
    
    func registerCellNib(cellClass: AnyClass, forSupplementaryViewOfKind: String) {
        let identifier = String(describing: cellClass)
        let nib = UINib(nibName: identifier, bundle: nil)
        self.register(nib, forSupplementaryViewOfKind: forSupplementaryViewOfKind, withReuseIdentifier: identifier)
    }
}
