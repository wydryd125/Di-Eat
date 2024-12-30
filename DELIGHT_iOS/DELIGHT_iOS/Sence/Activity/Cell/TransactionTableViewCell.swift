//
//  TransactionTableViewCell.swift
//  DELIGHT_iOS
//
//  Created by wjdyukyung on 12/30/24.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
    // MARK: - Property
    static let identifier = "TransactionTableViewCell"
    
    private let activityImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(hexString: "#E2E2E2")
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .poppins(ofSize: 16, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.font = .poppins(ofSize: 14, weight: .light)
        label.textColor = UIColor(hexString: "#6B6B6B")
        return label
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.font = .poppins(ofSize: 16, weight: .bold)
        label.textColor = UIColor(hexString: "#363062")
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .poppins(ofSize: 14, weight: .light)
        label.textColor = UIColor(hexString: "#6B6B6B")
        return label
    }()
    
    // MARK: - Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setUI()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func drawCell(data: String) {
        self.nameLabel.text = data
        self.typeLabel.text = "type"
        self.amountLabel.text = "$0"
        self.dateLabel.text = "12월 1일"
    }
    
    private func setUI() {
        self.selectionStyle = .none
        self.contentView.backgroundColor = .white
        
        [self.activityImageView, self.nameLabel, self.typeLabel, self.amountLabel, self.dateLabel].forEach {
            self.contentView.addSubview($0)
        }
    }
    
    private func setConstraints() {
        self.activityImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(28)
            make.bottom.equalToSuperview().inset(10)
            make.size.equalTo(51)
        }
        
        self.nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.activityImageView.snp.trailing).offset(20)
            make.bottom.equalTo(self.activityImageView.snp.centerY)
        }
        
        self.amountLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(28)
            make.bottom.equalTo(self.nameLabel)
        }
        
        self.typeLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.nameLabel)
            make.top.equalTo(self.activityImageView.snp.centerY)
        }
        
        self.dateLabel.snp.makeConstraints { make in
            make.trailing.equalTo(self.amountLabel)
            make.top.equalTo(self.typeLabel)
        }
    }
}
