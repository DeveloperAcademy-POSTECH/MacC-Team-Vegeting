//
//  LocationAuthViewController.swift
//  Vegeting
//
//  Created by 김원희 on 2022/11/08.
//

import MapKit
import UIKit

class LocationAuthViewController: UIViewController {
    
    let firstLocation = CLLocationCoordinate2D(latitude: 36.0106098, longitude: 129.321296) //포항공대 위치
    var currentLocation: CLLocation? //현재 내 위치 저장
    
    private let progressBarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "progress2")
        return imageView
    }()
    
    private let locationMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "위치 인증을 해주세요."
        label.font = .preferredFont(forTextStyle: .title3,
                                    compatibleWith: .init(legibilityWeight: .bold))
        return label
    }()
    
    private let mapView = MapView()
    private let locationManager = CLLocationManager()
    
    private let locationTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = UIColor(hex: "#616161")
        textField.font = .preferredFont(forTextStyle: .body)
        textField.layer.cornerRadius = 8
        textField.backgroundColor = UIColor(hex: "#F2F2F2")
        return textField
    }()
    
    private let locationNoticeLabel: UILabel = {
        let label = UILabel()
        label.text = "현재위치로만 지역을 인증할 수 있습니다."
        label.textColor = UIColor(hex: "#6C6D70")
        label.font = .preferredFont(forTextStyle: .footnote)
        return label
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음으로", for: .normal)
        button.setTitleColor(UIColor(hex: "#8E8E93"), for: .normal)
        button.setBackgroundColor(UIColor(hex: "#FFF6DA"), for: .normal)
        button.isEnabled = false
        button.clipsToBounds = true
        button.layer.cornerRadius = 8
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMap()
        configureUI()
        findCurrentLocationButtonAction()
        setupLayout()
    }
    
    func configureMap() {
        mapView.map.setRegion(MKCoordinateRegion(center: firstLocation,
                                                 span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true) //처음 보여줄 위치
    }
    
    func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubviews(progressBarImageView, locationMessageLabel, mapView,
                         locationTextField, locationNoticeLabel, nextButton)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            progressBarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 116),
            progressBarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            progressBarImageView.widthAnchor.constraint(equalToConstant: 186),
            progressBarImageView.heightAnchor.constraint(equalToConstant: 26)
        ])
        
        NSLayoutConstraint.activate([
            locationMessageLabel.topAnchor.constraint(equalTo: progressBarImageView.bottomAnchor, constant: 43),
            locationMessageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: locationMessageLabel.bottomAnchor, constant: 14),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            mapView.heightAnchor.constraint(equalToConstant: 354)
        ])
        
        NSLayoutConstraint.activate([
            locationTextField.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 23),
            locationTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            locationTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            locationTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            locationNoticeLabel.topAnchor.constraint(equalTo: locationTextField.bottomAnchor, constant: 10),
            locationNoticeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            locationNoticeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -55),
            nextButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc
    private func findCurrentLocation() {

        mapView.map.showsUserLocation = true
        mapView.map.setUserTrackingMode(.follow, animated: true)
    }
    
    private func findCurrentLocationButtonAction() {
        mapView.currentLocationButton.addTarget(self, action: #selector(findCurrentLocation), for: .touchUpInside)
    }
}
