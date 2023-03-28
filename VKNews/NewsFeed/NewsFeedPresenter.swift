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
    var cellLayoutCalculator: FeedCellLayoutCalculatorProtocol = NewsFeedCellLayoutCalculator()

    private let dateFormatter: DateFormatter = {
        let dateFromatter = DateFormatter()
        dateFromatter.locale = Locale(identifier: "ru_RU")
        dateFromatter.dateFormat = "d MMM 'в' HH:mm"

        return dateFromatter
    }()

    func presentData(response: NewsFeed.Model.Response.ResponseType) {
        switch response {
        case .presentNewsFeed(let feed, let revealedPostIds):
            let cells = feed.items.map { createCellViewModel(from: $0,
                                                             profiles: feed.profiles,
                                                             groups: feed.groups,
                                                             revealedPostIds: revealedPostIds) }
            let feedViewModel = FeedViewModel(cells: cells)
            viewController?.displayData(viewModel: .displayNewsFeed(feedViewModel))
        case .presentUserInfo(let user):
            let userViewModel = UserViewModel(photoUrlString: user?.photo100)
            viewController?.displayData(viewModel: .displayUser(userViewModel))
        }
    }

    private func createCellViewModel(from feedItem: FeedItem,
                                     profiles: [Profile],
                                     groups: [Group],
                                     revealedPostIds: [Int]) -> FeedViewModel.Cell {
        let profile = createProfile(forSourceId: feedItem.sourceId, profiles: profiles, groups: groups)
        let photoAttachments = createPhotoAttachments(feedItem: feedItem)
        let date = Date(timeIntervalSince1970: feedItem.date)
        let dateTitle = dateFormatter.string(from: date)

        let isFullSized = revealedPostIds.contains(feedItem.postId)

        let sizes = cellLayoutCalculator.sizes(postText: feedItem.text,
                                               photoAttachments: photoAttachments,
                                               isFullSizedPost: isFullSized)
        let postText = feedItem.text?.replacingOccurrences(of: "<br>", with: "\n")

        return FeedViewModel.Cell(postId: feedItem.postId,
                                  iconUrlImage: profile.photo,
                                  name: profile.name,
                                  date: dateTitle,
                                  text: postText,
                                  likes: formattedCounter(feedItem.likes?.count),
                                  comments: formattedCounter(feedItem.comments?.count),
                                  shares: formattedCounter(feedItem.reposts?.count),
                                  views: formattedCounter(feedItem.views?.count),
                                  photoAttachments: photoAttachments,
                                  sizes: sizes)
    }

    private func formattedCounter(_ counter: Int?) -> String? {
        guard let counter = counter, counter > 0 else { return nil }

        var counterStr = String(counter)
        if 4...6 ~= counterStr.count {
            counterStr = String(counterStr.dropLast(3) + "K")
        } else if counterStr.count > 6 {
            counterStr = String(counterStr.dropLast(6) + "M")
        }

        return counterStr
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

    private func createPhotoAttachment(feedItem: FeedItem) -> FeedViewModel.FeedCellPhotoAttachment? {
        guard
            let photos = feedItem.attachments?.compactMap({ attachment in
            attachment.photo
        }), let firstPhoto = photos.first else {
            return nil
        }

        return FeedViewModel.FeedCellPhotoAttachment(photoUrlString: firstPhoto.srcBIG,
                                                     width: firstPhoto.width,
                                                     height: firstPhoto.height)
    }

    private func createPhotoAttachments(feedItem: FeedItem) -> [FeedViewModel.FeedCellPhotoAttachment] {
        guard let attachments = feedItem.attachments else { return [] }

        return attachments.compactMap { attachment -> FeedViewModel.FeedCellPhotoAttachment? in
            guard let photo = attachment.photo else { return nil }

            return FeedViewModel.FeedCellPhotoAttachment(photoUrlString: photo.srcBIG,
                                                         width: photo.width,
                                                         height: photo.height)
        }

    }
}
