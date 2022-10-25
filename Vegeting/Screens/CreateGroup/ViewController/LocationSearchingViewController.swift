//
//  LocationSearchingViewController.swift
//  Vegeting
//
//  Created by 최동권 on 2022/10/24.
//

import UIKit
import Alamofire
import SwiftyJSON

final class LocationSearchingViewController: UIViewController {
    
    // MARK: - properties
    
    private let resultTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(SearchedLocationResultTableViewCell.self, forCellReuseIdentifier: SearchedLocationResultTableViewCell.className)
        return tableView
    }()
    
    var resultList: [Place] = []
    
    // MARK: - lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        configureUI()
        requestLocation()
    }
    
    // MARK: - func
    
    private func setupNavigationBar() {
        let backButton = UIBarButtonItem(image: ImageLiteral.backwardChevronSymbol,
                                         style: .plain,
                                         target: self,
                                         action: #selector(touchUpAddButton))
        navigationItem.leftBarButtonItem = backButton
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "구, 동, 장소를 입력해주세요."
        self.navigationItem.searchController = searchController
    }
    
    //    private func configureTableView() {
    //        resultTableView.delegate = self
    //        resultTableView.dataSource = self
    //    }
    
    private func configureUI() {
        view.backgroundColor = .white
    }
    
    @objc
    private func touchUpAddButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func requestLocation() {
        let headers: HTTPHeaders = [
            "Authorization": "KakaoAK 0af518ebd6f6d9b7b526a91fbabeadc1"
        ]
        
        let parameters: [String: Any] = [
            "query": "포항 효자동",
            "page": 1,
            "size": 10
        ]
        
        Session.default.request("https://dapi.kakao.com/v2/local/search/address.json", method: .get,
                                parameters: parameters, headers: headers)
        .responseJSON(completionHandler: { response in
            switch response.result {
            case .success(let value):
                if let detailsPlace = JSON(value)["documents"].array{
                    for item in detailsPlace{
                        let placeName = item["place_name"].string ?? ""
//                        let firstRegion = item["address"]["region_1depth_name"].string ?? ""
//                        let secondRegion = item["address"]["region_2depth_name"].string ?? ""
//                        let thirdRegion = item["address"]["region_3depth_name"].string ?? ""
                        let addressName = item["address"]["address_name"].string ?? ""
//                        let roadAdressName = item["road_address_name"].string ?? ""
                        let longitudeX = item["x"].string ?? ""
                        let latitudeY = item["y"].string ?? ""
                        self.resultList.append(Place(placeName: placeName,
                                                     region: addressName,
                                                     longitudeX: longitudeX,
                                                     latitudeY: latitudeY))
                    }
                }
                print(self.resultList)
                
            case .failure(let error):
                print("에러")
                print(error)
            }
        })
    }
}

