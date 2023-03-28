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
        case .getNewsFeed:
            service?.getFeed { [weak self] (feedResponse, revealPostIds) in
                self?.presenter?.presentData(response: .presentNewsFeed(feedResponse,
                                                                        revealedPostIds: revealPostIds))
            }
        case .getUser:
            service?.getUser { [weak self] userResponse in
                self?.presenter?.presentData(response: .presentUserInfo(userResponse))
            }
        case .revealPostIds(let postId):
            service?.revealPostIds(forPostId: postId) { [weak self] (feedResponse, revealPostIds) in
                self?.presenter?.presentData(response: .presentNewsFeed(feedResponse,
                                                                       revealedPostIds: revealPostIds))
            }
        case .getNextBatch:
            service?.getNextBatch(completion: { [weak self] (feedResponse, revealPostIds)in
                self?.presenter?.presentData(response: .presentNewsFeed(feedResponse, revealedPostIds: revealPostIds))
            })
        }
    }
}
