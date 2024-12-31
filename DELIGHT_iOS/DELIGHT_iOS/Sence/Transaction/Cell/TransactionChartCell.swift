//
//  TransactionChartCell.swift
//  DELIGHT_iOS
//
//  Created by wjdyukyung on 12/31/24.
//

import UIKit

class TransactionChartCell: UITableViewCell {
    // MARK: - Property
    static let identifier = "TransactionChartCell"
    
    enum ChartType {
        case week
        case month
    }
    
    let switchButton: DelightSwitchButton = {
        let button = DelightSwitchButton()
        return button
    }()
    
    let chartView: DelightChartView = {
        let chartView = DelightChartView()
        return chartView
    }()

    let type: ChartType = .week
    
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
    
    func drawCell(data: [TransactionData]?) {
        guard let data = data else { return }
        let filteredData: [TransactionData]
        
        if switchButton.isFirstSelected {
            let calendar = Calendar.current
            let now = Date()
            
            filteredData = data.filter { transaction in
                guard let transactionDate = transaction.timestamp.convertDate() else { return false }
                return calendar.isDate(transactionDate, equalTo: now, toGranularity: .weekOfYear)
            }
            
            print(filteredData.count)
        } else {
            filteredData = data
        }
        
    }
    
    private func setUI() {
        self.contentView.backgroundColor = .white
        
        [self.switchButton, self.chartView].forEach {
            self.contentView.addSubview($0)
        }
    }
    
    private func setConstraints() {
        self.switchButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().inset(28)
            make.height.equalTo(38)
        }
        
        self.chartView.snp.makeConstraints { make in
            make.top.equalTo(self.switchButton.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(28)
            make.bottom.equalToSuperview()
            make.height.equalTo(254)
        }
    }
}
