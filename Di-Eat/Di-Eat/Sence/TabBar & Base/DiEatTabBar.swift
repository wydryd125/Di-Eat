//
//  DiEatTabBarViewModel.swift
//  Di-Eat
//
//  Created by wjdyukyung on 12/30/24.
//

import UIKit

enum Tab: String {
    case calorie = "Calorie"
    case recipe = "Recipe"
    
    func getIconImage() -> UIImage? {
        switch self {
        case .calorie:
            return UIImage(named: "iconCalories")
        case .recipe:
            return UIImage(named: "iconRecipe")
        }
    }
}

class DiEatTabBarView: UIView {
    // MARK: - Property
    var tabs: [Tab]
    @Published var selectedTab: Tab = .calorie
    
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
    }
    
    func updateTabButtonStyle(index: Int) {
        guard let stackView = self.subviews.first(where: { $0 is UIStackView }) as? UIStackView else { return }
        
        stackView.arrangedSubviews.enumerated().forEach { idx, subView in
            guard let button = stackView.arrangedSubviews[idx] as? UIButton,
                  let imageView = button.subviews.first(where: { $0 is UIImageView }) else { return }
            
            if index == idx {
                imageView.tintColor = UIColor(hexString: "#363062")
                imageView.snp.updateConstraints { make in
                    make.centerY.equalToSuperview().offset(-8)
                }
                
                if let focusView = button.subviews.first(where: { $0.tag == 999 }) {
                    focusView.removeFromSuperview()
                }
                
                let focusView = UIView()
                focusView.backgroundColor = UIColor(hexString: "#363062")
                focusView.layer.cornerRadius = 4
                focusView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                focusView.tag = 999
                button.addSubview(focusView)
                
                focusView.snp.makeConstraints { make in
                    make.leading.trailing.equalToSuperview().inset(20)
                    make.bottom.equalToSuperview()
                    make.height.equalTo(5)
                }
            } else {
                imageView.tintColor = UIColor(hexString: "#BDBDBD")
                imageView.snp.updateConstraints { make in
                    make.centerY.equalToSuperview()
                }
                
                if let focusView = button.subviews.first(where: { $0.tag == 999 }) {
                    focusView.removeFromSuperview()
                }
            }
        }
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
        
        self.tabs.enumerated().forEach { (index, tab) in
            let button = UIButton()
            tabStackView.addArrangedSubview(button)
            button.snp.makeConstraints { make in
                make.width.equalTo((UIScreen.main.bounds.width - 56) / 2)
                make.height.equalToSuperview()
            }
            
            let imageView = UIImageView()
            imageView.image = tab.getIconImage()
            imageView.tintColor = UIColor(hexString: "#BDBDBD")
            button.addSubview(imageView)
            
            imageView.snp.makeConstraints { make in
                make.width.height.equalTo(28)
                make.centerX.centerY.equalToSuperview()
            }
            
            button.tag = index
            button.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)
            
            self.updateTabButtonStyle(index: 0)
        }
    }
    
    @objc private func tabButtonTapped(_ sender: UIButton) {
        guard let index = self.tabs.firstIndex(where: { tab in
            return tab == self.tabs[sender.tag] }) else { return }
        
        self.selectedTab = self.tabs[index]
        self.updateTabButtonStyle(index: index)
    }
}
