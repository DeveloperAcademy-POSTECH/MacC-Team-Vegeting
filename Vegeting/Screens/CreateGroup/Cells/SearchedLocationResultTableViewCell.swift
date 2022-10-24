//
//  SearchedLocationResultTableViewCell.swift
//  Vegeting
//
//  Created by 최동권 on 2022/10/24.
//

import UIKit

class SearchedLocationResultTableViewCell: UITableViewCell {
    
    // MARK: - properties
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    // MARK: - init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    private func setupLayout() {
        addSubview(locationLabel)
        locationLabel.constraint(to: self)
    }
}
