//
//  LocationSearchingViewController.swift
//  Vegeting
//
//  Created by 최동권 on 2022/10/24.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol LocationSearchingViewControllerDelegate: AnyObject {
    func configureLocationText(with text: String)
}

final class LocationSearchingViewController: UIViewController {
    
    // MARK: - properties
    
    private let resultTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(SearchedLocationResultTableViewCell.self, forCellReuseIdentifier: SearchedLocationResultTableViewCell.className)
        return tableView
    }()
    
    private var addressResultList: [Address] = []
    private var placeResultList: [Place] = []
    
    weak var delegate: LocationSearchingViewControllerDelegate?
    
    // MARK: - lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupLayout()
        configureTableView()
        configureUI()
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
        searchController.searchBar.delegate = self
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func configureTableView() {
        resultTableView.delegate = self
        resultTableView.dataSource = self
    }
    
    private func setupLayout() {
        view.addSubview(resultTableView)
        resultTableView.constraint(top: view.safeAreaLayoutGuide.topAnchor,
                                   leading: view.safeAreaLayoutGuide.leadingAnchor,
                                   bottom:view.bottomAnchor,
                                   trailing: view.trailingAnchor)
    }
    
    private func configureUI() {
        view.backgroundColor = .white
    }
    
    @objc
    private func touchUpAddButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func requestAddress(keyword: String) async {
        let headers: HTTPHeaders = [
            "Authorization": "KakaoAK 0af518ebd6f6d9b7b526a91fbabeadc1"
        ]
        
        let parameters: [String: Any] = [
            "query": keyword,
            "page": 1,
            "size": 3
        ]
        
        Session.default.request("https://dapi.kakao.com/v2/local/search/address.json",
                                method: .get,
                                parameters: parameters,
                                headers: headers).responseJSON(completionHandler: { response in
            switch response.result {
            case .success(let value):
                var list: [Address] = []
                if let detailsPlace = JSON(value)["documents"].array{
                    for item in detailsPlace{
                        let addressName = item["address"]["address_name"].string ?? ""
                        let longitudeX = item["x"].string ?? ""
                        let latitudeY = item["y"].string ?? ""
                        list.append(Address(addressName: addressName,
                                            longitudeX: longitudeX,
                                            latitudeY: latitudeY))
                    }
                }
                self.addressResultList = list
                self.resultTableView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        })
    }
    
    private func requestPlace(keyword: String) {
        let headers: HTTPHeaders = [
            "Authorization": "KakaoAK 0af518ebd6f6d9b7b526a91fbabeadc1"
        ]
        
        let parameters: [String: Any] = [
            "query": keyword,
            "page": 1,
            "size": 5
        ]
        
        AF.request("https://dapi.kakao.com/v2/local/search/keyword.json",
                   method: .get,
                   parameters: parameters,
                   headers: headers).responseJSON(completionHandler: { response in
            switch response.result {
            case .success(let value):
                var list: [Place] = []
                if let detailsPlace = JSON(value)["documents"].array{
                    for item in detailsPlace{
                        let placeName = item["place_name"].string ?? ""
                        let addressName = item["address_name"].string ?? ""
                        let longitudeX = item["x"].string ?? ""
                        let latitudeY = item["y"].string ?? ""
                        list.append(Place(placeName: placeName,
                                          addressName: addressName,
                                          longitudeX: longitudeX,
                                          latitudeY: latitudeY))
                    }
                }
                self.placeResultList = list
                self.resultTableView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        })
    }
}

extension LocationSearchingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addressResultList.count + placeResultList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = resultTableView.dequeueReusableCell(withIdentifier: SearchedLocationResultTableViewCell.className, for: indexPath) as? SearchedLocationResultTableViewCell else { return UITableViewCell() }
        let totalAddress = addressResultList.count
        
        if indexPath.row < totalAddress {
            cell.configure(with: addressResultList[indexPath.row])
        } else {
            cell.configure(with: placeResultList[indexPath.row - totalAddress])
        }
        
        return cell
    }
    
}

extension LocationSearchingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var text = ""
        if indexPath.row < addressResultList.count {
            text = addressResultList[indexPath.row].addressName
        } else {
            text = placeResultList[indexPath.row].placeName
        }
        
        delegate?.configureLocationText(with: text)
        self.navigationController?.popViewController(animated: true)
    }
}
                                                
extension LocationSearchingViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        addressResultList = []
        placeResultList = []
        Task {
            await requestAddress(keyword: searchText)
            requestPlace(keyword: searchText)
        }
        
    }
}

