//
//  ShopListCell.swift
//  ShopList
//
//  Created by Louis on 2022/11/27.
//

import Foundation
import UIKit
import Kingfisher
import Then
import RxSwift
import RxCocoa

class ShopListCell: UITableViewCell {
      
    private let baseView = UIView()
    private let numberLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12)
        $0.textAlignment = .center
        $0.textColor = .black
        $0.sizeToFit()
    }
     
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textAlignment = .left
        $0.textColor = .black
    }
     
    private let shopImageView = UIImageView().then {
        $0.backgroundColor = .gray
    }
    
    private let tagListView = TagListView().then {
        $0.alignment = .left
    }

    deinit {
        print("\(self.classForCoder) deinit")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeUI()
        addSubView()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        shopImageView.kf.cancelDownloadTask()
        shopImageView.image = nil
        
        tagListView.removeAllTags()
    }
    
    private func makeUI() {
        selectionStyle = .none
        backgroundColor = .white
    }
    
    private func addSubView() {
        contentView.addSubview(baseView)
        
        baseView.addSubview(numberLabel)
        baseView.addSubview(shopImageView)
        baseView.addSubview(titleLabel)
        baseView.addSubview(tagListView)
    }
    
    private func setupConstraints() {
        baseView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10).priority(.high)
        }
        
        numberLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalTo(30)
        }
         
        let shopImageSize: CGFloat = 40
        shopImageView.snp.makeConstraints { make in
            make.size.equalTo(shopImageSize)
            make.centerY.equalToSuperview()
            make.left.equalTo(numberLabel.snp.right).offset(10)
        }
        
        shopImageView.roundCorner(value: shopImageSize / 2)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(shopImageView.snp.right).offset(10)
            make.right.equalToSuperview()
        }

        tagListView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.equalTo(shopImageView.snp.right).offset(10)
            make.right.bottom.equalToSuperview()
        }
    }
     
    func setData(index: Int, model: ShopInfo) {
        if let shopName = model.shopName {
            titleLabel.text = shopName
        }
     
        if let getShopName = model.shopUrl?.getShopName {
            let shopThumbnailUrl = AppURL().getImageUrl(getShopName)
            shopImageView.kf.setImage(with: URL(string: shopThumbnailUrl))
        }
 
        numberLabel.text = "\(index + 1)"
          
        if model.shopAgeGroup.count > 0 {
            makeAgeTag(shopAgeGroup: model.shopAgeGroup)
        }
         
        if model.shopStyle.count > 0 {
            makeStyleTag(shopStyle: model.shopStyle)
        }
    }
    
    func makeAgeTag(shopAgeGroup: [Int]) {
        let ageTag = Int().getAgeTag(ageTagList: shopAgeGroup)
        let ageTagView = TagView(title: ageTag)
        ageTagView.tagBackgroundColor = .white
        ageTagView.textFont = .systemFont(ofSize: 9)
        ageTagView.textColor = .black
        ageTagView.borderColor = .black
        ageTagView.borderWidth = 0.3
        tagListView.addTagView(ageTagView)
    }
    
    func makeStyleTag(shopStyle: [String]) {
        for style in shopStyle {
            let ageTagView = TagView(title: style)
            ageTagView.tagBackgroundColor = .white
            ageTagView.textFont = .systemFont(ofSize: 9)
            ageTagView.textColor = .black
            ageTagView.borderColor = .black
            ageTagView.borderWidth = 0.3
            tagListView.addTagView(ageTagView)
        }
    }
}
