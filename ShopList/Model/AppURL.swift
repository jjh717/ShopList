//
//  URL.swift
//  ShopList
//
//  Created by Louis on 2022/11/27.
//

import Foundation

struct AppURL {
    func getImageUrl(_ shopName: String) -> String {
        return "https://cf.shop.s.zigzag.kr/images/\(shopName).jpg"
    }
}
