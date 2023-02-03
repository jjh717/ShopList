//
//  String-extension.swift
//  ShopList
//
//  Created by Louis on 2022/11/27.
//

import Foundation

extension String {
    var getShopName: String? {
        let url = URL(string: self)
        guard let host = url?.host else { return nil }
        
        let hostArr = host.components(separatedBy: ".")
        for value in hostArr {
            if value.lowercased() != "www" {
                return value
            }
        }
        
        return nil
    }
}

extension Int {
    func getAgeTag(ageTagList: [Int]) -> String {
        var result = ""
        if ageTagList.contains(0) {
            result = "10대"
        }
        
        var isTwenties = false
        if ageTagList.contains(1) {
            isTwenties = true
        } else if ageTagList.contains(2) {
            isTwenties = true
        } else if ageTagList.contains(3) {
            isTwenties = true
        }
        
        if isTwenties {
            result += " 20대"
        }
        
        var isThirties = false
        if ageTagList.contains(4) {
            isThirties = true
        } else if ageTagList.contains(5) {
            isThirties = true
        } else if ageTagList.contains(6) {
            isThirties = true
        }
        
        if isThirties {
            result += " 30대"
        }
        
        return result
    }
}
