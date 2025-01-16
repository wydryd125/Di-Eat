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
        view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 469)
        return view
    }()
    
    let switchButton: DiEatSwitchButton = {
        let button = DiEatSwitchButton()
        return button
    }()
    
    let chartView: DiEatChartView = {
        let chartView = DiEatChartView()
        return chartView
    }()

    let label: UILabel = {
        let label = UILabel()
        label.text = "Recipe"
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
                                                 font: .poppins(ofSize: 16, weight: .medium),
                                                 titleColor: UIColor(hexString: "#363062"))
        return button
    }()
    
    let lebel1Button: UIButton = {
        let button = UIButton.createCustomButton(title: "Level 1",
                                                 font: .poppins(ofSize: 16, weight: .medium),
                                                 titleColor: UIColor(hexString: "#BDBDBD"))
        return button
    }()
    
    let lebel2Button: UIButton = {
        let button = UIButton.createCustomButton(title: "level 2",
                                                 font: .poppins(ofSize: 16, weight: .medium),
                                                 titleColor: UIColor(hexString: "#BDBDBD"))
        return button
    }()
    
    let lebel3Button: UIButton = {
        let button = UIButton.createCustomButton(title: "lebel 3",
                                                 font: .poppins(ofSize: 16, weight: .medium),
                                                 titleColor: UIColor(hexString: "#BDBDBD"))
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
    
    @Published var isRecipeType = RecipeType.new
    
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
        [self.allButton, self.lebel1Button, self.lebel2Button, self.lebel3Button].forEach {
            self.filterStackView.addArrangedSubview($0)
        }

        [self.switchButton, self.chartView, self.label, self.filterStackView].forEach {
            self.headerView.addSubview($0)
        }
        
        self.tableView.tableHeaderView = self.headerView
        self.addSubview(self.tableView)
    }
    
    private func setConstraints() {
        self.switchButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.equalToSuperview().inset(28)
            make.height.equalTo(38)
        }
        
        self.chartView.snp.makeConstraints { make in
            make.top.equalTo(self.switchButton.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(28)
            make.height.equalTo(254)
        }
        
        self.label.snp.makeConstraints { make in
            make.top.equalTo(self.chartView.snp.bottom).offset(40)
            make.leading.equalToSuperview().inset(28)
            make.height.equalTo(38)
        }
        
        self.filterStackView.snp.makeConstraints { make in
            make.top.equalTo(self.label.snp.bottom).offset(30)
            make.leading.equalToSuperview().inset(28)
            make.height.equalTo(24)
        }
        
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.headerView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(469)
            make.width.equalTo(self.tableView)
        }
    }
}
