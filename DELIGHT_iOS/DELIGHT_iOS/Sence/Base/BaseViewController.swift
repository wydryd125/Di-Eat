//
//  BaseViewController.swift
//  DELIGHT_iOS
//
//  Created by wjdyukyung on 12/30/24.
//

import UIKit
import SnapKit

// 수정 MVVM
class BaseViewController: UIViewController {
    private let tabBarView = DelightTabBarView(tabs: [.booking, .card, .activity, .profile])
    private var viewModel = DelightTabBarViewModel()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.configure()
    }
    
    private func configure() {
        [self.tabBarView].forEach {
            self.view.addSubview($0)
        }
        
        self.tabBarView.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func selectedTab(tab: Tab) {
        self.viewModel.didTapTabBarButton(tab: tab)
    }

}
