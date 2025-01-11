//
//  DelightToastView.swift
//  DELIGHT_iOS
//
//  Created by wjdyukyung on 1/1/25.
//

import UIKit

class DelightToastView: UIView {
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .poppins(ofSize: 16, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.font = .poppins(ofSize: 14, weight: .light)
        label.textColor = .white
        return label
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.font = .poppins(ofSize: 16, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .poppins(ofSize: 14, weight: .light)
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        self.setUI()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showToast(message: TransactionData) {
        self.nameLabel.text = message.name
        self.typeLabel.text = message.type
        self.amountLabel.text = message.getAmountString()
        self.dateLabel.text = message.getTransactionData()
        
        UIView.animate(withDuration: 0.4, delay: 2, options: .curveEaseOut, animations: {
            self.alpha = 0.0
        }, completion: {(isCompleted) in
            self.removeFromSuperview()
        })
    }
    
    private func setUI() {
        self.backgroundColor = UIColor(hexString: "#363062").withAlphaComponent(0.88)
        self.layer.cornerRadius = 8
        
        [self.nameLabel, self.typeLabel, self.amountLabel, self.dateLabel].forEach {
            self.addSubview($0)
        }
    }
    
    private func setConstraints() {
        self.nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(28)
            make.bottom.equalTo(self.snp.centerY)
        }
        
        self.amountLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(28)
            make.bottom.equalTo(self.nameLabel)
        }
        
        self.typeLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.centerY)
            make.leading.equalTo(self.nameLabel)
        }
        
        self.dateLabel.snp.makeConstraints { make in
            make.trailing.equalTo(self.amountLabel)
            make.top.equalTo(self.typeLabel)
        }
    }
}
