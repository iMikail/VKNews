//
//  FeedResponse.swift
//  VKNews
//
//  Created by Misha Volkov on 20.03.23.
//

import Foundation

struct FeedResponseWrapped: Decodable {
    let response: FeedResponse
}
struct FeedResponse: Decodable {
    var items: [FeedItem]
}

struct FeedItem: Decodable {
    let sourceId, postId: Int
    let text: String?
    let date: Double
    let comments: CountableItem?
    let likes: CountableItem?
    let reposts: CountableItem?
    let views: CountableItem?
}

struct CountableItem: Decodable {
    let count: Int
}
