//
//  LocationAuthViewController.swift
//  Vegeting
//
//  Created by 김원희 on 2022/11/08.
//

import MapKit
import UIKit

class LocationAuthViewController: UIViewController {
    
    //포항공대 위치 - default
    let firstLocation = CLLocationCoordinate2D(latitude: 36.0106098, longitude: 129.321296)
    let defaultSpanValue = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    
    public var currentLatitude: CLLocationDegrees?
    public var currentLongitude: CLLocationDegrees?
    
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
    private var locationManager = CLLocationManager()
    public let geocoder = CLGeocoder()
    
    public let locationTextField: UITextField = {
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
        
        configureLocationManager()
        configureMap()
        configureUI()
        currentLocationButtonAction()
        setupLayout()
    }
    
    func configureLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
    }
    
    func configureMap() {
        //처음 보여줄 위치
        mapView.map.setRegion(MKCoordinateRegion(center: firstLocation,
                                                 span: defaultSpanValue), animated: true)
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
        //유저의 현재 위치 정보(locationManager.location)가 없으면(nil) 위치 허용 권한 확인
        guard let currentLocation = locationManager.location else {
            checkUserLocationServicesAuthorization()
            return
        }
        
        //사용자 위치 정보 업데이트 -> didUpdateLocations delegate 메서드를 호출
        locationManager.startUpdatingLocation()
        
        //사용자 현재 위치 표시
        mapView.map.showsUserLocation = true
        mapView.map.setUserTrackingMode(.follow, animated: true)
    }
    
    
    /// 위치 권한 설정 함수
    func checkCurrentLocationAuthorization(authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            print("notDetermined")
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        case .restricted:
            print("restricted")
            goSetting()
        case .denied:
            print("denided")
            goSetting()
        case .authorizedAlways:
            print("always")
        case .authorizedWhenInUse:
            print("wheninuse")
            locationManager.startUpdatingLocation()
        @unknown default:
            print("unknown")
        }
        //#available 여러 플랫폼에서 서로 다른 처리 결정. 여기에서는 14 이상
        if #available(iOS 14.0, *) {
            let accuracyState = locationManager.accuracyAuthorization
            switch accuracyState {
            case .fullAccuracy:
                print("full")
            case .reducedAccuracy:
                print("reduced")
            @unknown default:
                print("Unknown")
            }
        }
    }
    
    func goSetting() {
        let alert = UIAlertController(title: "위치권한 요청", message: "위치 권한 허용이 필요합니다.", preferredStyle: .alert)
        let settingAction = UIAlertAction(title: "설정", style: .default) { action in
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            // 열 수 있는 url 이라면, 이동
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { UIAlertAction in
            
        }
        
        alert.addAction(settingAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    public func checkUserLocationServicesAuthorization() {
        let authorizationStatus: CLAuthorizationStatus
        if #available(iOS 14, *) {
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        if CLLocationManager.locationServicesEnabled() {
            checkCurrentLocationAuthorization(authorizationStatus: authorizationStatus)
        }
    }

    func currentLocationButtonAction() {
        mapView.currentLocationButton.addTarget(self, action: #selector(findCurrentLocation), for: .touchUpInside)
    }
}

extension LocationAuthViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        //위도 경도를 주소로 변환
        geocoder.reverseGeocodeLocation(CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)) { placeMarks, error in
            guard let placeMarks = placeMarks,
                  let address = placeMarks.last,
                  error == nil else {
                return
            }
            DispatchQueue.main.async {
                self.locationTextField.text = "\(address.locality!) \(address.subLocality!)"
            }
        }
    }
}
