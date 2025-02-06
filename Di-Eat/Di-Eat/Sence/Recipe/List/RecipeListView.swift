//
//  RecipeListView.swift
//  Di-Eat
//
//  Created by wjdyukyung on 1/31/25.
//

import UIKit
import Combine
import SnapKit

class RecipeListView: UIView {
    // MARK: - Property
    let switchButton: DiEatSwitchButton = {
        let button = DiEatSwitchButton()
        return button
    }()
    
    let levelButtonView = DiEatRecipeLevelButtonView()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.clipsToBounds = true
        tableView.backgroundColor = .white
        tableView.contentInsetAdjustmentBehavior = .always
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.estimatedRowHeight = 64
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(RecipeListTableViewCell.self, forCellReuseIdentifier: RecipeListTableViewCell.identifier)
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
    
    private func setUI() {
        [self.switchButton,  self.levelButtonView, self.tableView].forEach {
            self.addSubview($0)
        }
    }
    
    private func setConstraints() {
        self.switchButton.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        self.levelButtonView.snp.makeConstraints { make in
            make.top.equalTo(self.switchButton.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(28)
            make.height.equalTo(24)
        }
        
        self.tableView.snp.makeConstraints { make in
            make.top.equalTo(self.levelButtonView.snp.bottom).offset(4)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
