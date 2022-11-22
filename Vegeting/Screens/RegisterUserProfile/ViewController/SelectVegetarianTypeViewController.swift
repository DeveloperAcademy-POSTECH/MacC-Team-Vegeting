//
//  SelectVegetarianTypeViewController.swift
//  Vegeting
//
//  Created by 김원희 on 2022/11/17.
//

import UIKit

enum VegetarianType: Int, CaseIterable {
    case fruitarian
    case vegan
    case lacto
    case ovo
    case lactoOvo
    case pesco
    case pollo
    case flexitarian
    case avoidMeatLoaf
    case intermittent
    
    var typeName: String {
        switch self {
        case .fruitarian:
            return "프루테리언"
        case .vegan:
            return "비건"
        case .lacto:
            return "락토"
        case .ovo:
            return "오보"
        case .lactoOvo:
            return "락토 오보"
        case .pesco:
            return "페스코"
        case .pollo:
            return "폴로"
        case .flexitarian:
            return "플렉시테리언"
        case .avoidMeatLoaf:
            return "비덩주의"
        case .intermittent:
            return "간헐적 채식"
        }
    }
    
    var description: String {
        switch self {
        case .fruitarian:
            return "열매만 섭취해요."
        case .vegan:
            return "완전한 식물성만 섭취해요."
        case .lacto:
            return "식물성을 섭취하고, 추가로 우유와 유제품은 소비해요."
        case .ovo:
            return "식물성을 섭취하고, 추가로 달걀 등 알은 소비해요."
        case .lactoOvo:
            return "식물성을 섭취하고, 추가로 우유 및 유제품과 달걀 등 알은 소비해요."
        case .pesco:
            return "식물성을 섭취하고, 추가로 생선 등 어류는 소비해요."
        case .pollo:
            return "식물성을 섭취하고, 추가로 닭고기나 오리고기 등 가금류는 소비해요."
        case .flexitarian:
            return "채식을 지향하지만, 상황에 따라서 동물성도 소비해요."
        case .avoidMeatLoaf:
            return "덩어리로 된 육류는 피하고, 육수 등은 소비해요."
        case .intermittent:
            return "매일 채식을 하지는 못해도, 일상에서 조금씩 실천하려고 노력해요."
        }
    }
}

protocol SelectVegetarianTypeViewDelegate: AnyObject {
    func didSelectVegetarianType(type: String)
    func didSelectVegetarianTypeForNextButton()
}

final class SelectVegetarianTypeViewController: UIViewController {
    
    weak var delegate: SelectVegetarianTypeViewDelegate?
    private var selectedVegetarianType = ""

    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.setTitleColor(UIColor.vfYellow1, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var completeButton: UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.isEnabled = false
        button.setTitleColor(UIColor.vfGray3, for: .disabled)
        button.setTitleColor(UIColor.vfYellow1, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .headline, compatibleWith: .init(legibilityWeight: .bold))
        button.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let vegetarianTypeTable: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.register(VegetarianTypeTableViewCell.self,
                       forCellReuseIdentifier: VegetarianTypeTableViewCell.className)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        configureUI()
        setupLayout()
    }

    private func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubviews(cancelButton, completeButton, vegetarianTypeTable)
    }
    
    private func setupLayout() {
        
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            completeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            completeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            vegetarianTypeTable.topAnchor.constraint(equalTo: completeButton.bottomAnchor, constant: 20),
            vegetarianTypeTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            vegetarianTypeTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            vegetarianTypeTable.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func dismissModal() {
        self.dismiss(animated: true)
    }
    
    private func configureTableView() {
        vegetarianTypeTable.delegate = self
        vegetarianTypeTable.dataSource = self
    }
    
    @objc
    private func cancelButtonTapped() {
        dismissModal()
    }
    
    @objc
    private func completeButtonTapped() {
        delegate?.didSelectVegetarianType(type: selectedVegetarianType)
        delegate?.didSelectVegetarianTypeForNextButton()
        dismissModal()
    }
    
    private func completeButtonActive() {
        completeButton.isEnabled = true
    }
}

extension SelectVegetarianTypeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
            cell.selectionStyle = .none
            
            if let vegetarianType = VegetarianType(rawValue: indexPath.row)?.typeName {
                selectedVegetarianType = vegetarianType
            }
            
//            selectedVegetarianType = vegetarianTypes[indexPath.row].typeName
            completeButtonActive()
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
        }
    }
}

extension SelectVegetarianTypeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return VegetarianType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VegetarianTypeTableViewCell.className, for: indexPath) as? VegetarianTypeTableViewCell else {
            return UITableViewCell()
        }
        
        let type = VegetarianType(rawValue: indexPath.row)
        if let typeName = type?.typeName, let description = type?.description {
            let model = TypeDescription(typeName: typeName, description: description)
            cell.configure(with: model)
        }
    
        return cell
    }
}
