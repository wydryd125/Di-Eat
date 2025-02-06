//
//  RecipeListViewController.swift
//  Di-Eat
//
//  Created by wjdyukyung on 1/31/25.
//

import UIKit
import Combine

class RecipeListViewController: BaseViewController {
    // MARK: - Property
    private let rootView = RecipeListView()
    private var tableViewSelectionSubject = PassthroughSubject<Recipe, Never>()
    private var dataSource: UITableViewDiffableDataSource<Int, Recipe>!
    private var viewModel: RecipeListViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Life Cycle
    convenience init(viewModel: RecipeListViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configure()
        self.bindViewModel()
        self.bindSwitchButton()
        self.bindlLevelButton()
    }
    
    private func bindViewModel() {
        self.updateTableView()
    }
    
    private func bindSwitchButton() {
        self.rootView.switchButton.updateButton(tag: self.viewModel.type == .new ? 0 : 1)
        self.rootView.switchButton.$isFirstSelected
            .sink { [weak self] isFirst in
                guard let self = self else { return }
                let type = isFirst ?? true ? RecipeType.new : RecipeType.best
                self.viewModel.type = type
                self.updateTableView()
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
    
    private func updateTableView() {
        self.rootView.tableView.reloadData()
        
        let recipes = self.viewModel.type == .new ? self.viewModel.getRecipes() : self.viewModel.getRecommendRecipes()
        let currentOffset = self.rootView.tableView.contentOffset
        var snapshot = NSDiffableDataSourceSnapshot<Int, Recipe>()
        snapshot.appendSections([0])
        snapshot.appendItems(recipes)
        
        self.dataSource.apply(snapshot, animatingDifferences: false) { [weak self] in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.rootView.tableView.setContentOffset(currentOffset, animated: false)
            }
        }
    }
    
    private func configureTableView() {
        self.dataSource = UITableViewDiffableDataSource<Int, Recipe>(tableView: self.rootView.tableView) { tableView, indexPath, recipe in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RecipeListTableViewCell.identifier, for: indexPath) as? RecipeListTableViewCell else {
                fatalError("Error dequeuing RecipeCell")
            }
            cell.drawCell(type: self.viewModel.type, recipe: recipe, index: indexPath.row + 1)
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
        self.configureTableView()
        
        self.view.addSubview(self.rootView)
        self.rootView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

extension RecipeListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let recipe = dataSource.itemIdentifier(for: indexPath) else { return }
        tableViewSelectionSubject.send(recipe)
    }
}
