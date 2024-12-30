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
    
    var priceData: [Double]! = [100, 345, 20, 120, 90, 300, 450, 220, 120]
    var currentPosition: Double = 0.0
    var pointer = DelightChartPointer()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUI()
        self.setContributes()
        
        self.setIncomeChartView(chartPrices: self.priceData)
        self.setExpenceChartView(chartPrices: self.priceData)
        self.setIncomeChartView()
        self.setExpenceChartView()
        
        self.setPointer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func gestureRecognizer(_ gestureRecognizer: NSUIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: NSUIGestureRecognizer) -> Bool {
//        return true
//    }

    func setIncomeChartView(chartPrices: [Double]) {
        var chartEntries: [ChartDataEntry] = []
        for (index, price) in chartPrices.enumerated() {
            chartEntries.append(ChartDataEntry(x: Double(index), y: price))
        }
        
        let dataSet = LineChartDataSet(entries: chartEntries)
        dataSet.mode = .cubicBezier // 곡선 타입
        dataSet.drawCirclesEnabled = false // 데이터 점 표시 여부
        dataSet.lineWidth = 2.0 // 라인 두께
        dataSet.setColor(UIColor(hexString: "#363062"))
        dataSet.fillColor = UIColor(hexString: "#363062").withAlphaComponent(0.3)
        dataSet.drawFilledEnabled = true // 아래 영역 채우기 활성화
        dataSet.drawHorizontalHighlightIndicatorEnabled = false // 수평 강조선 비활성화
        dataSet.drawValuesEnabled = false // 값 비활성화
        
        let gradientColors = [
            UIColor(hexString: "#36306221").withAlphaComponent(0.3).cgColor,
            UIColor.clear.cgColor
        ]
        let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                  colors: gradientColors as CFArray,
                                  locations: [1.0, 0.0])!
        
        dataSet.fill = LinearGradientFill(gradient: gradient, angle: 90) 
        dataSet.drawFilledEnabled = true
        

        let lineChartData = LineChartData(dataSet: dataSet)
        self.incomeChartView.data = lineChartData
        self.incomeChartView.animate(xAxisDuration: 0.8, easingOption: .easeInBack)
    }
    
    func setExpenceChartView(chartPrices: [Double]) {
        var chartEntries: [ChartDataEntry] = []
        for (index, price) in chartPrices.enumerated() {
            chartEntries.append(ChartDataEntry(x: Double(index), y: price))
        }
        
        let dataSet = LineChartDataSet(entries: chartEntries)
        dataSet.mode = .cubicBezier // 곡선 타입
        dataSet.drawCirclesEnabled = false // 데이터 점 표시 여부
        dataSet.lineWidth = 2.0 // 라인 두께
        dataSet.setColor(UIColor(hexString: "#5BDAA4"))
        dataSet.fillColor = UIColor(hexString: "#5BDAA4").withAlphaComponent(0.3)
        dataSet.drawFilledEnabled = true // 아래 영역 채우기 활성화
        dataSet.drawHorizontalHighlightIndicatorEnabled = false // 수평 강조선 비활성화
        dataSet.drawValuesEnabled = false // 값 비활성화
        
        let gradientColors = [
            UIColor(hexString: "#5BDAA4").withAlphaComponent(0.3).cgColor,
            UIColor.clear.cgColor
        ]
        let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                  colors: gradientColors as CFArray,
                                  locations: [1.0, 0.0])!
        
        dataSet.fill = LinearGradientFill(gradient: gradient, angle: 90)
        dataSet.drawFilledEnabled = true
        
        let lineChartData = LineChartData(dataSet: dataSet)
        self.expenceChartView.data = lineChartData
        self.expenceChartView.animate(xAxisDuration: 0.8, easingOption: .easeInBack)
    }
    
    
    func setIncomeChartView() {
        // 범례(legend)를 숨깁니다.
        self.incomeChartView.legend.enabled = false
        // X축을 비활성화하여 축 라벨과 선을 숨깁니다.
        self.incomeChartView.xAxis.enabled = false
        // 왼쪽 Y축을 비활성화하여 축 라벨과 선을 숨깁니다.
        self.incomeChartView.leftAxis.enabled = false
        // 오른쪽 Y축을 비활성화하여 축 라벨과 선을 숨깁니다.
        self.incomeChartView.rightAxis.enabled = false
        // X축 확대/축소를 비활성화합니다.
        self.incomeChartView.scaleXEnabled = false
        // Y축 확대/축소를 비활성화합니다.
        self.incomeChartView.scaleYEnabled = false
        // 차트 배경에 격자(Grid)를 비활성화합니다.
        self.incomeChartView.drawGridBackgroundEnabled = false
        // 차트 외곽의 경계선을 숨깁니다.
        self.incomeChartView.drawBordersEnabled = false
        // 차트 우측에 여백을 추가하여 데이터가 차트 끝에 붙지 않도록 설정합니다.
        self.incomeChartView.extraRightOffset = 12
        // 차트의 데이터가 차트 뷰의 경계를 넘어가더라도 클리핑하지 않습니다.
        self.incomeChartView.clipsToBounds = false
        // 차트의 데이터 점이 차트 뷰의 경계를 넘어가더라도 클리핑하지 않습니다.
        self.incomeChartView.clipDataToContentEnabled = false
        // 차트의 값(데이터 라벨)이 차트 뷰의 경계를 넘어가더라도 클리핑하지 않습니다.
        self.incomeChartView.clipValuesToContentEnabled = false
        // 차트에 데이터가 없을 경우 표시될 기본 텍스트를 설정합니다.
        self.incomeChartView.noDataText = ""
    }
    
    func setExpenceChartView() {
        // 범례(legend)를 숨깁니다.
        self.expenceChartView.legend.enabled = false
        // X축을 비활성화하여 축 라벨과 선을 숨깁니다.
        self.expenceChartView.xAxis.enabled = false
        // 왼쪽 Y축을 비활성화하여 축 라벨과 선을 숨깁니다.
        self.expenceChartView.leftAxis.enabled = false
        // 오른쪽 Y축을 비활성화하여 축 라벨과 선을 숨깁니다.
        self.expenceChartView.rightAxis.enabled = false
        // X축 확대/축소를 비활성화합니다.
        self.expenceChartView.scaleXEnabled = false
        // Y축 확대/축소를 비활성화합니다.
        self.expenceChartView.scaleYEnabled = false
        // 차트 배경에 격자(Grid)를 비활성화합니다.
        self.expenceChartView.drawGridBackgroundEnabled = false
        // 차트 외곽의 경계선을 숨깁니다.
        self.expenceChartView.drawBordersEnabled = false
        // 차트 우측에 여백을 추가하여 데이터가 차트 끝에 붙지 않도록 설정합니다.
        self.expenceChartView.extraRightOffset = 12
        // 차트의 데이터가 차트 뷰의 경계를 넘어가더라도 클리핑하지 않습니다.
        self.expenceChartView.clipsToBounds = false
        // 차트의 데이터 점이 차트 뷰의 경계를 넘어가더라도 클리핑하지 않습니다.
        self.expenceChartView.clipDataToContentEnabled = false
        // 차트의 값(데이터 라벨)이 차트 뷰의 경계를 넘어가더라도 클리핑하지 않습니다.
        self.expenceChartView.clipValuesToContentEnabled = false
        // 차트에 데이터가 없을 경우 표시될 기본 텍스트를 설정합니다.
        self.expenceChartView.noDataText = ""
    }

    func setPointer() {
        self.addSubview(pointer)
        self.pointer.setColor(color: .gray)
        self.pointer.alpha = 0
    }
    
    func getLegendView(title: String, color: UIColor) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 9
        stackView.alignment = .leading
        
        let view = UIView()
        view.backgroundColor = color
        view.frame = CGRect(x: 0, y: 0, width: 32, height: 4)
        
        let label = UILabel()
        label.text = title
        label.font = .poppins(ofSize: 12, weight: .light)
        label.textColor = .black
        
        stackView.addArrangedSubview(view)
        stackView.addArrangedSubview(label)
        
        return stackView
    }
    
    private func setUI() {
        let incomeView = self.getLegendView(title: "Income", color: UIColor(hexString: "#363062"))
        let expenceView = self.getLegendView(title: "Expence", color: UIColor(hexString: "#5BDAA4"))
        
        [incomeView, expenceView].forEach {
            self.legendStackView.addArrangedSubview($0)
        }
        
        [self.legendStackView, self.incomeChartView, self.expenceChartView].forEach {
            self.addSubview($0)
        }
    }
    
    private func setContributes() {
        self.legendStackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(22)
        }
        
        self.incomeChartView.snp.makeConstraints { make in
            make.top.equalTo(self.legendStackView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(168)
        }
        
        self.expenceChartView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(64)
        }
    }
}

class DelightChartPointer: UIView {
    let view = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        clipsToBounds = false
        self.view.layer.cornerRadius = 8
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setColor(color: UIColor) {
        self.view.backgroundColor = color
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.view.snp.makeConstraints { make in
            make.size.equalTo(16)
            make.centerX.centerY.equalToSuperview()
        }
    }
}
