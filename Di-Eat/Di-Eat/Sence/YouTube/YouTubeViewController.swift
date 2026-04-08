//
//  YouTubeViewController.swift
//  Di-Eat
//
//  Created by wjdyukyung on 1/17/25.
//

import UIKit
import Combine

class YouTubeViewController: BaseViewController {
    // MARK: - Property
    private let rootView = YouTubeView()
    private var tableViewSelectionSubject = PassthroughSubject<YouTube, Never>()
    private var dataSource: UITableViewDiffableDataSource<Int, YouTube>!
    private let viewModel = YoutubeViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configure()
        self.viewModel.bind()
        self.bindViewModel()
    }
    
    private func bindViewModel() {
        // isLoading 바인딩
        self.viewModel.$isLoading
            .sink { [weak self] isLoading in
                guard let self = self else { return }
                print(isLoading)
                self.updateTableView()
            }
            .store(in: &cancellables)
    }
    
    private func updateTableView() {
        self.rootView.tableView.reloadData()
        
        guard let youtubes = self.viewModel.youtubes else { return }
        let currentOffset = self.rootView.tableView.contentOffset
        var snapshot = NSDiffableDataSourceSnapshot<Int, YouTube>()
        snapshot.appendSections([0])
        snapshot.appendItems(youtubes)
        
        self.dataSource.apply(snapshot, animatingDifferences: false) { [weak self] in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.rootView.tableView.setContentOffset(currentOffset, animated: false)
            }
        }
    }
    
    private func configureTableView() {
        self.dataSource = UITableViewDiffableDataSource<Int, YouTube>(tableView: self.rootView.tableView) { tableView, indexPath, youtube in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: YouTubeCell.identifier, for: indexPath) as? YouTubeCell else {
                fatalError("Error dequeuing RecipeCell")
            }
            cell.drawCell(youTube: youtube)
            return cell
        }
        
        self.rootView.tableView.delegate = self
        self.tableViewSelectionSubject
            .sink { [weak self] recipe in
                guard let self = self else { return }
//                let viewModel = RecipeDetailViewModel(recipe: recipe)
//                let detailVC = RecipeDetailViewController(viewModel: viewModel)
//                self.navigationController?.pushViewController(detailVC, animated: true)
            }
        
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

extension YouTubeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let youtube = dataSource.itemIdentifier(for: indexPath) else { return }
        tableViewSelectionSubject.send(youtube)
    }
}
