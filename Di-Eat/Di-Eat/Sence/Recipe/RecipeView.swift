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
    let headerView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 474)
        return view
    }()
    
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
    
    let switchButton: DiEatSwitchButton = {
        let button = DiEatSwitchButton()
        return button
    }()
    
    let bestLabel: UILabel = {
        let label = UILabel()
        label.text = "Best Recipe"
        label.font = .poppins(ofSize: 18, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    let newLabel: UILabel = {
        let label = UILabel()
        label.text = "New Recipe"
        label.font = .poppins(ofSize: 18, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    let filterStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.spacing = 24
        return stackView
    }()
    
    let allButton: UIButton = {
        let button = UIButton.createCustomButton(title: "All",
                                                 font: .poppins(ofSize: 12, weight: .medium),
                                                 titleColor: UIColor(hexString: "#363062"))
        button.tag = LevelType.all.rawValue
        return button
    }()
    
    let level1Button: UIButton = {
        let button = UIButton.createCustomButton(title: "Level 1",
                                                 font: .poppins(ofSize: 12, weight: .medium),
                                                 titleColor: UIColor(hexString: "#BDBDBD"))
        button.tag = LevelType.level1.rawValue
        return button
    }()
    
    let level2Button: UIButton = {
        let button = UIButton.createCustomButton(title: "level 2",
                                                 font: .poppins(ofSize: 12, weight: .medium),
                                                 titleColor: UIColor(hexString: "#BDBDBD"))
        button.tag = LevelType.level2.rawValue
        return button
    }()
    
    let level3Button: UIButton = {
        let button = UIButton.createCustomButton(title: "lebel 3",
                                                 font: .poppins(ofSize: 12, weight: .medium),
                                                 titleColor: UIColor(hexString: "#BDBDBD"))
        button.tag = LevelType.level3.rawValue
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
    func updateRecipeView(type: RecipeType) {
//        self.label.text = type == .new ? "New Recipe" : "Best Recipe"
        
    }
    
    func updateLevelbutton(level: LevelType) {
        [self.allButton, self.level1Button, self.level2Button, self.level3Button].enumerated().forEach { idx, button in
            let title: String
            switch idx {
            case LevelType.all.rawValue:
                title = "All"
            case LevelType.level1.rawValue:
                title = "Level 1"
            case LevelType.level2.rawValue:
                title = "Level 2"
            case LevelType.level3.rawValue:
                title = "Level 3"
            default:
                title = ""
            }
            
            let fontColor = (level.rawValue == idx) ? "#363062" : "#BDBDBD"
            
            var attString = AttributedString(title)
            attString.font = .poppins(ofSize: 12, weight: .medium)
            attString.foregroundColor = UIColor(hexString: fontColor)
            
            button.configuration?.attributedTitle = attString
        }
    }
    
    private func setUI() {
        [self.allButton, self.level1Button, self.level2Button, self.level3Button].forEach {
            self.filterStackView.addArrangedSubview($0)
        }
        
        [self.bestLabel, self.collectionView, self.newLabel, self.filterStackView].forEach {
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

        self.filterStackView.snp.makeConstraints { make in
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
