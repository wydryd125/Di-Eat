//
//  YouTubeRepository.swift
//  Di-Eat
//
//  Created by wjdyukyung on 2/7/25.
//

import Foundation
import Combine

final class YouTubeRepository {
    var cancellables = Set<AnyCancellable>()
    
    func loadYouTubeVideos() -> AnyPublisher<[YouTube], Error> {
        guard let url = Bundle.main.url(forResource: "youtube", withExtension: "json") else {
            return Fail(error: URLError(.fileDoesNotExist)).eraseToAnyPublisher()
        }
        
        return Future<[YouTube], Error> { promise in
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    let data = try Data(contentsOf: url)
                    
                    let decoder = JSONDecoder()
                    do {
                        let video = try decoder.decode([YouTube].self, from: data)
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
        .flatMap { video -> AnyPublisher<[YouTube], Error> in
            return Just(video)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
}
