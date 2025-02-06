//
//  RecipeDetailView.swift
//  Di-Eat
//
//  Created by wjdyukyung on 1/24/25.
//

import UIKit
import Combine
import WebKit

class RecipeDetailView: BaseView, WKNavigationDelegate {
    // MARK: - Property
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView = UIView()
    
    let dismissButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.diEatGray100.cgColor
        button.clipsToBounds = true
        button.isUserInteractionEnabled = true
        
        let imageView = UIImageView(image: UIImage(named: "iconDismiss"))
        imageView.tintColor = .black
        imageView.isUserInteractionEnabled = false
        
        button.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(16)
            make.centerX.equalToSuperview().offset(-1)
            make.centerY.equalToSuperview()
        }
        return button
    }()
    
    private let bestImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "iconBest")
        imageView.tintColor = .diEatOrange
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 16
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.diEatGray100.cgColor
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let recipeView = UIView()
    var webView: WKWebView!
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setUI()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 데이터 바인딩
    func bindViewModel(_ viewModel: RecipeDetailViewModel) {
        self.loadRecipePage(id: viewModel.recipe.recipeNumber)
    }
    
    func loadRecipePage(id: Int) {
        if let url = URL(string: "https://www.10000recipe.com/recipe/\(id)") {
            let request = URLRequest(url: url)
            self.webView.load(request)
        }
    }
    
    private func setUI() {
        let configuration = WKWebViewConfiguration()
        let webpagePreferences = WKWebpagePreferences()
        webpagePreferences.allowsContentJavaScript = true
        configuration.defaultWebpagePreferences = webpagePreferences
        
        self.webView = WKWebView(frame: .zero, configuration: configuration)
        self.webView.scrollView.showsVerticalScrollIndicator = false
        self.webView.scrollView.isScrollEnabled = false
        self.webView.navigationDelegate = self
        
        self.addSubview(self.scrollView)
        self.scrollView.addSubview(self.contentView)
        self.recipeView.addSubview(self.webView)
        [self.recipeView, self.dismissButton, self.bestImageView].forEach {
            self.contentView.addSubview($0)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let script = """
        document.addEventListener('DOMContentLoaded', function() {
            var stepsSection = document.querySelector('div[data-tag="웹-조리순서시작"]');
            if (stepsSection) {
                window.webkit.messageHandlers.callbackHandler.postMessage(stepsSection.innerHTML);
            } else {
                window.webkit.messageHandlers.callbackHandler.postMessage('조리순서 섹션을 찾을 수 없습니다.');
            }
        });
        """
        webView.evaluateJavaScript(script) { (result, error) in
            if let error = error {
                print("JavaScript 오류: \(error.localizedDescription)")
            } else {
                print("JavaScript 실행 결과: \(String(describing: result))")
            }
        }
        
        webView.evaluateJavaScript("document.documentElement.scrollHeight") { [weak self] result, error in
            if let height = result as? CGFloat, error == nil {
                guard let self = self else { return }
                self.updateWebViewHeight(height: height)
            }
        }
    }
    
    // 웹뷰 높이 업데이트 함수
    private func updateWebViewHeight(height: CGFloat) {
        self.recipeView.snp.updateConstraints { make in
            make.height.equalTo(height)
        }
        // 레이아웃을 강제로 갱신하여 화면에 반영
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    private func setConstraints() {
        self.scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.contentView.snp.makeConstraints { make in
            make.edges.equalTo(self.scrollView.contentLayoutGuide) // 스크롤뷰의 컨텐츠 레이아웃 가이드에 연결
            make.width.equalTo(self.scrollView.frameLayoutGuide) // 가로 크기는 스크롤뷰와 동일
        }
        
        self.dismissButton.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16)
            make.width.height.equalTo(32)
        }
        
        self.bestImageView.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(16)
            make.width.height.equalTo(32)
        }
        
        self.webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.recipeView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(0)
        }
    }
}
