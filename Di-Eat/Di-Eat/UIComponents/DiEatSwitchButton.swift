//
//  DiEatSwitchButton.swift
//  Di-Eat
//
//  Created by wjdyukyung on 12/30/24.
//

import UIKit
import Combine

class DiEatSwitchButton: UIView {
    var firstButton: UIButton = {
        let button = UIButton.createCustomButton(title: "New",
                                                 font: .poppins(ofSize: 16, weight: .medium),
                                                 titleColor: .white,
                                                 backgroundColor: UIColor(hexString: "#363062"),
                                                 cornerRadius: 20,
                                                 contentInsets: NSDirectionalEdgeInsets(top: 6, leading: 17, bottom: 6, trailing: 17))
        button.tag = 0
        return button
    }()
    
    var secondButton: UIButton = {
        let button = UIButton.createCustomButton(title: "Best",
                                                 font: .poppins(ofSize: 16, weight: .medium),
                                                 titleColor: UIColor(hexString: "#6B6B6B"),
                                                 backgroundColor: UIColor(hexString: "#F5F5F5"),
                                                 cornerRadius: 20,
                                                 contentInsets: NSDirectionalEdgeInsets(top: 6, leading: 17, bottom: 6, trailing: 17))
        button.tag = 1
        return button
    }()

    @Published var isFirstSelected = true
    private var cancellables = Set<AnyCancellable>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setLayout()
        self.bindButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        let stackView = UIStackView(arrangedSubviews: [self.firstButton, self.secondButton])
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
        [self.firstButton, self.secondButton].forEach { button in
            button.throttleTapPublisher()
                .sink { [weak self] _ in
                    guard let self = self else { return }
                    self.updateButton(tag: button.tag)
                    self.isFirstSelected = button.tag == 0 ? true : false
                }
                .store(in: &cancellables)
        }
    }
    
    private func updateButton(tag: Int) {
        [self.firstButton, self.secondButton].forEach { button in
            guard let title = button.configuration?.title else { return }
            if button.tag == tag {
                setButtonStyle(button: button, title: title, backgroundColor: UIColor(hexString: "#363062"), textColor: .white)
            } else {
                setButtonStyle(button: button, title: title, backgroundColor: UIColor(hexString: "#F5F5F5"), textColor: UIColor(hexString: "#6B6B6B"))
            }
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
