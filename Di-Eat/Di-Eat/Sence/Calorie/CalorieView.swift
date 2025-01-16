//
//  CalorieView.swift
//  Di-Eat
//
//  Created by wjdyukyung on 1/11/25.
//

import UIKit
import Combine
import SnapKit

class CalorieView: BaseView {
    // MARK: - Property
    let headerView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 469)
        return view
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
        self.tableView.tableHeaderView = self.headerView
        self.addSubview(self.tableView)
    }
    
    private func setConstraints() {
        self.headerView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(469)
            make.width.equalTo(self.tableView)
        }
    }
}
