//
//  NewsFeedPresenter.swift
//  VKNews
//
//  Created by Misha Volkov on 20.03.23.
//

import UIKit

protocol NewsFeedPresentationLogic {
    func presentData(response: NewsFeed.Model.Response.ResponseType)
}

class NewsFeedPresenter: NewsFeedPresentationLogic {
    weak var viewController: NewsFeedDisplayLogic?

    func presentData(response: NewsFeed.Model.Response.ResponseType) {
        switch response {
        case .presentNewsFeed:
            viewController?.displayData(viewModel: .displayNewsFeed)
        }
    }
}
