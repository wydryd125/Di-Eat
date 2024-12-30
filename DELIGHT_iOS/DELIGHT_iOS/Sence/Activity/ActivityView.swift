import UIKit
import Combine
import SnapKit

enum TransactionType: Int {
    case all = 0
    case expense
    case income
}

class ActivityView: BaseView {
    // MARK: - Property
    private let headerView: UIView = {
        let view = UIView()
        let label = UILabel()
        label.text = "Activity"
        label.textColor = .black
        label.font = .poppins(ofSize: 24, weight: .bold)
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(22)
            make.leading.trailing.equalToSuperview().inset(28)
            make.bottom.equalToSuperview().inset(20)
        }
        return view
    }()
    
    let switchButton: DelightSwitchButton = {
        let button = DelightSwitchButton()
        return button
    }()
    
    let chartView: DelightChartView = {
        let chartView = DelightChartView()
        return chartView
    }()
    
    let titleLabel: UILabel = {
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
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.clipsToBounds = true
        tableView.backgroundColor = .white
        tableView.contentInsetAdjustmentBehavior = .always
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(ActivityTableViewCell.self, forCellReuseIdentifier: ActivityTableViewCell.identifier)
        return tableView
    }()
    
    @Published var isTransactionType = TransactionType.all
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setConstraints()
        bindButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bindButton() {
        [self.allButton, self.expenseButton, self.incomeButton].forEach {
            $0.throttleTapPublisher()
                .map { button in
                    return button.tag
                }
                .sink { [weak self] tag in
                    guard let self = self else { return }
                    self.isTransactionType = TransactionType(rawValue: tag) ?? .all
                    self.updateFilterButton(type: self.isTransactionType)
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
    
    private func setUI() {
        self.addSubview(self.headerView)
        self.addSubview(self.switchButton)
        
        [self.allButton, self.expenseButton, self.incomeButton].forEach {
            self.filterStackView.addArrangedSubview($0)
        }

        self.addSubview(self.chartView)
        self.addSubview(self.titleLabel)
        self.addSubview(self.filterStackView)
        self.addSubview(self.tableView)
    }
    
    private func setConstraints() {
        self.headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        self.switchButton.snp.makeConstraints { make in
            make.top.equalTo(self.headerView.snp.bottom)
            make.leading.equalToSuperview().inset(28)
            make.height.equalTo(38)
        }
        
        self.chartView.snp.makeConstraints { make in
            make.top.equalTo(self.switchButton.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(28)
            make.height.equalTo(254)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.chartView.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(28)
        }
        
        self.filterStackView.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(30)
            make.leading.equalToSuperview().inset(28)
            make.height.equalTo(24)
        }
        
        self.tableView.snp.makeConstraints { make in
            make.top.equalTo(self.filterStackView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(80)
        }
    }
}
