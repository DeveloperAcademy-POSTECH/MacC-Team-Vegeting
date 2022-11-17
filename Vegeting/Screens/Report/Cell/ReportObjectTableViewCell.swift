//
//  ReportObjectTableViewCell.swift
//  Vegeting
//
//  Created by 최동권 on 2022/11/17.
//

import UIKit

class ReportObjectTableViewCell: UITableViewCell {
    
    // MARK: - properties
    
    private let titleUserNameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.text = "작성자"
        label.textColor = .vfGray1
        return label
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()
    
    private let titleClubNameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.text = "제목"
        label.textColor = .vfGray1
        return label
    }()
    
    private let clubNameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()
    
    // MARK: - lifeCycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func
    
    private func setupLayout() {
        addSubviews(titleUserNameLabel, userNameLabel, titleClubNameLabel, clubNameLabel)
        
        titleUserNameLabel.constraint(top: self.topAnchor,
                                      leading: self.leadingAnchor,
                                      padding: UIEdgeInsets(top: 27, left: 20, bottom: 0, right: 0))
        userNameLabel.constraint(top: self.topAnchor,
                                 leading: self.leadingAnchor,
                                 trailing: self.trailingAnchor,
                                 padding: UIEdgeInsets(top: 27, left: 80, bottom: 0, right: 20))
        titleClubNameLabel.constraint(top: titleUserNameLabel.bottomAnchor,
                                      leading: self.leadingAnchor,
                                      padding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 0))
        clubNameLabel.constraint(top: userNameLabel.bottomAnchor,
                                 leading: self.leadingAnchor,
                                 trailing: self.trailingAnchor,
                                 padding: UIEdgeInsets(top: 20, left: 80, bottom: 20, right: 20))
    }
    
    func configure(with data: Club) {
//        userNameLabel =  host 닉네임도 저장해야 할듯
        clubNameLabel.text = data.clubTitle
    }
    
}
