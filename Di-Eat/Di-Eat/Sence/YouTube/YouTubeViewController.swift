//
//  YouTubeViewController.swift
//  Di-Eat
//
//  Created by wjdyukyung on 1/17/25.
//

import UIKit
import Combine

class YouTubeViewController: BaseViewController {
    // MARK: - Property
    private let rootView = YouTubeView()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configure()
    }
    
    private func configure() {
        self.view.addSubview(self.rootView)
        
        self.rootView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}
