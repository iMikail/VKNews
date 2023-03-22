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
                case getFeed
            }
        }

        struct Response {
            enum ResponseType {
                case presentNewsFeed
            }
        }

        struct ViewModel {
            enum ViewModelData {
                case displayNewsFeed
            }
        }
    }
}
// swiftlint:enable nesting
