//
//  AddressListViewController.swift
//  SignosInterview
//
//  Created by John Macy on 8/3/21.
//

import UIKit

class AddressListViewController: UIViewController {

    static let reuseIdentifier = "AddressListViewCell"

    @IBOutlet var tableViewAddresses: UITableView!

    var viewModel: AddressListViewModel?

    override func viewDidLoad() {
        configureView()
        configureViewModel()
    }

    private func configureView() {
        self.tableViewAddresses.register(UITableViewCell.self, forCellReuseIdentifier: AddressListViewController.reuseIdentifier)
    }

    private func configureViewModel() {
        viewModel?.didUpdateAddressItems = { [weak self] in
            self?.tableViewAddresses.reloadSections([0], with: .automatic)
        }
    }
}

extension AddressListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.addresses?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AddressListViewController.reuseIdentifier, for: indexPath)

        cell.textLabel?.text = viewModel?.addresses?[indexPath.row].addressLine1

        return cell
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] (_, _, completionHandler) in
            self?.viewModel?.removeItem(index: indexPath.row)
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}

extension AddressListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("row selected \(indexPath.row)")
    }
}
