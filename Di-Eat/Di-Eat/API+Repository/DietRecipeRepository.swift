//
//  DietRecipeRepository.swift
//  Di-Eat
//
//  Created by wjdyukyung on 12/31/24.
//

import Foundation
import Combine

final class DietRecipeRepository {
    var cancellables = Set<AnyCancellable>()
    
    func loadRecipe() -> AnyPublisher<[Recipe], Error> {
        guard let url = Bundle.main.url(forResource: "dietRecipe", withExtension: "json") else {
            return Fail(error: URLError(.fileDoesNotExist)).eraseToAnyPublisher()
        }
        
        return Future<[Recipe], Error> { promise in
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    let data = try Data(contentsOf: url)
                    
                    let decoder = JSONDecoder()
                    let recipe = try decoder.decode([Recipe].self, from: data)
                    
                    DispatchQueue.main.async {
                        promise(.success(recipe))
                    }
                } catch {
                    DispatchQueue.main.async {
                        promise(.failure(error))
                    }
                }
            }
        }
        .flatMap { recipe -> AnyPublisher<[Recipe], Error> in
            return Just(recipe)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
}
