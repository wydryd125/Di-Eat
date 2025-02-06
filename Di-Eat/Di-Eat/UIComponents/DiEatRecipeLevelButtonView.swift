//
//  DiEatRecipeLevelButtonView.swift
//  Di-Eat
//
//  Created by wjdyukyung on 2/6/25.
//

import UIKit
import Combine

class DiEatRecipeLevelButtonView: UIView {
    // 선택된 레벨을 외부에 전달하기 위한 퍼블리셔
    private let selectedLevelSubject = PassthroughSubject<LevelType, Never>()
    var selectedLevelPublisher: AnyPublisher<LevelType, Never> {
        return selectedLevelSubject.eraseToAnyPublisher()
    }
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.spacing = 24
        return stackView
    }()
    
    private let buttons: [UIButton] = {
        return [
            ("All", LevelType.all),
            ("Easy", LevelType.level1),
            ("Normal", LevelType.level2),
            ("Hard", LevelType.level3)
        ].map { title, level in
            let button = UIButton.createCustomButton(title: title,
                                                     font: .poppins(ofSize: 12, weight: .medium),
                                                     titleColor: .diEatGray600)
            button.tag = level.rawValue
            return button
        }
    }()
    
    private var cancellables = Set<AnyCancellable>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUI()
        self.setConstraints()
        self.setActions()
        self.updateButtonStyles(level: .all)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.buttons.forEach { self.stackView.addArrangedSubview($0) }
        self.addSubview(self.stackView)
    }
    
    private func setConstraints() {
        self.stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setActions() {
        self.buttons.forEach {
            $0.throttleTapPublisher()
                .map { $0.tag }
                .sink { [weak self] tag in
                    guard let self = self,
                          let level = LevelType(rawValue: tag) else { return }
                    self.selectedLevelSubject.send(level)
                    self.updateButtonStyles(level: level)
                }
                .store(in: &cancellables)
        }
    }
    
    func updateButtonStyles(level: LevelType) {
        self.buttons.forEach { button in
            let title: String
            switch button.tag {
            case LevelType.all.rawValue:
                title = "All"
            case LevelType.level1.rawValue:
                title = "Easy"
            case LevelType.level2.rawValue:
                title = "Normal"
            case LevelType.level3.rawValue:
                title = "Hard"
            default:
                title = ""
            }
            
            let fontColor = (level.rawValue == button.tag) ? UIColor.diEatNavy :  UIColor.diEatGray600
            
            var attString = AttributedString(title)
            attString.font = .poppins(ofSize: 12, weight: .medium)
            attString.foregroundColor = fontColor
            
            button.configuration?.attributedTitle = attString
        }
    }
}
