//
//  RecipeDetailViewController.swift
//  Di-Eat
//
//  Created by wjdyukyung on 1/24/25.
//

import UIKit
import WebKit
import Combine

class RecipeDetailViewController: BaseViewController {
    // MARK: - Property
    private let rootView = RecipeDetailView()
    private let viewModel: RecipeDetailViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: RecipeDetailViewModel, isBest: Bool = false) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
        self.configure()
    }
    
    private func bindViewModel() {
        self.rootView.bindViewModel(self.viewModel)
        self.rootView.dismissButton
            .throttleTapPublisher()
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancellables)
    }
    
    private func loadUrl(id: Int) {
        if let url = URL(string: "https://www.10000recipe.com/recipe/\(id)") {
            let request = URLRequest(url: url)
            self.rootView.webView.load(request)
        }
//        self.rootView.webView.navigationDelegate = self
//        self.rootView.webView.uiDelegate = self
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
