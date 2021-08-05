//
//  AddressListViewController.swift
//  SignosInterview
//
//  Created by John Macy on 8/3/21.
//

import UIKit

class AddressListViewController: UIViewController {

    var viewModel: AddressListViewModel!

    @IBOutlet private weak var tableViewAddresses: UITableView!

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
        super.viewDidLoad()
        configureView()
        configureViewModel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.onViewAppeared()
    }

    private func configureView() {
        self.title = "My Addresses"
        self.navigationItem.titleView = segmentFilter
        tableViewAddresses.register(UINib(nibName: "PlaceTableViewCell", bundle: nil), forCellReuseIdentifier: PlaceTableViewCell.reuseIdentifier)
    }

    private func configureViewModel() {
        viewModel.onAddressItemsChanged = { [weak self] in
            self?.tableViewAddresses.reloadSections([0], with: .automatic)
        }
    }

    @objc private func segmentValueChanged(_ sender: UISegmentedControl) {
        viewModel.filterType = AddressFilter.allCases[segmentFilter.selectedSegmentIndex]
    }
}

extension AddressListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredAddresses.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlaceTableViewCell.reuseIdentifier) as? PlaceTableViewCell else {
            return UITableViewCell()
        }

        let placeVM = PlaceViewModel(place: viewModel.filteredAddresses[indexPath.row])
        cell.configure(placeVM: placeVM, showAddButton: false, isExpanded: viewModel.expandedCells.contains(indexPath.row))

        cell.onCallUnsupported = {
            self.showError("Sorry, phone calls are not supported on this device.")
        }

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
        tableView.deselectRow(at: indexPath, animated: false)
        viewModel.rowSelected(index: indexPath.row)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
