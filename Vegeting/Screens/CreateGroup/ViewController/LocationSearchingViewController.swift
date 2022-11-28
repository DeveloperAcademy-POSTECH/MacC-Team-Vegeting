//
//  LocationSearchingViewController.swift
//  Vegeting
//
//  Created by 최동권 on 2022/10/24.
//

import MapKit
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
        tableView.showsVerticalScrollIndicator = false
        tableView.register(SearchedLocationResultTableViewCell.self, forCellReuseIdentifier: SearchedLocationResultTableViewCell.className)
        return tableView
    }()
    
    //    private lazy var emptyResultView = EmptyResultView() {
    //        didSet {
    //            setupEmptyResultViewLayout()
    //        }
    //    }
    
    private var addressResultList: [Address] = []
    
    private var placeResultList: [Place] = [] {
        didSet {
            if !placeResultList.isEmpty {
                DispatchQueue.main.async { [weak self] in
                    self?.resultTableView.reloadData()
                }
            }
        }
    }
    
    private var autoSearchCompleter = MKLocalSearchCompleter()
    private var autoSearchResults = [MKLocalSearchCompletion]()
    
    weak var delegate: LocationSearchingViewControllerDelegate?
    
    // MARK: - lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupResultTableViewLayout()
        configureDelegate()
        configureTableView()
        configureUI()
    }
    
    // MARK: - func
    
    private func configureDelegate() {
        autoSearchCompleter.delegate = self
        autoSearchCompleter.resultTypes = .address
    }
    
    private func setupNavigationBar() {
        let backButton = UIBarButtonItem(image: ImageLiteral.backwardChevronSymbol,
                                         style: .plain,
                                         target: self,
                                         action: #selector(touchUpToPop))
        navigationItem.leftBarButtonItem = backButton
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.delegate = self
        searchController.searchBar.placeholder = "구, 동, 장소를 입력해주세요."
        searchController.searchBar.delegate = self
        searchController.isActive = true
        searchController.searchBar.becomeFirstResponder()
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func configureTableView() {
        resultTableView.delegate = self
        resultTableView.dataSource = self
    }
    
    //    private func checkEmptyResultState() {
    //        if addressResultList.isEmpty && placeResultList.isEmpty {
    //            emptyResultView = EmptyResultView()
    //        } else {
    //            emptyResultView.removeFromSuperview()
    //        }
    //    }
    
    //    private func setupEmptyResultViewLayout() {
    //        view.addSubview(emptyResultView)
    //        emptyResultView.constraint(top: view.safeAreaLayoutGuide.topAnchor,
    //                                   leading: view.leadingAnchor,
    //                                   bottom: view.bottomAnchor,
    //                                   trailing: view.trailingAnchor)
    //    }
    
    private func setupResultTableViewLayout() {
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
    private func touchUpToPop() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func requestAddress(keyword: String) async {
        guard let apiKey = StringLiteral.kakaoAPIKey else { return }
        
        let headers: HTTPHeaders = [
            "Authorization": apiKey
        ]
        
        let parameters: [String: Any] = [
            "query": keyword,
            "page": 1,
            "size": 3
        ]
        
        Session.default.request(StringLiteral.kakaoRestAPIAddress,
                                method: .get,
                                parameters: parameters,
                                headers: headers).responseJSON(completionHandler: { [weak self] response in
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
                self?.addressResultList = list
                
            case .failure(let error):
                print(error)
            }
        })
    }
    
    private func requestPlace(keyword: String) async {
        guard let apiKey = StringLiteral.kakaoAPIKey else { return }
        
        let headers: HTTPHeaders = [
            "Authorization": apiKey
        ]
        
        let parameters: [String: Any] = [
            "query": keyword,
            "page": 1,
            "size": 10
        ]
        
        AF.request(StringLiteral.kakaoRestAPIKeyword,
                   method: .get,
                   parameters: parameters,
                   headers: headers).responseJSON(completionHandler: { [weak self] response in
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
                self?.placeResultList = list
                self?.autoSearchCompleter.queryFragment = keyword
                
            case .failure(let error):
                print(error)
            }
        })
    }
}

extension LocationSearchingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let totalCount = addressResultList.count + placeResultList.count
        return totalCount == 0 ? autoSearchResults.count : totalCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = resultTableView.dequeueReusableCell(withIdentifier: SearchedLocationResultTableViewCell.className, for: indexPath) as? SearchedLocationResultTableViewCell else { return UITableViewCell() }
        let totalAddress = addressResultList.count
        let totalCount = addressResultList.count + placeResultList.count
        
        if totalCount == 0 {
            cell.configure(with: autoSearchResults[indexPath.row].title)
        } else if indexPath.row < totalAddress {
            cell.configure(with: addressResultList[indexPath.row])
        } else {
            cell.configure(with: placeResultList[indexPath.row - totalAddress])
        }
        
        return cell
    }
    
}

extension LocationSearchingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let text: String
        let totalAddress = addressResultList.count
        let totalCount = addressResultList.count + placeResultList.count
        
        if totalCount == 0 {
            text = autoSearchResults[indexPath.row].title
        } else if indexPath.row < totalAddress {
            text = addressResultList[indexPath.row].addressName
        } else {
            text = placeResultList[indexPath.row - totalAddress].placeName
        }
        
        delegate?.configureLocationText(with: text)
        self.navigationController?.popViewController(animated: true)
    }
}

extension LocationSearchingViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            autoSearchResults.removeAll()
        }
        
        Task {
            await requestAddress(keyword: searchText)
            await requestPlace(keyword: searchText)
        }
        
    }
}

extension LocationSearchingViewController: UISearchControllerDelegate {
    func didPresentSearchController(searchController: UISearchController) {
        searchController.searchBar.becomeFirstResponder()
    }
}

extension LocationSearchingViewController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        let isResultNotEmpty = !completer.results.isEmpty
        if isResultNotEmpty {
            autoSearchResults = completer.results
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.resultTableView.reloadData()
        }
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
