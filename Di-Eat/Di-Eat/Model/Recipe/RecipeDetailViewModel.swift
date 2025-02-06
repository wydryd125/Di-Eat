//
//  RecipeDetailViewModel.swift
//  Di-Eat
//
//  Created by wjdyukyung on 1/24/25.
//

import Foundation
import Combine

class RecipeDetailViewModel: ObservableObject {
    let recipe: Recipe
    // 필요한 데이터를 더 추가할 수 있음
    init(recipe: Recipe) {
        self.recipe = recipe
    }
}
