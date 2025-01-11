//
//  BaseViewController.swift
//  Di-Eat
//
//  Created by wjdyukyung on 12/30/24.
//

import UIKit

class BaseViewController: UIViewController {
    // MARK: - Property
    private let toastView = DelightToastView()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
    }
    
//    func showToast(message: TransactionData) {
//        let toastWidth = self.view.frame.size.width - 58
//        let toastHeight: CGFloat = 88
//        let toastY = self.view.frame.size.height - toastHeight - 40
//        let toastX: CGFloat = 29
//        
//        self.toastView.frame = CGRect(x: toastX, y: toastY, width: toastWidth, height: toastHeight)
//        self.toastView.showToast(message: message)
//        self.view.addSubview(self.toastView)
//        
//    }
}
