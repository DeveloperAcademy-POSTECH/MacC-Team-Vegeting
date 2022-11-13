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
        view.backgroundColor = .black
        return view
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray3
        return view
    }()
    
    private var selectedTab: Int = 0 {
        didSet {
            for idx in 0..<tabs.count {
                UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseInOut) { [weak self] in
                    self?.segmentStackView.arrangedSubviews[idx].tintColor = idx == self?.selectedTab ? .label : .secondaryLabel
                    self?.leadingAnchors[idx].isActive = idx == self?.selectedTab ? true : false
                    self?.trailingAnchors[idx].isActive = idx == self?.selectedTab ? true : false
                    self?.layoutIfNeeded()
                } completion: { _ in }
            }
        }
    }
    
    private var tabs: [UIButton] = ["하루 모임", "정기 모임"].map { buttonTitle in
        let button = UIButton(type: .system)
        button.setTitle(buttonTitle, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        button.tintColor = .label
        return button
    }
    
    private lazy var segmentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: tabs)
        stackView.setHorizontalStack()
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private var leadingAnchors: [NSLayoutConstraint] = []
    private var trailingAnchors: [NSLayoutConstraint] = []
    
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
            button.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        configureSegmentButton()
    }
    
    @objc private func tabButtonTapped(_ sender: UIButton) {
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
    
    private func setupLayout() {
        addSubviews(segmentStackView, lineView, indicatorView)
        
        NSLayoutConstraint.activate([
            segmentStackView.topAnchor.constraint(equalTo: topAnchor),
            segmentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            segmentStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
        leadingAnchors = segmentStackView.arrangedSubviews.map { buttonView in
            indicatorView.leadingAnchor.constraint(equalTo: buttonView.leadingAnchor)
        }
        trailingAnchors = segmentStackView.arrangedSubviews.map { buttonView in
            indicatorView.trailingAnchor.constraint(equalTo: buttonView.trailingAnchor)
        }
        
        NSLayoutConstraint.activate([
            leadingAnchors[0],
            trailingAnchors[0],
            indicatorView.topAnchor.constraint(equalTo: segmentStackView.arrangedSubviews[0].bottomAnchor),
            indicatorView.heightAnchor.constraint(equalToConstant: 3),
            indicatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            lineView.topAnchor.constraint(equalTo: indicatorView.bottomAnchor, constant: -1),
            lineView.heightAnchor.constraint(equalToConstant: 1),
            lineView.leadingAnchor.constraint(equalTo: segmentStackView.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: segmentStackView.trailingAnchor),
        ])
    }
}
