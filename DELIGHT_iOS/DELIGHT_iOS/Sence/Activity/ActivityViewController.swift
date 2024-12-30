//
//  ActivityViewController.swift
//  DELIGHT_iOS
//
//  Created by wjdyukyung on 12/30/24.
//

import UIKit
import Combine

class ActivityViewController: BaseViewController, UITableViewDelegate {
    private let rootView = ActivityView()
    private var dataSource: UITableViewDiffableDataSource<Int, UUID>!
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configure()
        self.bindViewModel()
        self.setTableView()
    }
    
    private func configure() {
        self.view.addSubview(self.rootView)
        self.rootView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func bindViewModel() {
        
    }
    
    private func setTableView() {
        self.dataSource = UITableViewDiffableDataSource<Int, UUID>(
            tableView: self.rootView.tableView,
            cellProvider: { tableView, indexPath, data in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ActivityTableViewCell.identifier,
                                                               for: indexPath) as? ActivityTableViewCell else { fatalError() }
                cell.drawCell(data: "Sample Data")
                return cell
            })
        
        self.rootView.tableView.delegate = self
        self.rootView.tableView.dataSource = self.dataSource
        
        let list = [UUID(), UUID(), UUID(), UUID()]
        var snapshot = NSDiffableDataSourceSnapshot<Int, UUID>()
        snapshot.appendSections([0])
        snapshot.appendItems(list)
        
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }
}

