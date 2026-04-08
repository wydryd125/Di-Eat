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
    
    let searchView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.diEatGray600.cgColor
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "iconFinder")
        imageView.tintColor = .diEatGray600
        
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(24)
        }
        return view
    }()
    
    let searchTextfield: UITextField = {
        let textField = UITextField()
        textField.font = .poppins(ofSize: 16, weight: .medium)
        textField.textColor = .black
        return textField
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
//        self.tableView.tableHeaderView = self.headerView
        self.searchView.addSubview(self.searchTextfield)
        [self.searchView, self.tableView].forEach {
            self.addSubview($0)
        }
    }
    
    private func setConstraints() {
        self.searchView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(28)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
        
        self.searchTextfield.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(56)
            make.centerY.equalToSuperview()
        }
    }
}
