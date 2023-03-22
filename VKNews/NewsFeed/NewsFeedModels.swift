//
//  NewsFeedModels.swift
//  VKNews
//
//  Created by Misha Volkov on 20.03.23.
//

import UIKit

// swiftlint:disable nesting
enum NewsFeed {

    enum Model {
        struct Request {
            enum RequestType {
                case getNewsFeed
            }
        }

        struct Response {
            enum ResponseType {
                case presentNewsFeed(_ feed: FeedResponse)
            }
        }

        struct ViewModel {
            enum ViewModelData {
                case displayNewsFeed(_ feedViewModel: FeedViewModel)
            }
        }
    }
}
// swiftlint:enable nesting
struct FeedViewModel {
    struct Cell: FeedCellViewModel {
        var iconUrlImage: String
        var name: String
        var date: String
        var text: String?
        var likes: String?
        var comments: String?
        var shares: String?
        var views: String?
    }

    let cells: [Cell]
}
