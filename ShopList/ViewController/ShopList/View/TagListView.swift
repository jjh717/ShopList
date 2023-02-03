//
//  TagListView.swift
//  ShopList
//
//  Created by Louis on 2022/11/29.
//

import Foundation
import UIKit

@objc protocol TagListViewDelegate {
    @objc optional func tagPressed(_ title: String, tagView: TagView, sender: TagListView) -> Void    
}
 
class TagListView: UIView {
    
    var textColor: UIColor = .white {
        didSet {
            tagViews.forEach {
                $0.textColor = textColor
            }
        }
    }
    
    var selectedTextColor: UIColor = .white {
        didSet {
            tagViews.forEach {
                $0.selectedTextColor = selectedTextColor
            }
        }
    }
    
    var tagLineBreakMode: NSLineBreakMode = .byTruncatingMiddle {
        didSet {
            tagViews.forEach {
                $0.titleLineBreakMode = tagLineBreakMode
            }
        }
    }
    
    var tagBackgroundColor: UIColor = UIColor.gray {
        didSet {
            tagViews.forEach {
                $0.tagBackgroundColor = tagBackgroundColor
            }
        }
    }
    
    var tagHighlightedBackgroundColor: UIColor? {
        didSet {
            tagViews.forEach {
                $0.highlightedBackgroundColor = tagHighlightedBackgroundColor
            }
        }
    }
    
    var tagSelectedBackgroundColor: UIColor? {
        didSet {
            tagViews.forEach {
                $0.selectedBackgroundColor = tagSelectedBackgroundColor
            }
        }
    }
    
    var cornerRadius: CGFloat = 0 {
        didSet {
            tagViews.forEach {
                $0.cornerRadius = cornerRadius
            }
        }
    }
    var borderWidth: CGFloat = 0 {
        didSet {
            tagViews.forEach {
                $0.borderWidth = borderWidth
            }
        }
    }
    
    var borderColor: UIColor? {
        didSet {
            tagViews.forEach {
                $0.borderColor = borderColor
            }
        }
    }
    
    var selectedBorderColor: UIColor? {
        didSet {
            tagViews.forEach {
                $0.selectedBorderColor = selectedBorderColor
            }
        }
    }
    
    var paddingY: CGFloat = 2 {
        didSet {
            defer { rearrangeViews() }
            tagViews.forEach {
                $0.paddingY = paddingY
            }
        }
    }
    var paddingX: CGFloat = 5 {
        didSet {
            defer { rearrangeViews() }
            tagViews.forEach {
                $0.paddingX = paddingX
            }
        }
    }
    var marginY: CGFloat = 2 {
        didSet {
            rearrangeViews()
        }
    }
    var marginX: CGFloat = 5 {
        didSet {
            rearrangeViews()
        }
    }
    
    var minWidth: CGFloat = 0 {
        didSet {
            rearrangeViews()
        }
    }
    
    @objc enum Alignment: Int {
        case left
        case center
        case right
        case leading
        case trailing
    }
    
    var alignment: Alignment = .leading {
        didSet {
            rearrangeViews()
        }
    }
    var shadowColor: UIColor = .white {
        didSet {
            rearrangeViews()
        }
    }
    var shadowRadius: CGFloat = 0 {
        didSet {
            rearrangeViews()
        }
    }
    var shadowOffset: CGSize = .zero {
        didSet {
            rearrangeViews()
        }
    }
    var shadowOpacity: Float = 0 {
        didSet {
            rearrangeViews()
        }
    }
    
    @objc var textFont: UIFont = .systemFont(ofSize: 12) {
        didSet {
            defer { rearrangeViews() }
            tagViews.forEach {
                $0.textFont = textFont
            }
        }
    }
    
    weak var delegate: TagListViewDelegate?
    
    private(set) var tagViews: [TagView] = []
    private(set) var tagBackgroundViews: [UIView] = []
    private(set) var rowViews: [UIView] = []
    private(set) var tagViewHeight: CGFloat = 0
    private(set) var rows = 0 {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        defer { rearrangeViews() }
        super.layoutSubviews()
    }
    
    private func rearrangeViews() {
        let views = tagViews as [UIView] + tagBackgroundViews + rowViews
        views.forEach {
            $0.removeFromSuperview()
        }
        rowViews.removeAll(keepingCapacity: true)
        
        var isRtl: Bool = false
        
        if #available(iOS 10.0, tvOS 10.0, *) {
            isRtl = effectiveUserInterfaceLayoutDirection == .rightToLeft
        } else if let shared = UIApplication.value(forKey: "sharedApplication") as? UIApplication {
            isRtl = shared.userInterfaceLayoutDirection == .leftToRight
        }
        
        var alignment = self.alignment
        
        if alignment == .leading {
            alignment = isRtl ? .right : .left
        }
        else if alignment == .trailing {
            alignment = isRtl ? .left : .right
        }
        
        var currentRow = 0
        var currentRowView: UIView!
        var currentRowTagCount = 0
        var currentRowWidth: CGFloat = 0
        self.layoutIfNeeded()
        
        let frameWidth = frame.width 
        let directionTransform = isRtl
        ? CGAffineTransform(scaleX: -1.0, y: 1.0)
        : CGAffineTransform.identity
        
