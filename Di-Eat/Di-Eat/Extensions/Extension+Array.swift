//
//  Extension+Array.swift
//  Di-Eat
//
//  Created by wjdyukyung on 12/31/24.
//

import Foundation

extension Array {
    func sampled(for count: Int) -> [Element] {
        guard count > 0, self.count > 0 else { return self }
        let interval = Swift.max(1, self.count / count)
        return stride(from: 0, to: self.count, by: interval).map { self[$0] }
    }
}
