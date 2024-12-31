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
        let button = UIButton.createCustomButton(title: "Week",
                                                 font: .poppins(ofSize: 16, weight: .medium),
                                                 titleColor: .white,
                                                 backgroundColor: UIColor(hexString: "#363062"),
                                                 cornerRadius: 20,
                                                 contentInsets: NSDirectionalEdgeInsets(top: 6, leading: 17, bottom: 6, trailing: 17))
        return button
    }()
    
    var secondButton: UIButton = {
        let button = UIButton.createCustomButton(title: "Month",
                                                 font: .poppins(ofSize: 16, weight: .medium),
                                                 titleColor: UIColor(hexString: "#6B6B6B"),
                                                 backgroundColor: UIColor(hexString: "#F5F5F5"),
                                                 cornerRadius: 20,
                                                 contentInsets: NSDirectionalEdgeInsets(top: 6, leading: 17, bottom: 6, trailing: 17))
        return button
    }()
    
    @Published var isFirstSelected = true
    private var cancellables = Set<AnyCancellable>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        bindButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
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
    
    private func bindButton() {
        self.firstButton.throttleTapPublisher()
            .map { [weak self] _ in
                guard let self = self else { return }
                self.isFirstSelected = true
            }
            .sink {
                print("first tap tap!!!")
            }
            .store(in: &cancellables)
        
        self.secondButton.throttleTapPublisher()
            .map { [weak self] _ in
                guard let self = self else { return }
                self.isFirstSelected = false
            }
            .sink {
                print("second tap tap!!!")
            }
            .store(in: &cancellables)
        
        self.$isFirstSelected
            .sink { [weak self] isSelected in
                guard let self = self else { return }
                self.updateButton(isSelected: isSelected)
            }
            .store(in: &cancellables)
    }
    
    private func updateButton(isSelected: Bool) {
        if isSelected {
            setButtonStyle(button: self.firstButton, title: "Week", backgroundColor: UIColor(hexString: "#363062"), textColor: .white)
            setButtonStyle(button: self.secondButton, title: "Month", backgroundColor: UIColor(hexString: "#F5F5F5"), textColor: UIColor(hexString: "#6B6B6B"))
        } else {
            setButtonStyle(button: self.firstButton, title: "Week", backgroundColor: UIColor(hexString: "#F5F5F5"), textColor: UIColor(hexString: "#6B6B6B"))
            setButtonStyle(button: self.secondButton, title: "Month", backgroundColor: UIColor(hexString: "#363062"), textColor: .white)
        }
    }
    
    private func setButtonStyle(button: UIButton, title: String, backgroundColor: UIColor, textColor: UIColor) {
        button.configuration?.baseBackgroundColor = backgroundColor
        button.configuration?.baseForegroundColor = textColor
        
        var attString = AttributedString(title)
        attString.font = .poppins(ofSize: 16, weight: .medium)
        attString.foregroundColor = textColor
        button.configuration?.attributedTitle = attString
    }
}
