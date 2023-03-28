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
    // MARK: - Constants/variables
    var interactor: NewsFeedBusinessLogic?
    var router: (NSObjectProtocol & NewsFeedRoutingLogic)?

    private var feedViewModel = FeedViewModel(cells: [], footerTitle: nil)

    // MARK: - Views
    @IBOutlet weak var table: UITableView!
    private lazy var titleView = TitleView()
    private lazy var footerView = FooterView()
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)

        return refreshControl
    }()

    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVIPcycle()
        setupTopBar()
        setupTable()

        interactor?.makeRequest(request: .getNewsFeed)
        interactor?.makeRequest(request: .getUser)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupStatusBar()
    }

    // MARK: - Functions
    func displayData(viewModel: NewsFeed.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .displayNewsFeed(let feedViewModel):
            self.feedViewModel = feedViewModel
            table.reloadData()
            refreshControl.endRefreshing()
            footerView.setTitle(feedViewModel.footerTitle)
        case .displayUser(let userViewModel):
            titleView.set(userViewModel: userViewModel)
        case .displayFooterLoader:
            footerView.showLoader()
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y > scrollView.contentSize.height * 0.95 {
            print("scrolled 95%")
            interactor?.makeRequest(request: .getNextBatch)
        }
    }

    @objc private func refresh() {
        interactor?.makeRequest(request: .getNewsFeed)
    }

    private func setupStatusBar() {
        if let statusBarFrame = view.window?.windowScene?.statusBarManager?.statusBarFrame {
            let statusBar = UIView(frame: statusBarFrame)
            statusBar.backgroundColor = navigationController?.navigationBar.backgroundColor
            statusBar.layer.shadowColor = UIColor.black.cgColor
            statusBar.layer.shadowOpacity = 0.3
            statusBar.layer.shadowOffset = .zero
            statusBar.layer.shadowRadius = 8
            view.addSubview(statusBar)
        }
    }

    private func setupTopBar() {
        navigationController?.navigationBar.backgroundColor = .systemCyan
        navigationController?.hidesBarsOnSwipe = true
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.titleView = titleView
    }

    private func setupTable() {
        let topInset: CGFloat = 8
        table.contentInset.top = topInset
        table.separatorStyle = .none
        table.backgroundColor = .clear

        table.register(NewsFeedCodeCell.self, forCellReuseIdentifier: NewsFeedCodeCell.reuseId)
        table.addSubview(refreshControl)
        table.tableFooterView = footerView
    }

    private func setupVIPcycle() {
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
}

// MARK: - UITableViewDelegate
extension NewsFeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellViewModel = feedViewModel.cells[indexPath.row]

        return cellViewModel.sizes.totalHeigt
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
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
        cell.delegate = self
        cell.set(viewModel: cellViewModel)

        return cell
    }
}

// MARK: - NewsFeedCodeCellDelegate
extension NewsFeedViewController: NewsFeedCodeCellDelegate {
    func revealPost(for cell: NewsFeedCodeCell) {
        guard let indexPath = table.indexPath(for: cell) else { return }

        let cellViewModel = feedViewModel.cells[indexPath.row]

        interactor?.makeRequest(request: .revealPostIds(cellViewModel.postId))
    }
}
