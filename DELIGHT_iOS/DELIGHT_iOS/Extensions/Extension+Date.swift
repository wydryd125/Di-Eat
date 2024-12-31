//
//  Extension+.swift
//  DELIGHT_iOS
//
//  Created by wjdyukyung on 12/31/24.
//

import Foundation

extension String {
    func convertDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.date(from: self)
    }
    
    func formattedFullDateStr() -> String {
        guard let date = convertDate() else { return "" }
        let targetDateFormatter = DateFormatter()
        targetDateFormatter.dateFormat = "yyyy.MM.dd HH:mm"
        targetDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        return targetDateFormatter.string(from: date)
    }
    
    func formattedDateStr() -> String {
        guard let date = convertDate() else { return "" }
        let targetDateFormatter = DateFormatter()
        targetDateFormatter.dateFormat = "yyyy.MM.dd"
        targetDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        return targetDateFormatter.string(from: date)
    }
}
