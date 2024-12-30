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
    case activity
    case profile
    
    func getIconImage() -> UIImage? {
        switch self {
        case .booking:
            return UIImage(named: "iconBooking")
        case .card:
            return UIImage(named: "iconCard")
        case .activity:
            return UIImage(named: "iconActivity")
        case .profile:
            return UIImage(named: "iconMy")
        }
    }
}

// MARK: - ViewModel
class DelightTabBarViewModel {
    @Published var selectedTab: Tab = .activity
    
    func didTapTabBarButton(tab: Tab) {
        selectedTab = tab
    }
}

class DelightTabBarView: UIView {
    var tabs: [Tab]
    @Published var selectedTab: Tab = .activity
    
    init(tabs: [Tab]) {
        self.tabs = tabs
        super.init(frame: .zero)
        
        self.setAttribute()
        self.setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAttribute() {
        self.backgroundColor = .white
    }
    
    func setConstraint() {
        let tabStackView = UIStackView()
        self.addSubview(tabStackView)
        tabStackView.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.centerX.bottom.equalToSuperview()
        }
        
        self.tabs.forEach { tab in
            let button = UIButton()
            tabStackView.addArrangedSubview(button)
            button.snp.makeConstraints { make in
                make.width.equalTo((UIScreen.main.bounds.width - 56) / 4)
                make.height.equalTo(80)
            }
            let imageView = UIImageView()
            imageView.image = tab.getIconImage()
            imageView.tintColor = tab == self.selectedTab ? UIColor(hexString: "#363062") : UIColor(hexString: "#BDBDBD")
            
            button.addSubview(imageView)

            if tab == self.selectedTab {
                imageView.snp.makeConstraints { make in
                    make.width.height.equalTo(24)
                    make.centerX.equalToSuperview()
                    make.centerY.equalToSuperview().offset(-8)
                }
                
                let view = UIView()
                view.backgroundColor = UIColor(hexString: "#363062")
                view.layer.cornerRadius = 4
                view.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
                button.addSubview(view)
                
                view.snp.makeConstraints { make in
                    make.leading.trailing.equalToSuperview().inset(20)
                    make.bottom.equalToSuperview()
                    make.height.equalTo(5)
                }
            } else {
                imageView.snp.makeConstraints { make in
                    make.width.height.equalTo(24)
                    make.centerX.centerY.equalToSuperview()
                }
            }
        }
    }
}
