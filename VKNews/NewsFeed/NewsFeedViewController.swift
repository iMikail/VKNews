//
//  NewsFeedViewController.swift
//  VKNews
//
//  Created by Misha Volkov on 20.03.23.
//

import UIKit

protocol NewsFeedDisplayLogic: AnyObject {
    func displayData(viewModel: NewsFeed.Model.ViewModel.ViewModelData)
}

class NewsFeedViewController: UIViewController, NewsFeedDisplayLogic {
    var interactor: NewsFeedBusinessLogic?
    var router: (NSObjectProtocol & NewsFeedRoutingLogic)?

    private var feedViewModel = FeedViewModel(cells: [])

    @IBOutlet weak var table: UITableView!

    // MARK: Object lifecycle
    // MARK: Setup
    private func setup() {
        let viewController        = self
        let interactor            = NewsFeedInteractor()
        let presenter             = NewsFeedPresenter()
        let router                = NewsFeedRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
    }

    // MARK: Routing
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        table.register(UINib(nibName: NewsFeedCell.reuseId, bundle: nil),
                       forCellReuseIdentifier: NewsFeedCell.reuseId)
        table.register(NewsFeedCodeCell.self, forCellReuseIdentifier: NewsFeedCodeCell.reuseId)
        interactor?.makeRequest(request: .getNewsFeed)

        table.separatorStyle = .none
        table.backgroundColor = .clear
        view.backgroundColor = .systemIndigo
    }

    func displayData(viewModel: NewsFeed.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .displayNewsFeed(let feedViewModel):
            self.feedViewModel = feedViewModel
            table.reloadData()
        }
    }
}

// MARK: - UITableViewDelegate
extension NewsFeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellViewModel = feedViewModel.cells[indexPath.row]

        return cellViewModel.sizes.totalHeigt
    }
}

// MARK: - UITableViewDataSource
extension NewsFeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        feedViewModel.cells.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // with Xib
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsFeedCell.reuseId,
//                                                       for: indexPath) as? NewsFeedCell else {
//            return UITableViewCell()
//        }

        // with Code
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsFeedCodeCell.reuseId,
                                                       for: indexPath) as? NewsFeedCodeCell else {
            return UITableViewCell()
        }

        let cellViewModel = feedViewModel.cells[indexPath.row]
        cell.set(viewModel: cellViewModel)
        return cell
    }
}
