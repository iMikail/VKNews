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

    private let fetcher: DataFetcher = NetworkDataFetcher(networking: NetworkService())

    func makeRequest(request: NewsFeed.Model.Request.RequestType) {
        if service == nil {
            service = NewsFeedService()
        }

        switch request {
        case .getNewsFeed:
            fetcher.getFeed { [weak self] feedResponse in
                guard let feedResponse = feedResponse else { return }

                self?.presenter?.presentData(response: .presentNewsFeed(feedResponse))
            }
        }
    }
}
