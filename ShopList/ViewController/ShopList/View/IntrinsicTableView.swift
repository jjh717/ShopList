//
//  IntrinsicTableView.swift
//  ShopList
//
//  Created by Louis on 2022/11/29.
//

import Foundation
import UIKit

class IntrinsicTableView: UITableView {
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
