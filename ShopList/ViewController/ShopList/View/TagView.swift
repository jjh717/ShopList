//
//  TagView.swift
//  ShopList
//
//  Created by Louis on 2022/11/29.
//

import Foundation
import UIKit

class TagView: UIButton {
    
    var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    var borderColor: UIColor? {
        didSet {
            reloadStyles()
        }
    }
    
    var textColor: UIColor = UIColor.white {
        didSet {
            reloadStyles()
        }
    }
    var selectedTextColor: UIColor = UIColor.white {
        didSet {
            reloadStyles()
        }
    }
    
    var titleLineBreakMode: NSLineBreakMode = .byTruncatingMiddle {
        didSet {
            titleLabel?.lineBreakMode = titleLineBreakMode
        }
    }
    
    var paddingY: CGFloat = 2 {
        didSet {
            titleEdgeInsets.top = paddingY
            titleEdgeInsets.bottom = paddingY
        }
    }
    
    var paddingX: CGFloat = 5 {
        didSet {
            titleEdgeInsets.left = paddingX
            updateRightInsets()
        }
    }
    
    var tagBackgroundColor: UIColor = UIColor.gray {
        didSet {
            reloadStyles()
        }
    }
    
    var highlightedBackgroundColor: UIColor? {
        didSet {
            reloadStyles()
        }
    }
    
    var selectedBorderColor: UIColor? {
        didSet {
            reloadStyles()
        }
    }
    
    var selectedBackgroundColor: UIColor? {
        didSet {
            reloadStyles()
        }
    }
    
    var textFont: UIFont = .systemFont(ofSize: 12) {
        didSet {
            titleLabel?.font = textFont
        }
    }
    
    private func reloadStyles() {
        if isHighlighted {
            if let highlightedBackgroundColor = highlightedBackgroundColor {
                backgroundColor = highlightedBackgroundColor
            }
        } else if isSelected {
            backgroundColor = selectedBackgroundColor ?? tagBackgroundColor
            layer.borderColor = selectedBorderColor?.cgColor ?? borderColor?.cgColor
            setTitleColor(selectedTextColor, for: UIControl.State())
        } else {
            backgroundColor = tagBackgroundColor
            layer.borderColor = borderColor?.cgColor
            setTitleColor(textColor, for: UIControl.State())
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            reloadStyles()
        }
    }
    
    override var isSelected: Bool {
        didSet {
            reloadStyles()
        }
    }
 
    // Handles Tap (TouchUpInside)
    var onTap: ((TagView) -> Void)?
    var onLongPress: ((TagView) -> Void)?
    
    // MARK: - init
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    public init(title: String) {
        super.init(frame: CGRect.zero)
        setTitle(title, for: UIControl.State())
        
        setupView()
    }
    
    private func setupView() {
        titleLabel?.lineBreakMode = titleLineBreakMode
        
        frame.size = intrinsicContentSize
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress))
        self.addGestureRecognizer(longPress)
    }
    
    @objc func longPress() {
        onLongPress?(self)
    }
    
    // MARK: - layout
    
    override var intrinsicContentSize: CGSize {
        var size = titleLabel?.text?.size(withAttributes: [NSAttributedString.Key.font: textFont]) ?? CGSize.zero
        size.height = textFont.pointSize + paddingY * 2
        size.width += paddingX * 2
        if size.width < size.height {
            size.width = size.height
        }
        
        return size
    }
    
    private func updateRightInsets() {
        titleEdgeInsets.right = paddingX
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

/// Swift < 4.2 support
#if !(swift(>=4.2))
private extension NSAttributedString {
    typealias Key = NSAttributedStringKey
}
private extension UIControl {
    typealias State = UIControlState
}
#endif
