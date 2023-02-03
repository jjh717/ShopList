//
//  DeviceUIInfo.swift
//  ShopList
//
//  Created by Louis on 2022/11/29.
//

import Foundation
import UIKit

protocol DeviceUIInfo {
    
}

extension DeviceUIInfo {
    var statusBarHeight: CGFloat {
        var statusBarHeight: CGFloat = 0
            
        let window = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
        statusBarHeight = window?.safeAreaInsets.top ?? 0
        
        return statusBarHeight
    }
    
    var homeIndicatorHeight: CGFloat {
        var height: CGFloat = 0
            
        let window = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
        height = window?.safeAreaInsets.bottom ?? 0
        
        return height
    }
}
