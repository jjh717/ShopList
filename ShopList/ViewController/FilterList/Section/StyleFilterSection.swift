//
//  StyleFilterSection.swift
//  ShopList
//
//  Created by Louis on 2022/11/29.
//

import Foundation
import UIKit

final class StyleFilterSection: FilterBaseSection {
    var headerTitle: String?
    
    override func createLayout(itemCount: Int = 0) -> NSCollectionLayoutSection? {
        let contentInsets: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitem: item, count: 3)
        group.interItemSpacing = .fixed(5)
        
        // section
        let section = NSCollectionLayoutSection(group: group)
        
        if headerTitle != nil {
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            header.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            section.boundarySupplementaryItems.append(header)
        }
        section.interGroupSpacing = 5
        section.contentInsets = contentInsets
        section.supplementariesFollowContentInsets = false
        
        return section
    }
    
    override func supplementaryView(kind: String, for item: AnyHashable?, at indexPath: IndexPath, in collection: UICollectionView) -> UICollectionReusableView? {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let view = collection.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: String(describing: TitleSectionHeaderView.self),
                for: indexPath) as? TitleSectionHeaderView else {
                    return nil
            }
            
            view.backgroundColor = .lightGray
            view.setData(title: headerTitle ?? "")
             
            return view
        default:
            return nil
        }
    }
}
