//
//  MapUIView.swift
//  Vegeting
//
//  Created by 김원희 on 2022/11/08.
//

import MapKit
import UIKit

class MapView: UIView {
    
    private let map = MKMapView()
    
    private let currentLocationButton: UIButton = {
        let button = UIButton()
        var image = UIImage(systemName: "scope")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 20))
        button.setImage(image, for: .normal)
        button.tintColor = .label
        button.backgroundColor = .white
        button.layer.cornerRadius = 3
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowOpacity = 0.7
        button.layer.shadowOffset = CGSize.zero
        button.layer.shadowRadius = 3
        return button
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        configureUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        map.frame = bounds
    }
    
    private func configureUI() {
        self.addSubviews(map, currentLocationButton)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            currentLocationButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            currentLocationButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            currentLocationButton.widthAnchor.constraint(equalToConstant: 38),
            currentLocationButton.heightAnchor.constraint(equalToConstant: 38)
        ])
    }
    
}
