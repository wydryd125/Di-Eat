//
//  DelightChartView.swift
//  DELIGHT_iOS
//
//  Created by wjdyukyung on 12/30/24.
//

import UIKit
import DGCharts

class DelightChartView: UIView {
    let legendStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.alignment = .leading
        return stackView
    }()
    
    let incomeChartView = LineChartView()
    let expenceChartView = LineChartView()
    
    let startLabel: UILabel = {
        let label = UILabel()
        label.font = .poppins(ofSize: 16, weight: .regular)
        label.textColor = UIColor(hexString: "#BDBDBD")
        return label
    }()
    
    let endLabel: UILabel = {
        let label = UILabel()
        label.font = .poppins(ofSize: 16, weight: .regular)
        label.textColor = UIColor(hexString: "#BDBDBD")
        return label
    }()
    
    let dateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUI()
        self.setContributes()
        
        self.setIncomeChartView()
        self.setExpenceChartView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateChartView(data: [TransactionData]?) {
        self.resetCharts()
        let incomeData = data?
            .filter { Double($0.amount) ?? 0 > 0 }
            .compactMap { Double($0.amount) }
            .sampled(for: 10)
        
        let expenseData = data?
            .filter { Double($0.amount) ?? 0 < 0 }
            .compactMap { Double($0.amount) }
            .sampled(for: 10)
        
        self.updateIncomeChartView(data: Array(incomeData ?? []))
        self.updateExpenceChartView(data: Array(expenseData ?? []))
        
        self.startLabel.text = data?.first?.timestamp.formattedDateStr()
        self.endLabel.text = data?.last?.timestamp.formattedDateStr()
    }
    
    func resetCharts() {
        self.incomeChartView.data = nil
        self.expenceChartView.data = nil
        self.incomeChartView.notifyDataSetChanged()
        self.expenceChartView.notifyDataSetChanged()
    }
    
    private func updateIncomeChartView(data: [Double]) {
        var chartEntries: [ChartDataEntry] = []
        for (index, price) in data.enumerated() {
            chartEntries.append(ChartDataEntry(x: Double(index), y: price))
        }
        
        let dataSet = LineChartDataSet(entries: chartEntries)
        dataSet.mode = .cubicBezier
        dataSet.drawCirclesEnabled = false
        dataSet.lineWidth = 2.0
        dataSet.setColor(UIColor(hexString: "#363062"))
        dataSet.drawHorizontalHighlightIndicatorEnabled = false
        dataSet.drawValuesEnabled = false
        
        let lineChartData = LineChartData(dataSet: dataSet)
        self.incomeChartView.data = lineChartData
        self.incomeChartView.animate(xAxisDuration: 0.8, easingOption: .easeInBack)
    }
    
    private func updateExpenceChartView(data: [Double]) {
        var chartEntries: [ChartDataEntry] = []
        for (index, price) in data.enumerated() {
            chartEntries.append(ChartDataEntry(x: Double(index), y: price))
        }
        
        let dataSet = LineChartDataSet(entries: chartEntries)
        dataSet.mode = .cubicBezier
        dataSet.drawCirclesEnabled = false
        dataSet.lineWidth = 2.0
        dataSet.setColor(UIColor(hexString: "#5BDAA4"))
        dataSet.drawHorizontalHighlightIndicatorEnabled = false
        dataSet.drawValuesEnabled = false
        
        let lineChartData = LineChartData(dataSet: dataSet)
        self.expenceChartView.data = lineChartData
        self.expenceChartView.animate(xAxisDuration: 0.8, easingOption: .easeInBack)
    }
    
    private func setIncomeChartView() {
        self.incomeChartView.legend.enabled = false
        self.incomeChartView.xAxis.enabled = false
        self.incomeChartView.leftAxis.enabled = false
        self.incomeChartView.rightAxis.enabled = false
        self.incomeChartView.scaleXEnabled = false
        self.incomeChartView.scaleYEnabled = false
        self.incomeChartView.drawGridBackgroundEnabled = false
        self.incomeChartView.drawBordersEnabled = false
        self.incomeChartView.extraRightOffset = 12
        self.incomeChartView.clipsToBounds = false
        self.incomeChartView.clipDataToContentEnabled = false
        self.incomeChartView.clipValuesToContentEnabled = false
        self.incomeChartView.noDataText = ""
    }
    
    private func setExpenceChartView() {
        self.expenceChartView.legend.enabled = false
        self.expenceChartView.xAxis.enabled = false
        self.expenceChartView.leftAxis.enabled = false
        self.expenceChartView.rightAxis.enabled = false
        self.expenceChartView.scaleXEnabled = false
        self.expenceChartView.scaleYEnabled = false
        self.expenceChartView.drawGridBackgroundEnabled = false
        self.expenceChartView.drawBordersEnabled = false
        self.expenceChartView.extraRightOffset = 12
        self.expenceChartView.clipsToBounds = false
        self.expenceChartView.clipDataToContentEnabled = false
        self.expenceChartView.clipValuesToContentEnabled = false
        self.expenceChartView.noDataText = ""
    }
    
    private func getLegendView(title: String, color: UIColor) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 9
        stackView.alignment = .center
        
        let view = UIView()
        view.backgroundColor = color
        stackView.addArrangedSubview(view)
        view.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.width.equalTo(32)
            make.height.equalTo(8)
        }
        
        let label = UILabel()
        label.text = title
        label.font = .poppins(ofSize: 12, weight: .light)
        label.textColor = .black
        stackView.addArrangedSubview(label)
        
        return stackView
    }
    
    private func setUI() {
        let incomeView = self.getLegendView(title: "Income", color: UIColor(hexString: "#363062"))
        let expenceView = self.getLegendView(title: "Expence", color: UIColor(hexString: "#5BDAA4"))
        
        [incomeView, expenceView].forEach {
            self.legendStackView.addArrangedSubview($0)
        }
        
        [self.startLabel, self.endLabel].forEach {
            self.dateStackView.addArrangedSubview($0)
        }
        
        [self.legendStackView, self.incomeChartView, self.expenceChartView, self.dateStackView].forEach {
            self.addSubview($0)
        }
    }
    
    private func setContributes() {
        self.legendStackView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.height.equalTo(22)
        }
        
        self.incomeChartView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.dateStackView.snp.top)
            make.height.equalTo(161)
        }
        
        self.expenceChartView.snp.makeConstraints { make in
            make.edges.equalTo(self.incomeChartView)
        }
        
        self.dateStackView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(24)
        }
    }
}
