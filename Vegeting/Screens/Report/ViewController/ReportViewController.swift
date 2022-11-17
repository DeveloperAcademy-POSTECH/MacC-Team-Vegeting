//
//  ReportViewController.swift
//  Vegeting
//
//  Created by 최동권 on 2022/11/17.
//

import UIKit

enum ReportType {
    case report
    case block
    case unregister
}

class ReportViewController: UIViewController {
    
    var entryPoint: ReportType? = nil
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}
