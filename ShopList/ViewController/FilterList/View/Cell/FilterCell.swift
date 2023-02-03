//
//  FilterCell.swift
//  ShopList
//
//  Created by Louis on 2022/11/29.
//

import Foundation
import UIKit
import Then
import SnapKit

class FilterCell: UICollectionViewCell {   
    private let baseView = UIView() 
    private let filterTagLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 11)
        $0.textAlignment = .center
        $0.backgroundColor = .clear
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeUI()
        addSubView()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        baseView.backgroundColor = .clear
    }
    
    private func makeUI() {
        backgroundColor = .white
        roundCorner(color: .black, radius: 5, border: 0.3)
    }

    private func addSubView() {
        contentView.addSubview(baseView)
        
        baseView.addSubview(filterTagLabel)
    }

    private func setupConstraints() {
        baseView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        filterTagLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setFilterName(filterName: String) {
        filterTagLabel.text = filterName
    }
}
