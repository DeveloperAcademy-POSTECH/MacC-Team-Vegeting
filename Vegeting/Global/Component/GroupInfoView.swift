//
//  GroupInfo.swift
//  Vegeting
//
//  Created by kelly on 2022/10/25.
//

import UIKit

class GroupInfoView: UIStackView {
    var categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "맛집"
        return label
    }()
    
    var locationLabel: UILabel = {
        let label = UILabel()
        label.text = "서울시 동대문구"
        return label
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "12월 19일"
        return label
    }()
    
    var capacityLabel: UILabel = {
        let label = UILabel()
        label.text = "2/4"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setupLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        self.setHorizontalStack()
    }
    
    private func setupLayout() {
        [categoryLabel, locationLabel, dateLabel, capacityLabel].forEach {
           addArrangedSubviews($0)
        }
    }
}