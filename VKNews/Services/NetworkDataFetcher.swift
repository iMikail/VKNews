//
//  NetworkDataFetcher.swift
//  VKNews
//
//  Created by Misha Volkov on 20.03.23.
//

import Foundation

protocol DataFetcher {
    func getFeed(nextBatchFrom: String?, response: @escaping (FeedResponse?) -> Void)
    func getUser(response: @escaping (UserResponse?) -> Void)
}

struct NetworkDataFetcher: DataFetcher {
    let networking: Networking
    private let authService: AuthService

    init(networking: Networking, authService: AuthService = SceneDelegate.shared().authService ?? AuthService()) {
        self.networking = networking
        self.authService = authService
    }

    func getFeed(nextBatchFrom: String?, response: @escaping (FeedResponse?) -> Void) {
        var parameters = ["filters": "post, photo"]
        parameters["start_from"] = nextBatchFrom
        networking.request(path: API.newsFeed, parameters: parameters) { (data, error) in
            if let error = error {
                print("Error received requesting data: \(error)")
                response(nil)
            }

            let decoded = decodeJson(type: FeedResponseWrapped.self, from: data)
            response(decoded?.response)
        }
    }

    func getUser(response: @escaping (UserResponse?) -> Void) {
        guard let userId = authService.userId else { return }

        let parameters = ["user_ids": userId, "fields": "photo_100"]
        networking.request(path: API.user, parameters: parameters) { (data, error) in
            if let error = error {
                print("Error received requesting data: \(error)")
                response(nil)
            }

            let decoded = decodeJson(type: UserResponseWrapped.self, from: data)
            response(decoded?.response.first)
        }
    }

    private func decodeJson<T: Decodable>(type: T.Type, from: Data?) -> T? {
        guard let data = from else { return nil }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let response = try decoder.decode(type.self, from: data)
            return response
        } catch {
            print("Error decode: \(error)")
        }

        return nil
    }
}
