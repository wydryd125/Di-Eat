//
//  TransactionViewController.swift
//  DELIGHT_iOS
//
//  Created by wjdyukyung on 12/30/24.
//

import UIKit
import Combine

class TransactionViewController: BaseViewController, UITableViewDelegate {
    private let rootView = TransactionView()
    private var dataSource: UITableViewDiffableDataSource<Int, TransactionData>!
    
    private let viewModel = TransactionViewModel()
    @Published var type = TransactionType.all
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configure()
        self.viewModel.bind()
        self.bindViewModel()
        self.bindSwitchButton()
        self.bindFilterButton()
        self.configureTableView()
    }
    
    private func bindViewModel() {
        // isLoading 바인딩
        self.viewModel.$isLoading
            .sink { [weak self] isLoading in
                guard let self = self else { return }
                self.updateUI(isLoading: isLoading)
            }
            .store(in: &cancellables)
        
        // chartView 바인딩
        self.viewModel.$chartData
            .sink { [weak self] data in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.rootView.chartView.updateChartView(data: data)
                }
            }
            .store(in: &cancellables)
        
        // tableView 바인딩
        self.viewModel.$latestTransactions
            .sink { [weak self] _ in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.updateTableView()
                }
            }
            .store(in: &cancellables)
    }
    
    private func bindFilterButton() {
        [self.rootView.allButton, self.rootView.expenseButton, self.rootView.incomeButton].forEach {
            $0.throttleTapPublisher()
                .map { button in
                    return button.tag
                }
                .sink { [weak self] tag in
                    guard let self = self else { return }
                    self.type = TransactionType(rawValue: tag) ?? .all
                    self.viewModel.type = self.type
                    self.rootView.updateFilterButton(type: self.type)
                }
                .store(in: &cancellables)
        }
    }
    
    private func bindSwitchButton() {
        self.rootView.switchButton.$isFirstSelected
            .sink { [weak self] isFirst in
                guard let self = self else { return }
                let duration = isFirst ? DurationType.week : DurationType.month
                self.viewModel.duration = duration
            }
            .store(in: &cancellables)
    }
    
    private func updateUI(isLoading: Bool) {
        if isLoading {
            print("Loading...")
        } else {
            print("Loading complete")
            self.updateTableView()
        }
    }
    
    private func configureTableView() {
        self.dataSource = UITableViewDiffableDataSource<Int, TransactionData>(tableView: self.rootView.tableView) { tableView, indexPath, transaction in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TransactionCell.identifier, for: indexPath) as? TransactionCell else {
                fatalError("Error dequeuing TransactionCell")
            }
            cell.drawCell(data: transaction)
            return cell
        }
    }

    private func updateTableView() {
        guard let latestTransactions = self.viewModel.latestTransactions else { return }
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, TransactionData>()
        snapshot.appendSections([0])
        snapshot.appendItems(latestTransactions)
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }

    private func configure() {
        self.view.addSubview(self.rootView)
        
        self.rootView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}
