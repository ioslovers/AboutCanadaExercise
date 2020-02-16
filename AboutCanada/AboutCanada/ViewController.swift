//
//  ViewController.swift
//  AboutCanada
//
//  Created by Ashish Tripathi on 16/02/20.
//  Copyright © 2020 Ashish Tripathi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let cellId = "rowCell"
    private var facts: Facts? = nil
    private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchFactsAboutCanada()
    }
    
    func setupView() {
        tableView = UITableView(frame: .zero)
        self.view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor,
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
        tableView.register(RowTableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    func fetchFactsAboutCanada() {
        Networking.fetchFactsAboutCanada { result in
            switch result {
            case .success(let factsData):
                self.facts = factsData
            case .failure(_):
                self.facts = nil
            }
            DispatchQueue.main.async {
                self.title = self.facts?.title ?? ""
                self.tableView.reloadData()
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let rows = facts?.rows else { return }
        print("Value: \(rows[indexPath.row])")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rows = facts?.rows else { return 0 }
        return rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath as IndexPath) as! RowTableViewCell
        guard let rows = facts?.rows else { return UITableViewCell() }
        cell.row = rows[indexPath.row]
        return cell
    }
}
