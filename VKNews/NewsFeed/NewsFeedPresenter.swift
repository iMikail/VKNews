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
        case .presentNewsFeed(let feed):
            let cells = feed.items.map { createCellViewModel(from: $0) }
            let feedViewModel = FeedViewModel(cells: cells)
            viewController?.displayData(viewModel: .displayNewsFeed(feedViewModel))
        }
    }

    private func createCellViewModel(from feedItem: FeedItem) -> FeedViewModel.Cell {
        return FeedViewModel.Cell(iconUrlImage: "",
                                  name: "future name",
                                  date: "future date",
                                  text: feedItem.text,
                                  likes: String(feedItem.likes?.count ?? 0),
                                  comments: String(feedItem.comments?.count ?? 0),
                                  shares: String(feedItem.reposts?.count ?? 0),
                                  views: String(feedItem.views?.count ?? 0))
    }
}
