//
//  TransactionCell.swift
//  DELIGHT_iOS
//
//  Created by wjdyukyung on 12/30/24.
//

import UIKit

class TransactionCell: UITableViewCell {
    // MARK: - Property
    static let identifier = "TransactionCell"
    
    private let transactionCellImageView: UIImageView = {
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
    
    func drawCell(data: TransactionData) {
        self.nameLabel.text = data.name
        self.typeLabel.text = data.type
        self.amountLabel.text = data.getAmountString()
        self.dateLabel.text = data.getTransactionData()
    }
    
    private func setUI() {
        self.selectionStyle = .none
        self.backgroundColor = .white
        
        [self.transactionCellImageView, self.nameLabel, self.typeLabel, self.amountLabel, self.dateLabel].forEach {
            self.contentView.addSubview($0)
        }
    }
    
    private func setConstraints() {
        self.transactionCellImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(28)
            make.bottom.equalToSuperview().inset(10)
            make.size.equalTo(51)
        }
        
        self.nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.transactionCellImageView.snp.trailing).offset(20)
            make.bottom.equalTo(self.transactionCellImageView.snp.centerY)
            make.width.lessThanOrEqualTo(self.contentView.snp.width).multipliedBy(0.75).offset(-127)
        }
        
        self.amountLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(28)
            make.bottom.equalTo(self.nameLabel)
        }
        
        self.typeLabel.snp.makeConstraints { make in
            make.top.equalTo(self.transactionCellImageView.snp.centerY)
            make.leading.equalTo(self.nameLabel)
        }
        
        self.dateLabel.snp.makeConstraints { make in
            make.top.equalTo(self.typeLabel)
            make.trailing.equalTo(self.amountLabel)
        }
    }
}
