//
//  FeedViewController.swift
//  VKNews
//
//  Created by Misha Volkov on 20.03.23.
//

import UIKit

class FeedViewController: UIViewController {
    private let fetcher: DataFetcher = NetworkDataFetcher(networking: NetworkService())

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        fetcher.getFeed { feedResponse in
        }
    }
}
