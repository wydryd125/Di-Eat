//
//  YoutubeViewModel.swift
//  Di-Eat
//
//  Created by wjdyukyung on 1/17/25.
//

import Foundation
import Combine

class YoutubeViewModel: ObservableObject {
    private let repository = YouTubeRepository()
    @Published var youtubes: [YouTube]?
    
    @Published var isLoading: Bool = false
    private var cancellables = Set<AnyCancellable>()
    
    init() {}
    
    func bind() {
        self.isLoading = true
        
        self.repository.loadYouTubeVideos()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.isLoading = false
                case .failure(let error):
                    print("Failed to load Recipes: \(error.localizedDescription)")
                    self.isLoading = false
                }
            }, receiveValue: { videos in
                self.youtubes = videos.shuffled()
            })
            .store(in: &cancellables)
    }
}
