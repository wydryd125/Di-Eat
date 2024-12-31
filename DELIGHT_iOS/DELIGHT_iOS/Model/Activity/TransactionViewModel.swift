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
            })
            .store(in: &cancellables)
    }
    
    private func updateLatestTransactions() {
        guard let transactions = self.transactions else { return }
        self.latestTransactions = self.getLatestTransactions(type: self.type, transactions: transactions)
    }
    
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
