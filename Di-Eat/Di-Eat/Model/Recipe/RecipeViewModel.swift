//
//  RecipeViewModel.swift
//  Di-Eat
//
//  Created by wjdyukyung on 12/31/24.
//

import Foundation
import Combine

class RecipeViewModel: ObservableObject {
    private let repository = DietRecipeRepository()
    var level: LevelType = .all
    @Published var recipes: [Recipe]?
    
    @Published var isLoading: Bool = false
    private var cancellables = Set<AnyCancellable>()
    
    init() {}
    
    func bind() {
        self.isLoading = true
        
        self.repository.loadRecipe()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.isLoading = false
                case .failure(let error):
                    print("Failed to load Recipes: \(error.localizedDescription)")
                    self.isLoading = false
                }
            }, receiveValue: { recipes in
                self.recipes = recipes
            })
            .store(in: &cancellables)
    }
    
    // 추천 레시피
    func getRecommendRecipe() -> [Recipe]? {
        return self.recipes?
            .sorted { $0.scrapCount > $1.scrapCount}
            .prefix(5)
            .map { $0 }
    }
    
    // 난이도별 최근 레시피
    func getLevelTypeRecipe() -> [Recipe]? {
        if self.level == .all {
            return self.recipes?
                .sorted { $0.postDate > $1.postDate }
                .prefix(20)
                .map { $0 }
        }
        
        let filterLevel: String
        switch self.level {
        case .all:
            return nil // 위에서 처리했으므로 여기선 필요 없음
        case .level1:
            filterLevel = "아무나"
        case .level2:
            filterLevel = "초급"
        case .level3:
            filterLevel = "중급"
        }
        
        return self.recipes?
            .filter { $0.level == filterLevel }
            .sorted { $0.postDate > $1.postDate }
            .prefix(10)
            .map { $0 }
    }
}
