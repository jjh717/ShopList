//
//  UIButton-extension.swift
//  ShopList
//
//  Created by Louis on 2022/11/29.
//

import Foundation
import UIKit

extension UIButton {
    func setInsets(
        forContentPadding contentPadding: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
        imageTitlePadding: CGFloat) {
            self.contentEdgeInsets = UIEdgeInsets(
                top: contentPadding.top,
                left: contentPadding.left,
                bottom: contentPadding.bottom,
                right: contentPadding.right + imageTitlePadding
            )
            self.titleEdgeInsets = UIEdgeInsets(
                top: 0,
                left: imageTitlePadding,
                bottom: 0,
                right: -imageTitlePadding
            )
        }
}

