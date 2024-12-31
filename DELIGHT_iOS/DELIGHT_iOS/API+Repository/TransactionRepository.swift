//
//  TransactionRepository.swift
//  DELIGHT_iOS
//
//  Created by wjdyukyung on 12/31/24.
//

import Foundation
import Combine

final class TransactionRepository {
    var cancellables = Set<AnyCancellable>()
    
    func loadTransaction() -> AnyPublisher<[TransactionData], Error> {
        guard let url = Bundle.main.url(forResource: "transacions", withExtension: "json") else {
            return Fail(error: URLError(.fileDoesNotExist)).eraseToAnyPublisher()
        }
        
        return Future<[TransactionData], Error> { promise in
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    let data = try Data(contentsOf: url)
                    
                    let decoder = JSONDecoder()
                    let transactions = try decoder.decode([TransactionData].self, from: data)
                    
                    DispatchQueue.main.async {
                        promise(.success(transactions))
                    }
                } catch {
                    DispatchQueue.main.async {
                        promise(.failure(error))
                    }
                }
            }
        }
        .flatMap { transactions -> AnyPublisher<[TransactionData], Error> in
            let filterTransactions = self.transactionsToLastMonth(transactions: transactions)
            return Just(filterTransactions)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
    
    // 데이터가 많아 한달치만 뽑아 사용
    private func transactionsToLastMonth(transactions: [TransactionData]) -> [TransactionData] {
        let today = Date()
        let oneMonthAgo = Calendar.current.date(byAdding: .month, value: -1, to: today)!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let filteredTransactions = transactions
            .compactMap { transaction -> (TransactionData, Date)? in
                guard let date = dateFormatter.date(from: transaction.timestamp) else {
                    print("Failed to parse date: \(transaction.timestamp)")
                    return nil
                }
                return (transaction, date)
            }
            .filter { _, date in
                return date >= oneMonthAgo && date <= today
            }
            .sorted { $0.1 < $1.1 }
        
        return filteredTransactions.map { $0.0 }
    }
}
