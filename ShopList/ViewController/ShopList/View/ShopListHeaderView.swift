//
//  ShopListHeaderView.swift
//  ShopList
//
//  Created by Louis on 2022/11/27.
//

import Foundation
import UIKit
import SnapKit
import Then
import RxCocoa
import RxGesture

final class ShopListHeaderView: UIView {
    var rxCustom: RxCustom {
        return RxCustom(base: self)
    }
    
    private let weekLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 13)
        $0.sizeToFit()
    }
    
    private let filterButton = UIButton().then {
        $0.setTitle("필터", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 15)
        $0.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        $0.setInsets(forContentPadding: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5), imageTitlePadding: 5)
        $0.setTitleColor(.systemBlue, for: .normal) 
        $0.roundCorner(color: .systemBlue, radius: 5, border: 1)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
         
        makeUI()
        addSubView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeUI() {
        backgroundColor = .white
    }
    
    private func addSubView() {
        addSubview(weekLabel)
        addSubview(filterButton)
    }
    
    private func setupConstraints() {
        weekLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        
        filterButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
    }
    
    public func setWeek(week: String) {
        weekLabel.text = week
    }
}


extension ShopListHeaderView {
    struct RxCustom {
        var filterButtonTap: ControlEvent<UITapGestureRecognizer> {
            return base.filterButton.rx.tapGesture()
        }
        
        var base: ShopListHeaderView
    }
}
