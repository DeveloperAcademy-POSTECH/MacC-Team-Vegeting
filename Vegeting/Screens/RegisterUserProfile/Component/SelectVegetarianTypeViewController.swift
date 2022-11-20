//
//  SelectVegetarianTypeViewController.swift
//  Vegeting
//
//  Created by 김원희 on 2022/11/17.
//

import UIKit

struct TypeDescription {
    let type: String
    let description: String
}

class SelectVegetarianTypeViewController: UIViewController {
    
    var vegetarianTypes: [TypeDescription] = [TypeDescription(type: "프루테리언", description: "열매만 섭취해요."),
                                              TypeDescription(type: "비건", description: "완전한 식물성만 섭취해요."),
                                              TypeDescription(type: "락토", description: "식물성을 섭취하고, 추가로 우유와 유제품은 소비해요."),
                                              TypeDescription(type: "오보", description: "식물성을 섭취하고, 추가로 달걀 등 알은 소비해요."),
                                              TypeDescription(type: "락토 오보", description: "식물성을 섭취하고, 추가로 우유 및 유제품과 달걀 등 알은 소비해요."),
                                              TypeDescription(type: "페스코", description: "식물성을 섭취하고, 추가로 생선 등 어류는 소비해요."),
                                              TypeDescription(type: "폴로", description: "식물성을 섭취하고, 추가로 닭고기나 오리고기 등 가금류는 소비해요."),
                                              TypeDescription(type: "플렉시테리언", description: "채식을 지향하지만, 상황에 따라서 동물성도 소비해요."),
                                              TypeDescription(type: "비덩주의", description: "덩어리로 된 육류는 피하고, 육수 등은 소비해요."),
                                              TypeDescription(type: "간헐적 채식", description: "매일 채식을 하지는 못해도, 일상에서 조금씩 실천하려고 노력해요.")]
    
    weak var delegate: SelectVegetarianTypeViewDelegate?
    private var selectedVegetarianType = ""

    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.setTitleColor(UIColor.mainYellow, for: .normal)
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var completeButton: UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.setTitleColor(.lightGray, for: .disabled)
        button.isEnabled = false
        button.setTitleColor(UIColor.mainYellow, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .headline, compatibleWith: .init(legibilityWeight: .bold))
        button.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var vegetarianTypeTable: UITableView = {
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
            
            selectedVegetarianType = vegetarianTypes[indexPath.row].type
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
        return vegetarianTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VegetarianTypeTableViewCell.className, for: indexPath) as? VegetarianTypeTableViewCell else {
            return UITableViewCell()
        }
        let type = vegetarianTypes[indexPath.row]
        let model = TypeDescription(type: type.type, description: type.description)
        cell.configure(with: model)
        
        return cell
    }
}
