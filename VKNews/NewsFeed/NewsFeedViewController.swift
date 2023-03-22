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
    let cellIdentifier = "cell"
    var interactor: NewsFeedBusinessLogic?
    var router: (NSObjectProtocol & NewsFeedRoutingLogic)?

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
        table.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }

    func displayData(viewModel: NewsFeed.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .displayNewsFeed:
            print("selected row")
        }
    }
}

extension NewsFeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        interactor?.makeRequest(request: .getFeed)
    }
}

extension NewsFeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                     for: indexPath) as? UITableViewCell else
            { return UITableViewCell() }
        cell.textLabel?.text = "index: \(indexPath.row)"

        return cell
    }
}
