//
//  UIView-extension.swift
//  ShopList
//
//  Created by Louis on 2022/11/27.
//

import Foundation
import UIKit

extension UIView {
    func roundCorner(value: CGFloat = 2.0) {
        layer.cornerRadius = value
        clipsToBounds = true
    }
    
    func roundCorner(color: UIColor, radius: CGFloat, border: CGFloat = 1.0) {
        self.roundCorner(value: radius)
        
        backgroundColor = .white
        layer.borderColor = color.cgColor
        layer.borderWidth = border
    }
}
