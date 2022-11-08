//
//  MyPageTableViewCell.swift
//  Vegeting
//
//  Created by 최동권 on 2022/11/08.
//

import UIKit

class MyPageTableViewCell: UITableViewCell {
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body, compatibleWith: .init(legibilityWeight: .regular))
        return label
    }()
    
    private let alarmSwitch: UISwitch = {
        let uiSwitch = UISwitch()
        uiSwitch.isOn = true
        uiSwitch.addTarget(MyPageTableViewCell.self, action: #selector(didSwitchValueChanged), for: .touchUpInside)
        return uiSwitch
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLabelLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        label.font = .preferredFont(forTextStyle: .body, compatibleWith: .init(legibilityWeight: .regular))
    }
    
    private func setupLabelLayout() {
        contentView.addSubview(label)
        label.constraint(top: contentView.topAnchor,
                         leading: contentView.leadingAnchor,
                         bottom: contentView.bottomAnchor,
                         padding: UIEdgeInsets(top: 16, left: 20, bottom: 16, right: 0))
    }
    
    private func setupSwitchLayout() {
        contentView.addSubview(alarmSwitch)
        alarmSwitch.constraint(trailing: contentView.trailingAnchor,
                               centerY: contentView.centerYAnchor,
                               padding: UIEdgeInsets(top: 16, left: 20, bottom: 16, right: 20))
    }
    
    @objc
    private func didSwitchValueChanged(_ sender: UISwitch) {
        if sender.isOn {
            print("on!")
        }
    }
}
