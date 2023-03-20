//
//  NetworkService.swift
//  VKNews
//
//  Created by Misha Volkov on 20.03.23.
//

import Foundation

final class NetworkService {
    private let authService: AuthService

    init(authService: AuthService = SceneDelegate.shared().authService ?? AuthService()) {
        self.authService = authService
    }

    func getFeed() {
        guard let token = authService.token else { return }

        var components = URLComponents()
        let params = ["filters": "post,photo"]
        var allParams = params
        allParams["access_token"] = token
        allParams["v"] = API.version

        components.scheme = API.scheme
        components.host = API.host
        components.path = API.newsFeed
        components.queryItems = allParams.map { (name, value) in
            URLQueryItem(name: name, value: value)
        }

        let url = components.url
        print(url!)//-
    }
}
