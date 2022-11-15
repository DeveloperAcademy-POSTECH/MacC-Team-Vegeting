//
//  LocationAuthViewController.swift
//  Vegeting
//
//  Created by 김원희 on 2022/11/08.
//

import MapKit
import UIKit

final class LocationAuthViewController: UIViewController {
    
    //포항공대 위치 - default
    private let defaultLocation = CLLocationCoordinate2D(latitude: 36.0106098, longitude: 129.321296)
    private let defaultSpanValue = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    
    private var currentLatitude: CLLocationDegrees?
    private var currentLongitude: CLLocationDegrees?
    
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
    private let geocoder = CLGeocoder()
    
    private let locationDisplayLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = UIColor(hex: "#616161")
        label.layer.cornerRadius = 8
        label.backgroundColor = UIColor(hex: "#F2F2F2")
        return label
    }()
    
    private let locationNoticeLabel: UILabel = {
        let label = UILabel()
        label.text = "현재위치로만 지역을 인증할 수 있습니다."
        label.textColor = UIColor(hex: "#6C6D70")
        label.font = .preferredFont(forTextStyle: .footnote)
        return label
    }()
    
    private let nextButton: BottomButton = {
        let button = BottomButton()
        button.setTitle("다음으로", for: .normal)
        button.isEnabled = false
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLocationManager()
        configureNavBar()
        configureMap()
        configureUI()
        currentLocationButtonAction()
        setupLayout()
    }
    
    public func configureNavBar() {
        navigationItem.title = "프로필 설정"
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    private func configureLocationManager() {
        locationManager.delegate = self
    }
    
    private func configureMap() {
        //처음 보여줄 위치
        mapView.map.setRegion(MKCoordinateRegion(center: defaultLocation,
                                                 span: defaultSpanValue), animated: true)
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubviews(progressBarImageView, locationMessageLabel, mapView,
                         locationDisplayLabel, locationNoticeLabel, nextButton)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            progressBarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 1/10),
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
            mapView.heightAnchor.constraint(equalToConstant: view.frame.height * 4/10)
        ])
        
        NSLayoutConstraint.activate([
            locationDisplayLabel.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 23),
            locationDisplayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            locationDisplayLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            locationDisplayLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            locationNoticeLabel.topAnchor.constraint(equalTo: locationDisplayLabel.bottomAnchor, constant: 10),
            locationNoticeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            locationNoticeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(view.frame.height * 1/25))
        ])
    }
    
    @objc
    private func findCurrentLocation() {
        //사용자 현재 위치 표시
        mapView.map.showsUserLocation = true
        mapView.map.setUserTrackingMode(.follow, animated: true)

        //유저의 현재 위치 정보(locationManager.location)가 없으면(nil)-> 허용 안함 클릭 시 위치 허용 권한 확인
        guard let _ = locationManager.location else {
            checkUserLocationServicesAuthorization()
            return
        }
    }
    
    private func currentLocationButtonAction() {
        mapView.currentLocationButton.addTarget(self, action: #selector(findCurrentLocation), for: .touchUpInside)
    }
    
    private func nextButtonActive() {
        if !(locationDisplayLabel.text == "") {
            nextButton.isEnabled = true
            nextButton.setTitleColor(UIColor.label, for: .normal)
            nextButton.setBackgroundColor(UIColor(hex: "#FFD243"), for: .normal)
        }
    }
    
    @objc
    private func nextButtonTapped() {
        navigationController?.pushViewController(UserGenderBirthViewController(), animated: true)
    }
    
    /// 위치 권한 설정 함수
    private func checkCurrentLocationAuthorization(authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined: ///위치 권한을 요청 받지 않은 상태 (초기 상태)
            print("notDetermined")
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        case .restricted: ///유저가 기기 설정에서 모든 앱이 위치를 사용할 수 없게 설정했을 경우
            print("restricted")
            goSetting()
        case .denied: ///유저가 위치 권한을 허용 안함으로 설정함
            print("denided")
            goSetting()
        case .authorizedAlways: ///유저가 이 앱이 백그라운드에서도 위치 정보에 접근할 수 있도록 허용함
            print("always")
        case .authorizedWhenInUse: ///유저가 이 앱이 포그라운드에서 위치 정보에 접근할 수 있도록 허용함
            print("wheninuse")
            locationManager.startUpdatingLocation()
        @unknown default:
            print("unknown")
        }
    }
    
    private func goSetting() {
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
    
    private func checkUserLocationServicesAuthorization() {
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
}

extension LocationAuthViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        //위도 경도를 주소로 변환
        geocoder.reverseGeocodeLocation(CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), preferredLocale: Locale(identifier: "Ko-kr")) { placeMarks, error in
            guard let placeMarks = placeMarks,
                  let address = placeMarks.last,
                  error == nil else {
                return
            }
            DispatchQueue.main.async { [weak self] in
                self?.locationDisplayLabel.text = "  \(address.locality ?? "") \(address.subLocality ?? address.name!)"
            }
        }
        
        nextButtonActive()
    }
}
