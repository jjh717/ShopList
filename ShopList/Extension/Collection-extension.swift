//
//  Collection-extension.swift
//  ShopList
//
//  Created by Louis on 2022/11/26.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
