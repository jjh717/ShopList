//
//  ShopInfo.swift
//  ShopList
//
//  Created by Louis on 2022/11/25.
//

import Foundation

struct ShopListResponse: Codable {
    let week: String?
    let list: [ShopInfo]?
}
 
struct ShopInfo: Codable {
    let shopName: String?
    let shopUrl: String?    
    var shopStyle: [String] = [String]()
    var shopScore: Int = 0
    var shopAgeGroup: [Int] = [Int]()
    var matchingLevel: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case shopName = "n"
        case shopUrl = "u"
        case shopStyle = "S"
        case shopScore = "0"
        case shopAgeGroup = "A"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        shopName = try container.decodeIfPresent(String.self, forKey: .shopName)
        shopUrl = try container.decodeIfPresent(String.self, forKey: .shopUrl)
       
        if let shopStyleStr = try container.decodeIfPresent(String.self, forKey: .shopStyle) {
            let shopStyleArr = shopStyleStr.split(separator: ",").map { String($0) }
            shopStyle = shopStyleArr
        }
        
        shopScore = try container.decodeIfPresent(Int.self, forKey: .shopScore) ?? 0
        
        if let ageGroup = try container.decodeIfPresent([Int].self, forKey: .shopAgeGroup) {
            let shopAgeGroupArr = ageGroup.enumerated().filter { $0.element == 1 }.compactMap { $0.offset }
            shopAgeGroup = shopAgeGroupArr
        }
    }
}
 
enum AgeTag: Int, Codable {
    case teenage
    case earlyTwenties
    case halfTwenties
    case lateTwenties
    case earlyThirties
    case halfThirties
    case lateThirties 
}





