//
//  UICollectionViewDiffableDataSource-extension.swift
//  ShopList
//
//  Created by Louis on 2022/11/29.
//

import Foundation
import UIKit

extension UICollectionViewDiffableDataSource {
 
    func replaceItems(_ items : [ItemIdentifierType], in section: SectionIdentifierType, isForceReloadSection: Bool = false) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            var currentSnapshot = self.snapshot()
                         
            guard currentSnapshot.indexOfSection(section) != nil else { return }
            
            let itemsOfSection = currentSnapshot.itemIdentifiers(inSection: section)
            currentSnapshot.deleteItems(itemsOfSection)
            currentSnapshot.appendItems(items, toSection: section)
            if isForceReloadSection {
                currentSnapshot.reloadSections([section])
            }
            if #available(iOS 15.0, *) {
                self.apply(currentSnapshot, animatingDifferences: false)
            } else {
                self.apply(currentSnapshot, animatingDifferences: true)
            }
        }
    }
}
