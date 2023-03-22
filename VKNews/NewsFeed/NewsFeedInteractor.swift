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

    func makeRequest(request: NewsFeed.Model.Request.RequestType) {
        if service == nil {
            service = NewsFeedService()
        }

        switch request {
        case .getFeed:
            presenter?.presentData(response: .presentNewsFeed)
        }
    }
}
