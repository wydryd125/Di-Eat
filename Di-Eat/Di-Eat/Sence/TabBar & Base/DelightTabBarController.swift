//
//  BaseViewController.swift
//  DELIGHT_iOS
//
//  Created by wjdyukyung on 12/30/24.
//

import UIKit
import SnapKit
import Combine

class DelightTabBarController: UIViewController {
    // MARK: - Property
    private let headerView: UIView = {
        let view = UIView()
        let label = UILabel()
        label.text = "Transaction"
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
    private let tabBarView = DelightTabBarView(tabs: [.booking, .card, .transaction, .profile])
    private var viewModel = DelightTabBarViewModel()
    private var currentChildVC: UIViewController?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.configure()
        self.handleTabSelection(.transaction)
    }
    
    private func configure() {
        self.view.addSubview(self.headerView)
        self.view.addSubview(self.tabBarView)
        
        self.headerView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        
        self.tabBarView.snp.makeConstraints { make in
            make.height.equalTo(64)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.tabBarView.didSelectTab = { [weak self] tab in
            self?.handleTabSelection(tab)
        }
        
        self.view.bringSubviewToFront(self.headerView)
        self.view.bringSubviewToFront(self.tabBarView)
    }
    
    func handleTabSelection(_ tab: Tab) {
        self.viewModel.didTapTabBarButton(tab: tab)
        let childVC = TransactionViewController()
        self.setChildViewController(childVC)
    }
    
    func setChildViewController(_ childVC: UIViewController) {
        self.currentChildVC?.willMove(toParent: nil)
        self.currentChildVC?.view.removeFromSuperview()
        self.currentChildVC?.removeFromParent()
        
        self.addChild(childVC)
        self.view.addSubview(childVC.view)
        
        childVC.view.snp.makeConstraints { make in
            make.top.equalTo(self.headerView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.tabBarView.snp.top)
        }
        
        childVC.didMove(toParent: self)
        currentChildVC = childVC
    }
}
