//
//  Youtube.swift
//  Di-Eat
//
//  Created by wjdyukyung on 1/17/25.
//

import Foundation

struct YouTubeVideo: Codable {
    var title: String
    var creator: String
    var channelUrl: String
    var url: String
    var ingredients: [String]
    var description: String
}
