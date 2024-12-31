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
    private let tabBarView = DelightTabBarView(tabs: [.booking, .card, .transaction, .profile])
    private var viewModel = DelightTabBarViewModel()
    private var currentChildVC: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.configure()
        self.handleTabSelection(.transaction)
    }
    
    private func configure() {
        self.view.addSubview(tabBarView)
        
        tabBarView.snp.makeConstraints { make in
            make.height.equalTo(64)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        tabBarView.didSelectTab = { [weak self] tab in
            self?.handleTabSelection(tab)
        }
        
        self.view.bringSubviewToFront(tabBarView)
    }
    
    func handleTabSelection(_ tab: Tab) {
        self.viewModel.didTapTabBarButton(tab: tab)
        let childVC = TransactionViewController()
        setChildViewController(childVC)
    }
    
    func setChildViewController(_ childVC: UIViewController) {
        currentChildVC?.willMove(toParent: nil)
        currentChildVC?.view.removeFromSuperview()
        currentChildVC?.removeFromParent()
        
        addChild(childVC)
        self.view.addSubview(childVC.view)
        
        childVC.view.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.tabBarView.snp.top)
        }
        
        childVC.didMove(toParent: self)
        currentChildVC = childVC
    }
}
