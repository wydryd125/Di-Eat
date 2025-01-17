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
                    var data = try Data(contentsOf: url)
                    
                    // 제어 문자를 제거
                    if let jsonString = String(data: data, encoding: .utf8) {
                        let cleanedJsonString = jsonString.replacingOccurrences(of: "\\u0007", with: "")
                        data = cleanedJsonString.data(using: .utf8) ?? data
                    }
                    
                    // JSON 디코딩
                    let decoder = JSONDecoder()
                    do {
                        let recipe = try decoder.decode([Recipe].self, from: data)
                        DispatchQueue.main.async {
                            promise(.success(recipe))
                        }
                    } catch {
                        DispatchQueue.main.async {
                            print("Decoding error: \(error)")  // 디코딩 오류 출력
                            promise(.failure(error))
                        }
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
    
    func loadRecipeVideo() -> AnyPublisher<[YouTubeVideo], Error> {
        guard let url = Bundle.main.url(forResource: "YouTubeVideo", withExtension: "json") else {
            return Fail(error: URLError(.fileDoesNotExist)).eraseToAnyPublisher()
        }
        
        return Future<[YouTubeVideo], Error> { promise in
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    var data = try Data(contentsOf: url)
                    
                    let decoder = JSONDecoder()
                    do {
                        let video = try decoder.decode([YouTubeVideo].self, from: data)
                        DispatchQueue.main.async {
                            promise(.success(video))
                        }
                    } catch {
                        DispatchQueue.main.async {
                            print("Decoding error: \(error)")
                            promise(.failure(error))
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        promise(.failure(error))
                    }
                }
            }
        }
        .flatMap { video -> AnyPublisher<[YouTubeVideo], Error> in
            return Just(video)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
}
