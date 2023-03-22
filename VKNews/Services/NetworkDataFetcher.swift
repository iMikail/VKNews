//
//  NetworkDataFetcher.swift
//  VKNews
//
//  Created by Misha Volkov on 20.03.23.
//

import Foundation

protocol DataFetcher {
    func getFeed(response: @escaping (FeedResponse?) -> Void)
}

struct NetworkDataFetcher: DataFetcher {
    let networking: Networking

    init(networking: Networking) {
        self.networking = networking
    }

    func getFeed(response: @escaping (FeedResponse?) -> Void) {
        let parameters = ["filters": "post, photo"]
        networking.request(path: API.newsFeed, parameters: parameters) { (data, error) in
            if let error = error {
                print("Error received requesting data: \(error)")
                response(nil)
            }

            let decoded = decodeJson(type: FeedResponseWrapped.self, from: data)
            response(decoded?.response)
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
