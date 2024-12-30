//
//  Extension+UIButton.swift
//  DELIGHT_iOS
//
//  Created by wjdyukyung on 12/30/24.
//

import UIKit

extension UIButton {
    static func createCustomButton(title: String,
                                   font: UIFont,
                                   titleColor: UIColor = .black,
                                   backgroundColor: UIColor = .white,
                                   cornerRadius: CGFloat = 0,
                                   contentInsets: NSDirectionalEdgeInsets = .zero) -> UIButton {
        
        var attString = AttributedString(title)
        attString.font = font
        attString.foregroundColor = titleColor
        
        var config = UIButton.Configuration.filled()
        config.attributedTitle = attString
        config.baseBackgroundColor = backgroundColor
        config.baseForegroundColor = .black
        config.contentInsets = contentInsets
        
        let button = UIButton(configuration: config)
        button.layer.cornerRadius = cornerRadius
        button.clipsToBounds = true
        button.sizeToFit()
        return button
    }
}
