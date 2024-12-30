//
//  DelightSwithButton.swift
//  DELIGHT_iOS
//
//  Created by wjdyukyung on 12/30/24.
//

import UIKit
import Combine

class DelightSwitchButton: UIView {
    var firstButton: UIButton = {
        var attString = AttributedString("week")
        attString.font = UIFont.poppins(ofSize: 16, weight: .medium)
        attString.foregroundColor = .white
        
        var config = UIButton.Configuration.filled()
        config.attributedTitle = attString
        config.baseBackgroundColor = UIColor(hexString: "#363062")
        config.baseForegroundColor = .white
        config.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 17, bottom: 6, trailing: 17)
        
        let button = UIButton(configuration: config)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        return button
    }()
    
    var secondButton: UIButton = {
        var attString = AttributedString("month")
        attString.font = UIFont.poppins(ofSize: 16, weight: .medium)
        attString.foregroundColor = UIColor(hexString: "#6B6B6B")
        
        var config = UIButton.Configuration.filled()
        config.attributedTitle = attString
        config.baseBackgroundColor = UIColor(hexString: "#F5F5F5")
        config.baseForegroundColor = .black
        config.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 17, bottom: 6, trailing: 17)
        
        let button = UIButton(configuration: config)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        return button
    }()
    
    @Published private var isFirstSelected = true
    private var cancellables = Set<AnyCancellable>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        bindUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        let stackView = UIStackView(arrangedSubviews: [firstButton, secondButton])
        stackView.backgroundColor = UIColor(hexString: "#F5F5F5")
        stackView.layer.cornerRadius = 20
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func bindUI() {
        // UI 업데이트 바인딩
        $isFirstSelected
            .sink { [weak self] isSelected in
                guard let self = self else { return }
                if isSelected {
                    self.firstButton.configuration?.baseBackgroundColor = UIColor(hexString: "#363062")
                    self.firstButton.configuration?.baseForegroundColor = .white
                    self.secondButton.configuration?.baseBackgroundColor = UIColor(hexString: "#F5F5F5")
                    self.secondButton.configuration?.baseForegroundColor = .black
                } else {
                    self.firstButton.configuration?.baseBackgroundColor = UIColor(hexString: "#F5F5F5")
                    self.firstButton.configuration?.baseForegroundColor = .black
                    self.secondButton.configuration?.baseBackgroundColor = UIColor(hexString: "#363062")
                    self.secondButton.configuration?.baseForegroundColor = .white
                }
            }
            .store(in: &cancellables)
    }
}