        for (index, tagView) in tagViews.enumerated() {
            tagView.frame.size = tagView.intrinsicContentSize
            tagViewHeight = tagView.frame.height
            
            if currentRowTagCount == 0 || currentRowWidth + tagView.frame.width > frameWidth {
                currentRow += 1
                currentRowWidth = 0
                currentRowTagCount = 0
                currentRowView = UIView()
                currentRowView.transform = directionTransform
                currentRowView.frame.origin.y = CGFloat(currentRow - 1) * (tagViewHeight + marginY)
                
                rowViews.append(currentRowView)
                addSubview(currentRowView)
                
                tagView.frame.size.width = min(tagView.frame.size.width, frameWidth)
            }
            
            let tagBackgroundView = tagBackgroundViews[index]
            tagBackgroundView.transform = directionTransform
            tagBackgroundView.frame.origin = CGPoint(
                x: currentRowWidth,
                y: 0)
            tagBackgroundView.frame.size = tagView.bounds.size
            tagView.frame.size.width = max(minWidth, tagView.frame.size.width)
            tagBackgroundView.layer.shadowColor = shadowColor.cgColor
            tagBackgroundView.layer.shadowPath = UIBezierPath(roundedRect: tagBackgroundView.bounds, cornerRadius: cornerRadius).cgPath
            tagBackgroundView.layer.shadowOffset = shadowOffset
            tagBackgroundView.layer.shadowOpacity = shadowOpacity
            tagBackgroundView.layer.shadowRadius = shadowRadius
            tagBackgroundView.addSubview(tagView)
            currentRowView.addSubview(tagBackgroundView)
            
            currentRowTagCount += 1
            currentRowWidth += tagView.frame.width + marginX
            
            switch alignment {
            case .leading: fallthrough // switch must be exahutive
            case .left:
                currentRowView.frame.origin.x = 0
            case .center:
                currentRowView.frame.origin.x = (frameWidth - (currentRowWidth - marginX)) / 2
            case .trailing: fallthrough // switch must be exahutive
            case .right:
                currentRowView.frame.origin.x = frameWidth - (currentRowWidth - marginX)
            }
            currentRowView.frame.size.width = currentRowWidth
            currentRowView.frame.size.height = max(tagViewHeight, currentRowView.frame.height)            
        }
        rows = currentRow
        invalidateIntrinsicContentSize()
    }
    
    // MARK: - Manage tags
    
    override var intrinsicContentSize: CGSize {
        var height = CGFloat(rows) * (tagViewHeight + marginY)
        if rows > 0 {
            height -= marginY
        }
        return CGSize(width: frame.width, height: height)
    }
    
    private func createNewTagView(_ title: String) -> TagView {
        let tagView = TagView(title: title)
        
        tagView.textColor = textColor
        tagView.selectedTextColor = selectedTextColor
        tagView.tagBackgroundColor = tagBackgroundColor
        tagView.highlightedBackgroundColor = tagHighlightedBackgroundColor
        tagView.selectedBackgroundColor = tagSelectedBackgroundColor
        tagView.titleLineBreakMode = tagLineBreakMode
        tagView.cornerRadius = cornerRadius
        tagView.borderWidth = borderWidth
        tagView.borderColor = borderColor
        tagView.selectedBorderColor = selectedBorderColor
        tagView.paddingX = paddingX
        tagView.paddingY = paddingY
        tagView.textFont = textFont
        
        tagView.addTarget(self, action: #selector(tagPressed(_:)), for: .touchUpInside)
        
        // On long press, deselect all tags except this one
        tagView.onLongPress = { [unowned self] this in
            self.tagViews.forEach {
                $0.isSelected = $0 == this
            }
        }
        
        return tagView
    }
    
    @discardableResult
    func addTag(_ title: String) -> TagView {
        defer { rearrangeViews() }
        return addTagView(createNewTagView(title))
    }
    
    @discardableResult
    func addTags(_ titles: [String]) -> [TagView] {
        return addTagViews(titles.map(createNewTagView))
    }
    
    @discardableResult
    func addTagView(_ tagView: TagView) -> TagView {
        defer { rearrangeViews() }
        tagViews.append(tagView)
        tagBackgroundViews.append(UIView(frame: tagView.bounds))
        
        return tagView
    }
    
    @discardableResult
    func addTagViews(_ tagViewList: [TagView]) -> [TagView] {
        defer { rearrangeViews() }
        tagViewList.forEach {
            tagViews.append($0)
            tagBackgroundViews.append(UIView(frame: $0.bounds))
        }
        return tagViews
    }
    
    @discardableResult
    func insertTag(_ title: String, at index: Int) -> TagView {
        return insertTagView(createNewTagView(title), at: index)
    }
    
    
    @discardableResult
    func insertTagView(_ tagView: TagView, at index: Int) -> TagView {
        defer { rearrangeViews() }
        tagViews.insert(tagView, at: index)
        tagBackgroundViews.insert(UIView(frame: tagView.bounds), at: index)
        
        return tagView
    }
    
    func setTitle(_ title: String, at index: Int) {
        tagViews[index].titleLabel?.text = title
    }
    
    func removeTag(_ title: String) {
        tagViews.reversed().filter({ $0.currentTitle == title }).forEach(removeTagView)
    }
    
    func removeTagView(_ tagView: TagView) {
        defer { rearrangeViews() }
        
        tagView.removeFromSuperview()
        if let index = tagViews.firstIndex(of: tagView) {
            tagViews.remove(at: index)
            tagBackgroundViews.remove(at: index)
        }
    }
    
    func removeAllTags() {
        defer {
            tagViews = []
            tagBackgroundViews = []
            rearrangeViews()
        }
        
        let views: [UIView] = tagViews + tagBackgroundViews
        views.forEach { $0.removeFromSuperview() }
    }
    
    func selectedTags() -> [TagView] {
        return tagViews.filter { $0.isSelected }
    }
    
    // MARK: - Events
    
    @objc func tagPressed(_ sender: TagView!) {
        sender.onTap?(sender)
        delegate?.tagPressed?(sender.currentTitle ?? "", tagView: sender, sender: self)
    }
}
