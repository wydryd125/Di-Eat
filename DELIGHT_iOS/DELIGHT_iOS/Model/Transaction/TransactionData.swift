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
