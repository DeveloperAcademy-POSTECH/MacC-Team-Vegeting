//
//  SegmentedControlCustomView.swift
//  Vegeting
//
//  Created by kelly on 2022/11/04.
//

import UIKit

class SegmentedControlCustomView: UIView {
    private enum SectionTabs: String {
        case oneDayClub = "하루 모임"
        case regularClub = "정기 모임"
        
        var selectedIndex: Int {
            switch self {
            case .oneDayClub:
                return 0
            case .regularClub:
                return 1
            }
        }
    }
    
    private let indicatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1)
        return view
    }()
    
    private var selectedTab: Int = 0 {
        didSet {
            for idx in 0..<tabs.count {
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) { [weak self] in
                    self?.segmentStackView.arrangedSubviews[idx].tintColor = idx == self?.selectedTab ? .label : .secondaryLabel
                    self?.leadingAnchors[idx].isActive = idx == self?.selectedTab ? true : false
                    self?.trailingAnchros[idx].isActive = idx == self?.selectedTab ? true : false
                    self?.layoutIfNeeded()
                } completion: { _ in }
            }
        }
    }
    
    private var tabs: [UIButton] = ["하루 모임", "정기 모임"].map { buttonTitle in
        let button = UIButton(type: .system)
        button.setTitle(buttonTitle, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize:   16, weight: .bold)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    private lazy var segmentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: tabs)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
    }()
    
    private var leadingAnchors: [NSLayoutConstraint] = []
    private var trailingAnchros: [NSLayoutConstraint] = []
    
    private func configureSegmentButton() {
        for (idx, button) in segmentStackView.arrangedSubviews.enumerated() {
            guard let button = button as? UIButton else {
                return
            }
            if idx == selectedTab {
                button.tintColor = .label
            } else {
                button.tintColor = .secondaryLabel
            }
            button.addTarget(self, action: #selector(didTapTab(_:)), for: .touchUpInside)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        [segmentStackView, indicatorView].forEach { view in
            addSubview(view)
        }
        configureConstraints()
        configureSegmentButton()
    }
    
    @objc private func didTapTab(_ sender: UIButton) {
        guard let label = sender.titleLabel?.text else { return }
        switch label {
        case SectionTabs.oneDayClub.rawValue:
            selectedTab = 0
        case SectionTabs.regularClub.rawValue:
            selectedTab = 1
        default:
            break
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configureConstraints() {
        leadingAnchors = segmentStackView.arrangedSubviews.map { buttonView in
            indicatorView.leadingAnchor.constraint(equalTo: buttonView.leadingAnchor)
        }
        trailingAnchros = segmentStackView.arrangedSubviews.map { buttonView in
            indicatorView.trailingAnchor.constraint(equalTo: buttonView.trailingAnchor)
        }
        
        let sectionStackViewConstraints = [
            segmentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            segmentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            segmentStackView.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            segmentStackView.heightAnchor.constraint(equalToConstant: 35)
        ]
        let indicatorViewConstraints = [
            leadingAnchors[0],
            trailingAnchros[0],
            indicatorView.topAnchor.constraint(equalTo: segmentStackView.arrangedSubviews[0].bottomAnchor),
            indicatorView.heightAnchor.constraint(equalToConstant: 4)
        ]
        [sectionStackViewConstraints, indicatorViewConstraints].forEach { constraint in
            NSLayoutConstraint.activate(constraint)
        }
    }
}
