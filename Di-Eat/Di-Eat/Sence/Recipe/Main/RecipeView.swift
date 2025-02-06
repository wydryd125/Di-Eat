//
//  RecipeView.swift
//  Di-Eat
//
//  Created by wjdyukyung on 12/30/24.
//

import UIKit
import Combine
import SnapKit

class RecipeView: BaseView {
    // MARK: - Property
    private let headerView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 474)
        return view
    }()
    
    let levelButtonView = DiEatRecipeLevelButtonView()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 1.5, height: 320)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(RecipeCollectionViewCell.self, forCellWithReuseIdentifier: RecipeCollectionViewCell.identifier)
        return collectionView
    }()
    
    private let bestLabel: UILabel = {
        let label = UILabel()
        label.text = "Best Recipe"
        label.font = .poppins(ofSize: 18, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    let bestButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "iconMore"), for: .normal)
        button.tintColor = .diEatGray600
        return button
    }()
    
    private let newLabel: UILabel = {
        let label = UILabel()
        label.text = "New Recipe"
        label.font = .poppins(ofSize: 18, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    let newButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "iconMore"), for: .normal)
        button.tintColor = .diEatGray600
        return button
    }()

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.clipsToBounds = true
        tableView.backgroundColor = .white
        tableView.contentInsetAdjustmentBehavior = .always
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(RecipeCell.self, forCellReuseIdentifier: RecipeCell.identifier)
        return tableView
    }()
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setUI()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    private func setUI() {
        [self.bestLabel, self.bestButton, self.collectionView, self.newLabel, self.newButton, self.levelButtonView].forEach {
            self.headerView.addSubview($0)
        }
        
        self.tableView.tableHeaderView = self.headerView
        self.addSubview(self.tableView)
    }
    
    private func setConstraints() {
        self.bestLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.equalToSuperview().inset(28)
            make.height.equalTo(38)
        }
        
        self.bestButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.bottom.equalTo(self.bestLabel).offset(-4)
            make.width.equalTo(48)
            make.height.equalTo(20)
        }
            
        self.collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.bestLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(320)
        }
        
        self.newLabel.snp.makeConstraints { make in
            make.top.equalTo(self.collectionView.snp.bottom).offset(18)
            make.leading.equalToSuperview().inset(28)
            make.height.equalTo(38)
        }

        self.newButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.bottom.equalTo(self.newLabel).offset(-4)
            make.width.equalTo(48)
            make.height.equalTo(20)
        }
        
        self.levelButtonView.snp.makeConstraints { make in
            make.top.equalTo(self.newLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(28)
            make.bottom.equalToSuperview()
            make.height.equalTo(24)
        }
        
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.headerView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(474)
            make.width.equalTo(self.tableView)
        }
    }
}
