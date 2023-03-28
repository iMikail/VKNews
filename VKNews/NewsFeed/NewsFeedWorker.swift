//
//  NewsFeedWorker.swift
//  VKNews
//
//  Created by Misha Volkov on 20.03.23.
//

import UIKit

class NewsFeedService {
    private let fetcher: DataFetcher = NetworkDataFetcher(networking: NetworkService())

    private var revealedPostIds = [Int]()
    private var feedResponse: FeedResponse?
    private var newFromInProcess: String?

    func getFeed(completion: @escaping (FeedResponse, [Int]) -> Void) {
        fetcher.getFeed(nextBatchFrom: nil) { [weak self] feedResponse in
            guard let self = self else { return }

            self.feedResponse = feedResponse
            guard let feedResponse = self.feedResponse else { return }

            completion(feedResponse, self.revealedPostIds)
        }
    }

    func getUser(completion: @escaping (UserResponse?) -> Void) {
        fetcher.getUser { userResponse in
            completion(userResponse)
        }
    }

    func revealPostIds(forPostId postId: Int,
                       completion: @escaping (FeedResponse, [Int]) -> Void) {
        revealedPostIds.append(postId)
        guard let feedResponse = self.feedResponse else { return }

        completion(feedResponse, self.revealedPostIds)
    }

    func getNextBatch(completion: @escaping (FeedResponse, [Int]) -> Void) {
        newFromInProcess = feedResponse?.nextFrom
        fetcher.getFeed(nextBatchFrom: newFromInProcess) { [weak self] feedResponse in
            guard let self = self, let feedResponse = feedResponse else { return }
            guard self.feedResponse?.nextFrom != feedResponse.nextFrom else { return }

            if self.feedResponse == nil {
                self.feedResponse = feedResponse
            } else {
                self.feedResponse?.items.append(contentsOf: feedResponse.items)
                self.feedResponse?.nextFrom = feedResponse.nextFrom

                var profiles = feedResponse.profiles
                if let oldProfiles = self.feedResponse?.profiles {
                    let oldProfilesFiltered = oldProfiles.filter { oldProfile in
                        !feedResponse.profiles.contains { $0.id == oldProfile.id }
                    }
                    profiles.append(contentsOf: oldProfilesFiltered)
                }
                self.feedResponse?.profiles = profiles

                var groups = feedResponse.groups
                if let oldGroups = self.feedResponse?.groups {
                    let oldGroupsFiltered = oldGroups.filter { oldGroup in
                        !feedResponse.groups.contains { $0.id == oldGroup.id }
                    }
                    groups.append(contentsOf: oldGroupsFiltered)
                }
                self.feedResponse?.groups = groups
            }

            guard let feedResponse = self.feedResponse else { return }
            completion(feedResponse, self.revealedPostIds)
        }
    }
}
