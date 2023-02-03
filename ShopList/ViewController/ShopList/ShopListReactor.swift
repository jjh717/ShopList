//
//  ShopListReactor.swift
//  ShopList
//
//  Created by Louis on 2022/11/25.
//

import Foundation
import RxSwift
import ReactorKit

class ShopListReactor: Reactor {
    enum Action {
        case parseJson
        case applyFilter
        
        case resetFilter
        case selectedAgeFilter(index: Int)
        case selectedStyleFilter(index: Int)
        
        case setTempFilterData
    }
    
    enum Mutation {
        case setJsonResultData(model: ShopListResponse)
        case setFilterList(ageFilters: [Int], styleFilters: [String])
        case setShopListWithFilters(list: [ShopInfo])
        
        case clearSelectedFilterData
        
        case setSelectedAgeFilter(index: Int)
        case setSelectedStyleFilter(index: Int)
        
        case setTempFilterData
    }
    
    struct State {
        var jsonResult: ShopListResponse?
        var styleFilterList: [String]?
        var ageFilterList: [Int]?
        var shopListWithFilters: [ShopInfo]?
        var week: String?
        @Pulse var shouldTopScroll: Bool?
                
        var tempSelectedAgeFilters: Set<Int> = Set<Int>()
        var tempSelectedStyleFilters: Set<String> = Set<String>()
        
        var selectedAgeFilters: Set<Int> = Set<Int>()
        var selectedStyleFilters: Set<String> = Set<String>()
    }
    
    let initialState: State
    
    init() {
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .setTempFilterData:
            return .just(Mutation.setTempFilterData)
            
        case .parseJson:
            guard let path = Bundle.main.path(forResource: "shop_list", ofType: "json"),
                  let jsonString = try? String(contentsOfFile: path),
                  let data = jsonString.data(using: .utf8),
                  let model = try? JSONDecoder().decode(ShopListResponse.self, from: data),
                  var list = model.list else { return .empty() }
            
            let styleFilters = Set(list.flatMap { $0.shopStyle })
            let styleFilterArr = Array(styleFilters)
            let ageFilters = Set(list.flatMap { $0.shopAgeGroup })
            let ageFilterArr = Array(ageFilters).sorted { $0 < $1 }
            
            list = list.sorted { $0.shopScore > $1.shopScore }
            
            return .concat([.just(Mutation.setJsonResultData(model: model)),
                            .just(Mutation.setFilterList(ageFilters: ageFilterArr, styleFilters: styleFilterArr)),
                            .just(Mutation.setShopListWithFilters(list: list))])
            
        case .selectedAgeFilter(let filterTag):
            return .just(Mutation.setSelectedAgeFilter(index: filterTag))
            
        case .selectedStyleFilter(let filterTag):
            return .just(Mutation.setSelectedStyleFilter(index: filterTag))
          
        case .resetFilter:
            return .just(Mutation.clearSelectedFilterData)
            
        case .applyFilter:
            guard let shopList = currentState.jsonResult?.list else { return .empty() }
            
            if currentState.tempSelectedAgeFilters.count == 0,
                currentState.tempSelectedStyleFilters.count == 0 {
                
                let list = shopList.sorted { $0.shopScore > $1.shopScore }
                return .just(Mutation.setShopListWithFilters(list: list))
            }
             
            if currentState.tempSelectedStyleFilters.count > 0 {
                return findDataMatchesFilter(shopList: shopList)
            } else {
                return findDataMatchesAgeFilter(shopList: shopList)
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setJsonResultData(let model):
            newState.jsonResult = model
            newState.week = model.week
            
        case .setFilterList(let ageFilters, let styleFilters):
            newState.styleFilterList = styleFilters
            newState.ageFilterList = ageFilters
            
        case .setShopListWithFilters(let model):
            newState.shopListWithFilters = model
            newState.shouldTopScroll = true
            newState.selectedAgeFilters = state.tempSelectedAgeFilters
            newState.selectedStyleFilters = state.tempSelectedStyleFilters            
             
        case .clearSelectedFilterData:
            newState.tempSelectedAgeFilters.removeAll()
            newState.tempSelectedStyleFilters.removeAll()
            
            newState.selectedAgeFilters.removeAll()
            newState.selectedStyleFilters.removeAll()
            
        case .setSelectedAgeFilter(let index):
            if let ageFilterTag = currentState.ageFilterList?[safe: index] {
                if newState.tempSelectedAgeFilters.contains(ageFilterTag) {
                    newState.tempSelectedAgeFilters.remove(ageFilterTag)
                } else {
                    newState.tempSelectedAgeFilters.insert(ageFilterTag)
                }
            }
            
        case .setSelectedStyleFilter(let index):
            if let styleFilterTag = currentState.styleFilterList?[safe: index] {
                if newState.tempSelectedStyleFilters.contains(styleFilterTag) {
                    newState.tempSelectedStyleFilters.remove(styleFilterTag)
                } else {
                    newState.tempSelectedStyleFilters.insert(styleFilterTag)
                }
            }
        case .setTempFilterData:
            newState.tempSelectedAgeFilters = state.selectedAgeFilters
            newState.tempSelectedStyleFilters = state.selectedStyleFilters
        }
        
        return newState
    }
     
    private func findDataMatchesAgeFilter(shopList: [ShopInfo]) -> Observable<Mutation> {
        let selectedAgeFilter = currentState.tempSelectedAgeFilters
        var result = shopList.filter {
            let matchingAgeGroup = selectedAgeFilter.intersection($0.shopAgeGroup)
            return matchingAgeGroup.count != 0 ? true : false
        }
        
        result = result.sorted { $0.shopScore > $1.shopScore }
        return .just(Mutation.setShopListWithFilters(list: result))
    }
     
    private func findDataMatchesFilter(shopList: [ShopInfo]) -> Observable<Mutation> {
        var shopList = shopList
        let selectedAgeFilter = currentState.tempSelectedAgeFilters
        let selectedStyleFilter = currentState.tempSelectedStyleFilters
        
        shopList = shopList.compactMap { item -> ShopInfo? in
            if selectedAgeFilter.count > 0 {
                let matchingAgeGroup = selectedAgeFilter.intersection(item.shopAgeGroup)
                if matchingAgeGroup.count == 0 {
                    return nil
                }
            }
            
            let matchingStyle = Set(selectedStyleFilter).intersection(item.shopStyle)
            if matchingStyle.count > 0 {
                var shop = item
                shop.matchingLevel = matchingStyle.count
                return shop
            }
            return nil
        }
        
        shopList = shopList.sorted { $0.shopScore > $1.shopScore }.sorted { $0.matchingLevel > $1.matchingLevel }
                 
        return .just(Mutation.setShopListWithFilters(list: shopList))
    }
}
  
