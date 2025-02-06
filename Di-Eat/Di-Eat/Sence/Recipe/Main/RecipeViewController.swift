//
//  RecipeViewController.swift
//  Di-Eat
//
//  Created by wjdyukyung on 12/30/24.
//

import UIKit
import Combine

class RecipeViewController: BaseViewController {
    // MARK: - Property
    private let rootView = RecipeView()
    private var collectionViewSelectionSubject = PassthroughSubject<Recipe, Never>()
    private var collectionViewDataSource: UICollectionViewDiffableDataSource<Int, Recipe>!
    
    private var tableViewSelectionSubject = PassthroughSubject<Recipe, Never>()
    private var dataSource: UITableViewDiffableDataSource<Int, Recipe>!
    private let viewModel = RecipeViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configure()
        self.viewModel.bind()
        self.bindViewModel()
        self.bindlLevelButton()
        self.bindMoreButton()
    }

    private func bindViewModel() {
        // isLoading 바인딩
        self.viewModel.$isLoading
            .sink { [weak self] isLoading in
                guard let self = self else { return }
                self.updateUI(isLoading: isLoading)
            }
            .store(in: &cancellables)
    }
    
    private func bindlLevelButton() {
        self.rootView.levelButtonView.selectedLevelPublisher
            .sink { [weak self] level in
                guard let self = self else { return }
                self.viewModel.level = level
                self.updateTableView()
            }
            .store(in: &cancellables)
    }

    private func bindMoreButton() {
        self.rootView.bestButton
            .throttleTapPublisher()
            .sink { [weak self] _ in
                guard let self = self,
                      let recipes = viewModel.recipes else { return }
                
                let viewModel = RecipeListViewModel(type: .best, list: recipes)
                let listVC = RecipeListViewController(viewModel: viewModel)
                self.navigationController?.pushViewController(listVC, animated: true)
            }
            .store(in: &cancellables)
        
        self.rootView.newButton
            .throttleTapPublisher()
            .sink { [weak self] _ in
                guard let self = self,
                      let recipes = viewModel.recipes else { return }
                
                let viewModel = RecipeListViewModel(type: .new, list: recipes)
                let listVC = RecipeListViewController(viewModel: viewModel)
                self.navigationController?.pushViewController(listVC, animated: true)
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
        
        self.rootView.collectionView.delegate = self
        self.collectionViewSelectionSubject
            .sink { [weak self] recipe in
                guard let self = self else { return }
                let viewModel = RecipeDetailViewModel(recipe: recipe)
                let detailVC = RecipeDetailViewController(viewModel: viewModel, isBest: true)
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
            .store(in: &cancellables)
    }
    
    private func updateTableView() {
        self.rootView.tableView.reloadData()
        
        guard let latestRecipes = self.viewModel.getLevelTypeRecipe() else { return }
        let currentOffset = self.rootView.tableView.contentOffset
        var snapshot = NSDiffableDataSourceSnapshot<Int, Recipe>()
        snapshot.appendSections([0])
        snapshot.appendItems(latestRecipes)
        
        self.dataSource.apply(snapshot, animatingDifferences: false) { [weak self] in
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
        
        self.rootView.tableView.delegate = self
        self.tableViewSelectionSubject
            .sink { [weak self] recipe in
                guard let self = self else { return }
                let viewModel = RecipeDetailViewModel(recipe: recipe)
                let detailVC = RecipeDetailViewController(viewModel: viewModel)
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
            .store(in: &cancellables)
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

extension RecipeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let recipe = collectionViewDataSource.itemIdentifier(for: indexPath) else { return }
        collectionViewSelectionSubject.send(recipe)
    }
}


extension RecipeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let recipe = dataSource.itemIdentifier(for: indexPath) else { return }
        tableViewSelectionSubject.send(recipe)
    }
}
