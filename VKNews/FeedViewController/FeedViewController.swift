//
//  FeedViewController.swift
//  VKNews
//
//  Created by Misha Volkov on 20.03.23.
//

import UIKit

class FeedViewController: UIViewController {
    private let networkService = NetworkService()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        networkService.request(path: API.newsFeed, parameters: ["filters": "post,photo"]) { data, error in
        }
    }
}
