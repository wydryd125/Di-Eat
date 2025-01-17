//
//  BaseViewController.swift
//  Di-Eat
//
//  Created by wjdyukyung on 12/30/24.
//

import UIKit
import SnapKit
import Combine

class DiEatTabBarController: UIViewController {
    // MARK: - Property
    private let headerView = UIView()
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hexString: "#363062")
        label.font = .poppins(ofSize: 24, weight: .bold)
        return label
    }()
    
    private let tabBarView = DiEatTabBarView(tabs: [.calorie, .recipe, .youTube])
    private var currentChildVC: UIViewController?
    private var cancellables = Set<AnyCancellable>()
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.configure()
    }
    
    convenience init(tab: Tab) {
        self.init()
        self.headerLabel.text = tab.rawValue
    }
    
    private func configure() {
        self.headerView.addSubview(self.headerLabel)
        self.view.addSubview(self.headerView)
        self.view.addSubview(self.tabBarView)
        
        self.headerLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(22)
            make.leading.trailing.equalToSuperview().inset(28)
            make.bottom.equalToSuperview().inset(20)
        }
        
        self.headerView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        
        self.tabBarView.snp.makeConstraints { make in
            make.height.equalTo(64)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.tabBarView.$selectedTab
            .sink { [weak self] tab in
                guard let self = self else { return }
                self.moveToVC(tab)
            }
            .store(in: &cancellables)
        
        self.view.bringSubviewToFront(self.headerView)
        self.view.bringSubviewToFront(self.tabBarView)
    }
    
    func moveToVC(_ tab: Tab) {
        self.headerLabel.text = tab.rawValue
        
        switch tab {
        case .calorie:
            let childVC = CalorieViewController()
            self.setChildViewController(childVC)
        case .recipe:
            let childVC = RecipeViewController()
            self.setChildViewController(childVC)
        case .youTube:
            let childVC = YouTubeViewController()
            self.setChildViewController(childVC)
        }
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
