//
//  FilterListNaviView.swift
//  ShopList
//
//  Created by Louis on 2022/11/29.
//
 
import Foundation
import UIKit
import SnapKit
import Then
import RxCocoa
import RxGesture

final class FilterListNaviView: UIView {
    var rxCustom: RxCustom {
        return RxCustom(base: self)
    }
    
    private let titleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 15)
        $0.sizeToFit()
        $0.text = "쇼핑몰 필터"
    }
    
    private let resetButton = UIButton().then {
        $0.setTitle("초기화", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 15)
        $0.setInsets(forContentPadding: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5), imageTitlePadding: 0)
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.roundCorner(color: .systemBlue, radius: 5, border: 1)
    }
    
    private let xButton = UIButton().then {
        $0.setImage(UIImage(systemName: "xmark"), for: .normal)
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
        addSubview(titleLabel)
        addSubview(resetButton)
        addSubview(xButton)
    }
    
    private func setupConstraints() {
        xButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.size.equalTo(30)
        }
        
        resetButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

extension FilterListNaviView {
    struct RxCustom {
        var resetButtonTap: ControlEvent<UITapGestureRecognizer> {
            return base.resetButton.rx.tapGesture()
        }
        
        var xButtonTap: ControlEvent<UITapGestureRecognizer> {
            return base.xButton.rx.tapGesture()
        }

        var base: FilterListNaviView
    }
}
