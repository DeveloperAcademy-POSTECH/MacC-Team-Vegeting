//
//  GroupListViewController.swift
//  Vegeting
//
//  Created by kelly on 2022/10/26.
//

import UIKit

class GroupListViewController: ViewController {
    var clubList = [Club]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    let participants = [Participant(userID: "a", name: "aa"),
                        Participant(userID: "b", name: "bb"),
                        Participant(userID: "c", name: "cc"),
                        Participant(userID: "d", name: "dd")]
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(ClubListCell.self, forCellWithReuseIdentifier: ClubListCell.className)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureUI()
        setupLayout()
        clubList = [Club(clubID: "", clubTitle: "동물해방 같이 읽어요.", clubCategory: "a", hostID: "a", participants: participants, createdAt: Date(), maxNumberOfPeople: 10),
                    Club(clubID: "", clubTitle: "매주 금요일마다 플로깅 하러 가실 분??", clubCategory: "a", hostID: "a", participants: participants, createdAt: Date(), maxNumberOfPeople: 11),
                    Club(clubID: "", clubTitle: "매주 금요일마다 플로깅 하러 가실 분??", clubCategory: "a", hostID: "a", participants: participants, createdAt: Date(), maxNumberOfPeople: 12),
                    Club(clubID: "", clubTitle: "남미플랜트랩하고 거북이 먹으러 가요~!", clubCategory: "a", hostID: "a", participants: participants, createdAt: Date(), maxNumberOfPeople: 13),
                    Club(clubID: "", clubTitle: "같이 비건 식당 탐방하실 분?", clubCategory: "a", hostID: "a", participants: participants, createdAt: Date(), maxNumberOfPeople: 14),
                    Club(clubID: "", clubTitle: "동물권 관련 스터디", clubCategory: "a", hostID: "a", participants: participants, createdAt: Date(), maxNumberOfPeople: 15),
                    Club(clubID: "", clubTitle: "기사 읽어보실 분~~", clubCategory: "a", hostID: "a", participants: participants, createdAt: Date(), maxNumberOfPeople: 16),
                    Club(clubID: "", clubTitle: "비건 카페 가실분 계신가요?", clubCategory: "a", hostID: "a", participants: participants, createdAt: Date(), maxNumberOfPeople: 17)
        ]
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func configureUI() {
        view.backgroundColor = .backgroundColor
    }
    
    private func setupLayout() {
        [collectionView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension GroupListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(clubList[indexPath.item])
    }
}

extension GroupListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return clubList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ClubListCell.className, for: indexPath) as? ClubListCell else { return UICollectionViewCell() }
        cell.configure(with: clubList[indexPath.item])
        cell.layer.backgroundColor = UIColor.init(hex: "#e3e3e3").cgColor
        return cell
    }
}

extension GroupListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        let itemsPerRow: CGFloat = 2
        let widthPadding = sectionInsets.left * (itemsPerRow + 1)
        let itemsPerColumn: CGFloat = 3.5
        let heightPadding = sectionInsets.top * (itemsPerColumn + 1)
        let cellWidth = (width - widthPadding) / itemsPerRow
        let cellHeight = (height - heightPadding) / itemsPerColumn
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
