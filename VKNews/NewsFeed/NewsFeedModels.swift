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
                case getUser
                case revealPostIds(_ postId: Int)
                case getNextBatch
            }
        }

        struct Response {
            enum ResponseType {
                case presentNewsFeed(_ feed: FeedResponse, revealedPostIds: [Int])
                case presentUserInfo(_ user: UserResponse?)
            }
        }

        struct ViewModel {
            enum ViewModelData {
                case displayNewsFeed(_ feedViewModel: FeedViewModel)
                case displayUser(_ userViewModel: UserViewModel)
            }
        }
    }
}
// swiftlint:enable nesting
struct FeedViewModel {
    struct Cell: FeedCellViewModel {
        var postId: Int

        var iconUrlImage: String
        var name: String
        var date: String
        var text: String?
        var likes: String?
        var comments: String?
        var shares: String?
        var views: String?
        var photoAttachments: [FeedCellPhotoAttachmentViewModel]
        var sizes: FeedCellSizes
    }

    struct FeedCellPhotoAttachment: FeedCellPhotoAttachmentViewModel {
        var photoUrlString: String?
        var width: Int
        var height: Int
    }

    let cells: [Cell]
}

struct UserViewModel: TitleViewViewModel {
    var photoUrlString: String?
}
