//
//  AboutCanadaViewController.swift
//  AboutCanada
//
//  Created by Ashish Tripathi on 16/02/20.
//  Copyright © 2020 Ashish Tripathi. All rights reserved.
//

import UIKit

final class AboutCanadaViewController: UIViewController {
    private var tableView: UITableView!
    private var activityIndicator = UIActivityIndicatorView()
    private let refreshControl = UIRefreshControl()
    private let aboutCanadaViewModel = AboutCanadaViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()

        aboutCanadaViewModel.delegate = self
        aboutCanadaViewModel.viewDidLoad()
    }

    private func setupView() {
        /// Refresh control and Bar button item
        setupRefreshControl()

        /// Setup Table view
        setupTableView()

        /// Setup loading indicator
        setupActivityIndicator()
    }

    private func setupTableView() {
        tableView = UITableView(frame: .zero)
        view.addSubview(tableView)
        tableView.addAnchor(top: view.topAnchor,
                            left: view.leftAnchor,
                            bottom: view.bottomAnchor,
                            right: view.rightAnchor,
                            paddingTop: 0,
                            paddingLeft: 0,
                            paddingBottom: 0,
                            paddingRight: 0,
                            width: 0,
                            height: 0,
                            enableInsets: false)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        tableView.register(RowTableViewCell.self, forCellReuseIdentifier: ConstantsString.cellIdentifier)
        tableView.refreshControl = refreshControl
    }

    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        activityIndicator.center = CGPoint(x: view.bounds.size.width / 2, y: view.bounds.size.height / 2)
        activityIndicator.color = UIColor.darkModeSupportedColor()
        if #available(iOS 13.0, *) {
            activityIndicator.style = .large
        } else {
            activityIndicator.style = .gray
        }
        view.addSubview(activityIndicator)
    }

    private func setupRefreshControl() {
        let leftBarButton = UIBarButtonItem(title: NSLocalizedString("refreshTitle", comment: ""),
                                            style: .plain,
                                            target: self,
                                            action: #selector(fetchFactsAboutCanada))

        refreshControl.addTarget(self,
                                 action: #selector(fetchFactsAboutCanada),
                                 for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: NSLocalizedString("refreshingStatus",
                                                                                      comment: ""),
                                                            attributes: nil)
        refreshControl.tintColor = UIColor.darkModeSupportedColor()

        navigationItem.setRightBarButton(leftBarButton, animated: true)
    }

    @objc
    private func fetchFactsAboutCanada() {
        aboutCanadaViewModel.fetchAboutCanadaFacts()
    }
}

extension AboutCanadaViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in _: UITableView) -> Int {
        guard let rows = aboutCanadaViewModel.filteredRows, !rows.isEmpty else { return 0 }
        return 1
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        guard let rows = aboutCanadaViewModel.filteredRows else { return 0 }
        return rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ConstantsString.cellIdentifier, for: indexPath as IndexPath) as! RowTableViewCell
        guard let rows = aboutCanadaViewModel.filteredRows else { return UITableViewCell() }
        cell.row = rows[indexPath.row]
        return cell
    }
}

extension AboutCanadaViewController: AboutCanadaViewModelDelegate {
    func shouldDisplayErrorDialog(title: String, message: String) {
        let alert = Alert(title: title,
                          subTitle: message,
                          cancelTitle: NSLocalizedString("okButtonTitle", comment: ""))
        alert.presentAlert(from: self)
    }

    func isLoading() {
        activityIndicator.startAnimating()
    }

    func didFinishLoading() {
        title = aboutCanadaViewModel.facts?.title ?? ""
        tableView.reloadData()
        activityIndicator.stopAnimating()
        refreshControl.endRefreshing()
    }
}
