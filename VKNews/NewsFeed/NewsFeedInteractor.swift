//
//  NewsFeedInteractor.swift
//  VKNews
//
//  Created by Misha Volkov on 20.03.23.
//

import UIKit

protocol NewsFeedBusinessLogic {
    func makeRequest(request: NewsFeed.Model.Request.RequestType)
}

class NewsFeedInteractor: NewsFeedBusinessLogic {
    var presenter: NewsFeedPresentationLogic?
    var service: NewsFeedService?

    private var revealedPostIds = [Int]()
    private var feedResponse: FeedResponse?

    private let fetcher: DataFetcher = NetworkDataFetcher(networking: NetworkService())

    func makeRequest(request: NewsFeed.Model.Request.RequestType) {
        if service == nil {
            service = NewsFeedService()
        }

        switch request {
        case .getNewsFeed:
            fetcher.getFeed { [weak self] feedResponse in
                self?.feedResponse = feedResponse
                self?.presentFeed()
            }
        case .revealPostIds(let postId):
            revealedPostIds.append(postId)
            presentFeed()
        }
    }

    private func presentFeed() {
        guard let feedResponse = feedResponse else { return }

        presenter?.presentData(response: .presentNewsFeed(feedResponse, revealedPostIds: revealedPostIds))
    }
}
