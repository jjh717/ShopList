//
//  FilterBaseSection.swift
//  ShopList
//
//  Created by Louis on 2022/11/29.
//

import Foundation
import UIKit

class FilterBaseSection: Hashable {
    
    enum ModuleName: String {
        case ageFilterSection
        case styleFilterSection
        
        var moduleIndex: Int {
            switch self {
            case .ageFilterSection: return 0
            case .styleFilterSection: return 1
            }
        }
    }
    
    let id: String
    let moduleName: ModuleName

    init(moduleName: ModuleName) {
        self.id = UUID().uuidString
        self.moduleName = moduleName
    }
    
    func createLayout(itemCount: Int = 0) -> NSCollectionLayoutSection? {
        return nil
    }
     
    func supplementaryView(kind: String, for item: AnyHashable?, at indexPath: IndexPath, in collection: UICollectionView) -> UICollectionReusableView? {
        return nil
    }
    
    static func == (lhs: FilterBaseSection, rhs: FilterBaseSection) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}






