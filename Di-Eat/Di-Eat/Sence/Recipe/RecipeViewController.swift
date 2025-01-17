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
    private var collectionViewDataSource: UICollectionViewDiffableDataSource<Int, Recipe>!
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
        [self.rootView.allButton, self.rootView.level1Button, self.rootView.level2Button, self.rootView.level3Button].forEach {
            $0.throttleTapPublisher()
                .map { button in
                    return button.tag
                }
                .sink { [weak self] level in
                    guard let self = self else { return }
                    self.rootView.updateLevelbutton(level: LevelType(rawValue: level) ?? .all)
                }
                .store(in: &cancellables)
        }
    }
    
    private func bindSwitchButton() {
        self.rootView.switchButton.$isFirstSelected
            .sink { [weak self] isFirst in
                guard let self = self else { return }
                let type = isFirst ? RecipeType.new : RecipeType.best
                self.rootView.updateRecipeView(type: type)
            }
            .store(in: &cancellables)
    }
    
    private func updateUI(isLoading: Bool) {
        if isLoading {
            print("Loading...")
        } else {
            print("Loading complete!!!")
            self.updateCollecionView()
            self.updateTableView()
        }
    }

    private func updateCollecionView() {
        guard let latestRecipes = self.viewModel.getRecommendRecipe() else { return }
        let currentOffset = self.rootView.tableView.contentOffset
        var snapshot = NSDiffableDataSourceSnapshot<Int, Recipe>()
        snapshot.appendSections([0])
        snapshot.appendItems(latestRecipes)
        
        self.collectionViewDataSource.apply(snapshot, animatingDifferences: true)
        self.rootView.collectionView.layoutIfNeeded()
    }
    
    private func configureCollecionView() {
        self.rootView.collectionView.register(RecipeCollectionViewCell.self, forCellWithReuseIdentifier: RecipeCollectionViewCell.identifier)
        self.collectionViewDataSource = UICollectionViewDiffableDataSource<Int, Recipe>(collectionView: self.rootView.collectionView) { collectionView, indexPath, recipe in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCollectionViewCell.identifier, for: indexPath) as? RecipeCollectionViewCell else {
                fatalError("Error dequeuing RecipeCollectionViewCell")
            }
            cell.drawCell(index: indexPath.row + 1, recipe: recipe)
            return cell
        }
    }
        
    private func updateTableView() {
        guard let latestRecipes = self.viewModel.getLatestRecipe() else { return }
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
            cell.drawCell(recipe: recipe)
            return cell
        }
    }

    private func configure() {
        self.configureCollecionView()
        self.configureTableView()
        
        self.view.addSubview(self.rootView)
        
        self.rootView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}
