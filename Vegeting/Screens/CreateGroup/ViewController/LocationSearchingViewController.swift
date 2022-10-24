//
//  LocationSearchingViewController.swift
//  Vegeting
//
//  Created by 최동권 on 2022/10/24.
//

import UIKit

final class LocationSearchingViewController: UIViewController {
    
    // MARK: - properties
    
    private let resultTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(SearchedLocationResultTableViewCell.self, forCellReuseIdentifier: SearchedLocationResultTableViewCell.className)
        return tableView
    }()
    
    // MARK: - lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
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
    
    private func configureTableView() {
        resultTableView.delegate = self
        resultTableView.dataSource = self
    }
    
    private func configureUI() {
        view.backgroundColor = .white
    }
    
    @objc
    private func touchUpAddButton() {
        self.navigationController?.popViewController(animated: true)
    }
}
