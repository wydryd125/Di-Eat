//
//  TransactionFilterCell.swift
//  DELIGHT_iOS
//
//  Created by wjdyukyung on 12/31/24.
//

import UIKit
import Combine

class TransactionFilterCell: UITableViewCell {
    // MARK: - Property
    static let identifier = "TransactionFilterCell"
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "Recent Transactions"
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
        button.tag = TransactionType.all.rawValue
        return button
    }()
    
    let expenseButton: UIButton = {
        let button = UIButton.createCustomButton(title: "Expense",
                                                 font: .poppins(ofSize: 16, weight: .medium),
                                                 titleColor: UIColor(hexString: "#BDBDBD"))
        button.tag = TransactionType.expense.rawValue
        return button
    }()
    
    let incomeButton: UIButton = {
        let button = UIButton.createCustomButton(title: "Income",
                                                 font: .poppins(ofSize: 16, weight: .medium),
                                                 titleColor: UIColor(hexString: "#BDBDBD"))
        button.tag = TransactionType.income.rawValue
        return button
    }()
    
    @Published var type = TransactionType.all
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setUI()
        self.setConstraints()
        self.bindButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func drawCell() {
    }
    
    private func setUI() {
        self.contentView.backgroundColor = .white
        
        [self.allButton, self.expenseButton, self.incomeButton].forEach {
            self.filterStackView.addArrangedSubview($0)
        }
        
        [self.label, self.filterStackView].forEach {
            self.contentView.addSubview($0)
        }
    }
    
    private func bindButton() {
        [self.allButton, self.expenseButton, self.incomeButton].forEach {
            $0.throttleTapPublisher()
                .map { button in
                    return button.tag
                }
                .sink { [weak self] tag in
                    guard let self = self else { return }
                    self.type = TransactionType(rawValue: tag) ?? .all
                    self.updateFilterButton(type: self.type)
                }
                .store(in: &cancellables)
        }
    }
    
    private func updateFilterButton(type: TransactionType) {
        [self.allButton, self.expenseButton, self.incomeButton].enumerated().forEach { idx, button in
            let title: String
            switch idx {
            case TransactionType.all.rawValue:
                title = "All"
            case TransactionType.expense.rawValue:
                title = "Expense"
            case TransactionType.income.rawValue:
                title = "Income"
            default:
                title = ""
            }
            
            let fontColor = (type.rawValue == idx) ? "#363062" : "#BDBDBD"
            
            var attString = AttributedString(title)
            attString.font = .poppins(ofSize: 16, weight: .medium)
            attString.foregroundColor = UIColor(hexString: fontColor)
            
            button.configuration?.attributedTitle = attString
        }
    }
    
    private func setConstraints() {
        self.label.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(40)
            make.leading.equalToSuperview().inset(28)
            make.height.equalTo(38)
        }
        
        self.filterStackView.snp.makeConstraints { make in
            make.top.equalTo(self.label.snp.bottom).offset(30)
            make.leading.equalToSuperview().inset(28)
            make.bottom.equalToSuperview().inset(20)
            make.height.equalTo(24)
        }
    }

}
