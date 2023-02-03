//
//  TitleSectionHeaderView.swift
//  ShopList
//
//  Created by Louis on 2022/11/29.
//

import UIKit

class TitleSectionHeaderView: UICollectionReusableView {
    
    let titleLabel = UILabel().then {
        $0.text = ""
        $0.textColor = .black
    }
    
    public override init(frame: CGRect) {
        super.init(frame: .zero)
         
        addSubview(titleLabel)
  
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
     
    }
    
    func setData(title: String) {
        titleLabel.text = title
    }
}

