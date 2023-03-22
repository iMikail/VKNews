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

    let dateFormatter: DateFormatter = {
        let dateFromatter = DateFormatter()
        dateFromatter.locale = Locale(identifier: "ru_RU")
        dateFromatter.dateFormat = "d MMM 'в' HH:mm"

        return dateFromatter
    }()

    func presentData(response: NewsFeed.Model.Response.ResponseType) {
        switch response {
        case .presentNewsFeed(let feed):
            let cells = feed.items.map { createCellViewModel(from: $0, profiles: feed.profiles, groups: feed.groups) }
            let feedViewModel = FeedViewModel(cells: cells)
            viewController?.displayData(viewModel: .displayNewsFeed(feedViewModel))
        }
    }

    private func createCellViewModel(from feedItem: FeedItem,
                                     profiles: [Profile],
                                     groups: [Group]) -> FeedViewModel.Cell {
        let profile = createProfile(forSourceId: feedItem.sourceId, profiles: profiles, groups: groups)
        let date = Date(timeIntervalSince1970: feedItem.date)
        let dateTitle = dateFormatter.string(from: date)

        return FeedViewModel.Cell(iconUrlImage: profile.photo,
                                  name: profile.name,
                                  date: dateTitle,
                                  text: feedItem.text,
                                  likes: String(feedItem.likes?.count ?? 0),
                                  comments: String(feedItem.comments?.count ?? 0),
                                  shares: String(feedItem.reposts?.count ?? 0),
                                  views: String(feedItem.views?.count ?? 0))
    }

    private func createProfile(forSourceId sourceId: Int,
                               profiles: [Profile],
                               groups: [Group]) -> ProfileRepresentable {
        let profilesOrGroups: [ProfileRepresentable] = sourceId >= 0 ? profiles : groups
        let normalSourceId = sourceId >= 0 ? sourceId : -sourceId
        let profile = profilesOrGroups.first { $0.id == normalSourceId } ?? Group(id: normalSourceId,
                                                                                  name: "?",
                                                                                  photo100: "?")

        return profile
    }
}
