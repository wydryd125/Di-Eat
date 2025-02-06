//
//  Extension+UIColor.swift
//  Di-Eat
//
//  Created by wjdyukyung on 12/30/24.
//

import UIKit

extension UIColor {
    convenience init(hexString hex: String, alpha: Double = 1.0) {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        let red, green, blue: CGFloat
        
        if cString.count == 6 {
            red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
            green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
            blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        } else {
            // Default to black
            red = 0.0
            green = 0.0
            blue = 0.0
        }
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    static var diEatNavy: UIColor { UIColor(hexString: "#363062") }
    static var diEatSkyBlue: UIColor { UIColor(hexString: "#85CAE4") }
    static var diEatBondiBlue: UIColor { UIColor(hexString: "#009EBA") }
    
    static var diEatOrange: UIColor { UIColor(hexString: "#FF8527") }
    static var diEatYellow: UIColor { UIColor(hexString: "#FFB945") }
    
    static var diEatGray800: UIColor { UIColor(hexString: "#636773") }
    static var diEatGray600: UIColor { UIColor(hexString: "#B3B4BA") }
    static var diEatGray400: UIColor { UIColor(hexString: "#E1E2E3") }
    static var diEatGray100: UIColor { UIColor(hexString: "#F2F3F4") }
}

