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
    func getRecommendRecipe() {
        let topRecipes = self.recipes?
            .sorted { $0.recommendCount > $1.recommendCount}
            .prefix(5)
            .map { $0 }
    }
    
    // 최근 레시피
    func getRecentRecipe() -> [Recipe]? {
        return self.recipes?
            .sorted { $0.postDate > $1.postDate }
            .prefix(10)
            .map { $0 }
    }
}
