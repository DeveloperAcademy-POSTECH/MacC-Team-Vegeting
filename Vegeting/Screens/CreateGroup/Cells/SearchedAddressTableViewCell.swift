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
    
    private lazy var placeLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        return label
    }()
    
    
    // MARK: - init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupLayoutForAddress()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    override func prepareForReuse() {
        locationLabel.text = ""
        placeLabel.text = ""
    }
    
    private func setupLayoutForAddress() {
        addSubview(locationLabel)
        locationLabel.constraint(top: self.topAnchor,
                                 leading: self.leadingAnchor,
                                 bottom: self.bottomAnchor,
                                 padding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 0))
    }
    
    private func setupLayoutForPlace() {
        self.addSubviews(placeLabel, locationLabel)
        placeLabel.constraint(top: self.topAnchor,
                              leading: self.leadingAnchor,
                              padding: UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 0))
        
        locationLabel.constraint(top: placeLabel.bottomAnchor,
                                 leading: self.leadingAnchor,
                                 bottom: self.bottomAnchor,
                                 padding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 0))
    }
    
    func configure(with address: Address) {
        locationLabel.text = address.addressName
        locationLabel.textColor = .black
        self.setupLayoutForAddress()
        print(address, "하이")
        print(locationLabel.text, placeLabel.text, "하이")
    }
    
    func configure(with place: Place) {
        locationLabel.text = place.addressName
        placeLabel.text = place.placeName
        locationLabel.textColor = .gray
        self.setupLayoutForPlace()
    }
    
    func remove() {
        placeLabel.removeFromSuperview()
    }
}
