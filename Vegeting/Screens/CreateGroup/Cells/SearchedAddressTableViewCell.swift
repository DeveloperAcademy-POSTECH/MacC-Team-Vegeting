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
        return label
    }()
    
    // MARK: - init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        locationLabel.font = .preferredFont(forTextStyle: .body)
        locationLabel.removeFromSuperview()
        placeLabel.removeFromSuperview()
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
        placeLabel.constraint(.heightAnchor, constant: placeLabel.intrinsicContentSize.height)
        
        locationLabel.constraint(top: placeLabel.bottomAnchor,
                                 leading: self.leadingAnchor,
                                 bottom: self.bottomAnchor,
                                 padding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 0))
        locationLabel.constraint(.heightAnchor, constant: locationLabel.intrinsicContentSize.height)
    }
    
    func configure(with address: Address) {
        locationLabel.text = address.addressName
        locationLabel.textColor = .black
        self.setupLayoutForAddress()
    }
    
    func configure(with autoSearchedLocalTitle: String) {
        locationLabel.text = autoSearchedLocalTitle
        locationLabel.textColor = .black
        self.setupLayoutForAddress()
    }
    
    func configure(with place: Place) {
        locationLabel.text = place.addressName
        locationLabel.textColor = .gray
        locationLabel.font = .preferredFont(forTextStyle: .subheadline)
        placeLabel.text = place.placeName
        self.setupLayoutForPlace()
    }
    
    func remove() {
        placeLabel.removeFromSuperview()
    }
}
