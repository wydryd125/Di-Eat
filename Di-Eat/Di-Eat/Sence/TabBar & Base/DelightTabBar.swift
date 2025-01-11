//
//  DelightTabBar.swift
//  DELIGHT_iOS
//
//  Created by wjdyukyung on 12/30/24.
//

import UIKit

enum Tab {
    case booking
    case card
    case transaction
    case profile
    
    func getIconImage() -> UIImage? {
        switch self {
        case .booking:
            return UIImage(named: "iconBooking")
        case .card:
            return UIImage(named: "iconCard")
        case .transaction:
            return UIImage(named: "iconActivity")
        case .profile:
            return UIImage(named: "iconMy")
        }
    }
}

// MARK: - ViewModel
class DelightTabBarViewModel {
    @Published var selectedTab: Tab = .transaction
    
    func didTapTabBarButton(tab: Tab) {
        selectedTab = tab
    }
}

class DelightTabBarView: UIView {
    // MARK: - Property
    var tabs: [Tab]
    
    @Published var selectedTab: Tab = .transaction
    var didSelectTab: ((Tab) -> Void)?
    
    init(tabs: [Tab]) {
        self.tabs = tabs
        super.init(frame: .zero)
        
        self.setAttribute()
        self.setConstraint()
    }
    
    // MARK: - Life Cycle
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAttribute() {
        self.backgroundColor = .white
        self.selectedTab = .transaction
    }
    
    func setConstraint() {
        let tabStackView = UIStackView()
        tabStackView.axis = .horizontal
        tabStackView.distribution = .fillEqually
        tabStackView.alignment = .center
        tabStackView.spacing = 0
        self.addSubview(tabStackView)
        
        tabStackView.snp.makeConstraints { make in
            make.height.equalTo(64)
            make.centerX.bottom.equalToSuperview()
        }
        
        self.tabs.forEach { tab in
            let button = UIButton()
            tabStackView.addArrangedSubview(button)
            button.snp.makeConstraints { make in
                make.width.equalTo((UIScreen.main.bounds.width - 56) / 4)
                make.height.equalToSuperview()
            }
            
            let imageView = UIImageView()
            imageView.image = tab.getIconImage()
            imageView.tintColor = UIColor(hexString: "#BDBDBD")
            button.addSubview(imageView)
            
            imageView.snp.makeConstraints { make in
                make.width.height.equalTo(24)
                make.centerX.centerY.equalToSuperview()
            }
            
            if tab == self.selectedTab {
                imageView.tintColor = UIColor(hexString: "#363062")
                imageView.snp.updateConstraints { make in
                    make.centerY.equalToSuperview().offset(-8)
                }
                
                let highlightView = UIView()
                highlightView.backgroundColor = UIColor(hexString: "#363062")
                highlightView.layer.cornerRadius = 4
                highlightView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
                button.addSubview(highlightView)
                
                highlightView.snp.makeConstraints { make in
                    make.leading.trailing.equalToSuperview().inset(20)
                    make.bottom.equalToSuperview()
                    make.height.equalTo(5)
                }
            }
            button.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)
        }
    }
    
    @objc private func tabButtonTapped(_ sender: UIButton) {
        guard let buttonIndex = sender.superview?.subviews.firstIndex(of: sender) else { return }
        
        let selectedTab = tabs[buttonIndex]
        self.didSelectTab?(selectedTab)
    }
}
