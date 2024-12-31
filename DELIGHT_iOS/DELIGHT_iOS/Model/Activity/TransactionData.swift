//
//  TransactionData.swift
//  DELIGHT_iOS
//
//  Created by wjdyukyung on 12/31/24.
//

import Foundation

enum DurationType {
    case week
    case month
}

enum TransactionType: Int {
    case all = 0
    case expense
    case income
}

struct TransactionData: Codable, Hashable {
    var amount: String
    var name: String
    var timestamp: String
    var type: String

    // Hashable 프로토콜을 준수하기 위한 구현
    static func == (lhs: TransactionData, rhs: TransactionData) -> Bool {
        return lhs.amount == rhs.amount && lhs.name == rhs.name && lhs.timestamp == rhs.timestamp && lhs.type == rhs.type
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(amount)
        hasher.combine(name)
        hasher.combine(timestamp)
        hasher.combine(type)
    }
    
    func getTransactionData() -> String {
        return timestamp.formattedFullDateStr()
    }
    
    func getAmountString() -> String {
        if let number = Double(amount) {
            if number < 0 {
                return "-$\(String(abs(number)))"
            } else {
                return "$\(number)"
            }
        }
        return "$0"
    }
}
