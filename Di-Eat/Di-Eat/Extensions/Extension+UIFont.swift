//
//  Extension+UIFont.swift
//  DELIGHT_iOS
//
//  Created by wjdyukyung on 12/30/24.
//

import UIKit

extension UIFont {
    public enum FontWeight: String {
        case light = "Light"
        case regular = "Regular"
        case medium = "Medium"
        case bold = "Bold"
    }
    
    // poppins 폰트 설정
    static func poppins(ofSize size: CGFloat, weight: FontWeight) -> UIFont {
        return UIFont(name: "Poppins-\(weight.rawValue)", size: size) ?? .systemFont(ofSize: size)
    }
}
