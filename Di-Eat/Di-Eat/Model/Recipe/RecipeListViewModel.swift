//
//  RecipeListViewModel.swift
//  Di-Eat
//
//  Created by wjdyukyung on 1/31/25.
//

import Foundation
import Combine

class RecipeListViewModel: ObservableObject {
    var type: RecipeType
    var level: LevelType = .all
    private let recipes: [Recipe]
    private var cancellables = Set<AnyCancellable>()
    
    init(type: RecipeType, list: [Recipe]) {
        self.type = type
        self.recipes = list
    }
    
    // 추천 레시피 20개, all은 50개
    func getRecommendRecipes() -> [Recipe] {
        if self.level == .all {
            return self.recipes
                .sorted { $0.scrapCount > $1.scrapCount}
                .prefix(50)
                .map { $0 }
        }
        
        let filterLevel: String
        switch self.level {
        case .all:
            filterLevel = ""
        case .level1:
            filterLevel = "아무나"
        case .level2:
            filterLevel = "초급"
        case .level3:
            filterLevel = "중급"
        }
        
        return self.recipes
            .filter { $0.level == filterLevel }
            .sorted { $0.scrapCount > $1.scrapCount}
            .prefix(20)
            .map { $0 }
    }
    
    // 최근 레시피
    func getRecipes() -> [Recipe] {
        if self.level == .all {
            return self.recipes
                .sorted { $0.postDate > $1.postDate }
                .map { $0 }
        }
        
        let filterLevel: String
        switch self.level {
        case .all:
            filterLevel = ""
        case .level1:
            filterLevel = "아무나"
        case .level2:
            filterLevel = "초급"
        case .level3:
            filterLevel = "중급"
        }
        
        return self.recipes
            .filter { $0.level == filterLevel}
            .sorted { $0.postDate > $1.postDate }
            .map { $0 }
    }
}
