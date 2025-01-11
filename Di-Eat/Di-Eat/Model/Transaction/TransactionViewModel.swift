//
//  TransactionViewModel.swift
//  DELIGHT_iOS
//
//  Created by wjdyukyung on 12/31/24.
//

import Foundation
import Combine

class TransactionViewModel: ObservableObject {
    private let repository = TransactionRepository()
    @Published var transactions: [TransactionData]?
    @Published var chartData: [TransactionData]?
    @Published var latestTransactions: [TransactionData]?
    @Published var recentData: TransactionData? = nil
    
    @Published var duration: DurationType = .week {
        didSet {
            updateChartTransactions(duration: duration)
        }
    }
    
    @Published var type: TransactionType = .all {
        didSet {
            updateLatestTransactions()
        }
    }
    
    @Published var isLoading: Bool = false
    private var cancellables = Set<AnyCancellable>()
    
    init() {}
    
    func bind() {
        self.isLoading = true
        
        self.repository.loadTransaction()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.isLoading = false
                case .failure(let error):
                    print("Failed to load transactions: \(error.localizedDescription)")
                    self.isLoading = false
                }
            }, receiveValue: { transactions in
                self.transactions = transactions
                self.updateLatestTransactions()
                self.updateChartTransactions(duration: .week)
                self.updateRecentData()
            })
            .store(in: &cancellables)
    }
    
    private func updateLatestTransactions() {
        guard let transactions = self.transactions else { return }
        self.latestTransactions = self.getLatestTransactions(type: self.type, transactions: transactions)
    }
    
    // 최근 transaction 데이터가 있는지 확인(for toast message)
    private func updateRecentData() {
        let curDate = Date().addingTimeInterval(-120)
        guard let transactionDate = self.transactions?.last,
              let tranDate = transactionDate.timestamp.convertDate() else { return }
        
        if tranDate >= curDate && tranDate <= Date() {
            self.recentData = transactionDate
        }
    }
    
    // 타입에 따른 최근 데이터
    private func getLatestTransactions(type: TransactionType, transactions: [TransactionData]) -> [TransactionData]? {
        let latestData = Array(transactions.reversed().prefix(20))
        switch type {
        case .all:
            return latestData
        case .expense:
            return Array(latestData.filter { Double($0.amount) ?? 0 < 0 }.prefix(10))
        case .income:
            return Array(latestData.filter { Double($0.amount) ?? 0 > 0 }.prefix(10))
        }
    }
    
    // 차트 데이트 week or month
    func updateChartTransactions(duration: DurationType) {
        guard let transactions = self.transactions else { return }
        switch duration {
        case .week:
            let oneWeekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
            self.chartData = transactions.filter {
                guard let transactionDate = $0.timestamp.convertDate() else { return false }
                return transactionDate >= oneWeekAgo
            }
        case .month:
            self.chartData = transactions
        }
    }
}
