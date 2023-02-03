//
//  ShopListSectionModel.swift
//  ShopList
//
//  Created by Louis on 2022/11/27.
//

import Foundation
import RxDataSources

struct ShopListSectionModel: AnimatableSectionModelType {
    var index: Int
    var items: [ShopListCellModel]
    
    typealias Identity = Int
    typealias Item = ShopListCellModel
    
    var identity: Int {
        return index
    }
}

extension ShopListSectionModel {
    init(original: ShopListSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}

enum ShopListCellModel: IdentifiableType, Equatable {
    static func == (lhs: ShopListCellModel, rhs: ShopListCellModel) -> Bool {
        if lhs.identity == rhs.identity {
            return true
        }
        return false
    }
    
    typealias Identity = String
    
    var identity : Identity {
        switch self {
        case .shopList:
            return "shopList"
        }
    }
     
    case shopList(ShopInfo)
}


