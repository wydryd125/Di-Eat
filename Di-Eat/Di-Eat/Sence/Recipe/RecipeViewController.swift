//
//  RecipeViewController.swift
//  Di-Eat
//
//  Created by wjdyukyung on 12/30/24.
//

import UIKit
import Combine

class RecipeViewController: BaseViewController, UITableViewDelegate {
    // MARK: - Property
    private let rootView = RecipeView()
    private var dataSource: UITableViewDiffableDataSource<Int, Recipe>!
    
    private let viewModel = RecipeViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Life Cycle
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
        
        
        // tableView 바인딩
//        self.viewModel.$latestTransactions
//            .sink { [weak self] _ in
//                guard let self = self else { return }
//                DispatchQueue.main.async {
//                    self.updateTableView()
//                }
//            }
//            .store(in: &cancellables)
        
    }
    
    private func bindFilterButton() {
        [self.rootView.allButton, self.rootView.expenseButton, self.rootView.incomeButton].forEach {
            $0.throttleTapPublisher()
                .map { button in
                    return button.tag
                }
                .sink { [weak self] tag in
                    guard let self = self else { return }
                }
                .store(in: &cancellables)
        }
    }
    
    private func bindSwitchButton() {
//        self.rootView.switchButton.$isFirstSelected
//            .sink { [weak self] isFirst in
//                guard let self = self else { return }
////                self.viewModel.duration = duration
//            }
//            .store(in: &cancellables)
    }
    
    private func updateUI(isLoading: Bool) {
        if isLoading {
            print("Loading...")
        } else {
            print("Loading complete!!!")
            self.updateTableView()
        }
    }

    private func updateTableView() {
        guard let latestRecipes = self.viewModel.latestRecipes else { return }
        let currentOffset = self.rootView.tableView.contentOffset
        var snapshot = NSDiffableDataSourceSnapshot<Int, Recipe>()
        snapshot.appendSections([0])
        snapshot.appendItems(latestRecipes)
        
        self.dataSource.apply(snapshot, animatingDifferences: true) { [weak self] in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.rootView.tableView.setContentOffset(currentOffset, animated: false)
            }
        }
    }
    
    private func configureTableView() {
        self.dataSource = UITableViewDiffableDataSource<Int, Recipe>(tableView: self.rootView.tableView) { tableView, indexPath, recipe in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RecipeCell.identifier, for: indexPath) as? RecipeCell else {
                fatalError("Error dequeuing RecipeCell")
            }
            cell.drawCell()
            return cell
        }
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
