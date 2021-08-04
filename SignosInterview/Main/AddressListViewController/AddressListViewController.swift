//
//  AddressListViewController.swift
//  SignosInterview
//
//  Created by John Macy on 8/3/21.
//

import UIKit

class AddressListViewController: UIViewController {

    static let reuseIdentifier = "AddressListViewCell"

    var viewModel: AddressListViewModel?

    @IBOutlet private var tableViewAddresses: UITableView!

    @IBAction func btnNewAddressPressed(_ sender: Any) {
        viewModel?.onNewAddressPressed()
    }

    private lazy var segmentFilter: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: AddressFilter.allCases.map({ $0.rawValue }))
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.apportionsSegmentWidthsByContent = true
        segmentedControl.addTarget(self, action: #selector(segmentValueChanged(_:)), for: .valueChanged)
        return segmentedControl
    }()

    override func viewDidLoad() {
        configureView()
        configureViewModel()
    }

    private func configureView() {
        self.title = "My Addresses"
        self.navigationItem.titleView = segmentFilter
        self.tableViewAddresses.register(UITableViewCell.self, forCellReuseIdentifier: AddressListViewController.reuseIdentifier)
    }

    private func configureViewModel() {
        viewModel?.didUpdateAddressItems = { [weak self] in
            self?.tableViewAddresses.reloadSections([0], with: .automatic)
        }
    }

    @objc private func segmentValueChanged(_ sender: UISegmentedControl) {
        viewModel?.filterType = AddressFilter.allCases[segmentFilter.selectedSegmentIndex]
    }
}

extension AddressListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.filteredAddresses?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AddressListViewController.reuseIdentifier, for: indexPath)

        cell.textLabel?.text = viewModel?.filteredAddresses?[indexPath.row].name

        return cell
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] (_, _, completionHandler) in
            self?.viewModel?.removeFilteredItem(index: indexPath.row)
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
