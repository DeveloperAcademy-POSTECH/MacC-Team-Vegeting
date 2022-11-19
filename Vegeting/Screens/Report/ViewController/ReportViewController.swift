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
    
    var entryPoint: ReportType = .unregister
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = UITableView.automaticDimension
//        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ReportObjectTableViewCell.self, forCellReuseIdentifier: ReportObjectTableViewCell.className)
        tableView.register(ReportTableViewCell.self, forCellReuseIdentifier: ReportTableViewCell.className)
        tableView.register(ReportTableViewHeaderView.self, forHeaderFooterViewReuseIdentifier: ReportTableViewHeaderView.className)
        return tableView
    }()
   
    private let reportButton: BottomButton = {
        let button = BottomButton()
        button.isEnabled = false
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .body, compatibleWith: .init(legibilityWeight: .bold))
        return button
    }()
    
    private let reportInformationLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textColor = .vfGray2
        label.text = "차단하면, 해당 사용자가 작성한 모임모집글이 보이지 않습니다.\n차단한 사용자는 마이페이지 > 차단한 사용자 관리에서 확인하고 해제할 수 있습니다. "
        label.numberOfLines = 0
        return label
    }()
    
    private let reportElementList: [String] = ["모집글 성격과 맞지 않아요.", "불쾌감을 줍니다.", "개인정보 노출 문제가 있어요", "연애/19+ 만남을 유도합니다.", "법적인 문제가 있어요", "욕설/혐오/차별적 표현이 있습니다.", "음란물입니다.", "불쾌한 표현이 있습니다.", "홍보/도배글입니다.", "기타 (직접 입력)"]
    private let blockElementList: [String] = ["불쾌감을 줍니다.", "개인정보를 유출합니다.", "욕설/혐오/차별적 표현을사용해요", "다른 목적을 가지고 접근하는 것 같아요", "불쾌한 표현을 사용해요", "홍보/도배글을 작성합니다.", "기타 (직접 입력)" ]
    private let unregisterElementList: [String] = ["디자인이 마음에 안 들어요", "다른 더 좋은 서비스를 찾았어요.", "더 이상 채식을 하지 않아요.", "안 좋은 일을 겪었어요.", "기타 (직접 입력)"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtonTitle()
        setupLayout()
        configureUI()
    }
    
    private func setupButtonTitle() {
        let buttonTitle: String
        switch entryPoint {
        case .report:
            buttonTitle = "신고합니다"
        case .block:
            buttonTitle = "차단합니다"
        case .unregister:
            buttonTitle = "회원 탈퇴"
        }
        reportButton.setTitle(buttonTitle, for: .normal)
    }
    
    private func setupLayout() {
        view.addSubviews(tableView, reportInformationLabel, reportButton)
        tableView.constraint(top: view.safeAreaLayoutGuide.topAnchor,
                             leading: view.leadingAnchor,
                             bottom: reportInformationLabel.topAnchor,
                             trailing: view.trailingAnchor,
                             padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        reportInformationLabel.constraint(leading: view.leadingAnchor,
                                          bottom: reportButton.topAnchor,
                                          trailing: view.trailingAnchor,
                                          padding: UIEdgeInsets(top: 0, left: 20, bottom: 16, right: 20))
        
        reportButton.constraint(bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                centerX: view.centerXAnchor,
                                padding: UIEdgeInsets(top: 0, left: 0, bottom: 55, right: 0))
        
        
    }
    
    private func configureUI() {
        view.backgroundColor = .white
    }
    
}

extension ReportViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch entryPoint {
        case .report:
            return reportElementList.count
        case .block:
            return blockElementList.count
        case .unregister:
            return unregisterElementList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReportTableViewCell.className, for: indexPath) as? ReportTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.delegate = self
        
        switch entryPoint {
        case .report:
            setupTableViewCell(cell: cell, elementList: reportElementList, indexPath: indexPath)
        case .block:
            setupTableViewCell(cell: cell, elementList: blockElementList, indexPath: indexPath)
        case .unregister:
            setupTableViewCell(cell: cell, elementList: unregisterElementList, indexPath: indexPath)
        }
        
        return cell
    }
    
    private func setupTableViewCell(cell: ReportTableViewCell, elementList: [String], indexPath: IndexPath) {
        let isOtherOption = indexPath.row == elementList.count - 1
        if isOtherOption {
            cell.setupLayout(isOtherOption: true)
        } else {
            cell.setupLayout(isOtherOption: false)
        }
        cell.configure(with: unregisterElementList[indexPath.row])
    }
}

extension ReportViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ReportTableViewHeaderView.className) as?  ReportTableViewHeaderView else { return UIView() }
        
        switch entryPoint {
        case .report:
            headerView.configure(with: "신고 사유 (최대 3개 선택)")
        case .block:
            headerView.configure(with: "‘초보채식인'\n사용자를 차단하는 이유가 무언인가요?")
        case .unregister:
            headerView.configure(with: "탈퇴 사유 (최대 3개 선택)")
        }
        return headerView
    }
    
}

extension ReportViewController: ReportTableViewCellDelegate {
    func requestUpdateTableView() {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
 
}
