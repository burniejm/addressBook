//
//  SearchAddressViewController.swift
//  SignosInterview
//
//  Created by John Macy on 8/3/21.
//

import UIKit

class SearchAddressViewController: UIViewController {

    @IBOutlet private weak var tableViewSearchResults: UITableView!
    var viewModel: SearchAddressViewModel!

    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchResultsUpdater = self
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.placeholder = "Search Locations"
        controller.automaticallyShowsSearchResultsController = true
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupViewModel()
    }

    private func setupView() {
        self.tableViewSearchResults.register(UINib(nibName: "PlaceTableViewCell", bundle: nil), forCellReuseIdentifier: PlaceTableViewCell.reuseIdentifier)

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    private func setupViewModel() {
        viewModel?.onSearchResultsChanged = { [weak self] in
            self?.tableViewSearchResults.reloadData()
        }
    }
}

extension SearchAddressViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.searchResults.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlaceTableViewCell.reuseIdentifier) as? PlaceTableViewCell else {
            return UITableViewCell()
        }

        let place = viewModel.searchResults[indexPath.row]
        cell.configure(place: place, showAddButton: true, isExpanded: viewModel.expandedCells.contains(indexPath.row))

        cell.onAddButtonPressed = { [weak self] place in
            self?.viewModel.addPlaceToMyAddresses(place)
            self?.tableViewSearchResults.reloadRows(at: [indexPath], with: .automatic)
        }

        cell.onCallUnsupported = {
            self.showError("Sorry, phone calls are not supported on this device.")
        }

        return cell
    }
}

extension SearchAddressViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        viewModel.rowSelected(index: indexPath.row)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

extension SearchAddressViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel?.searchText = searchController.searchBar.text ?? ""
    }
}

extension SearchAddressViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel?.onCancelSearchPressed()
    }
}

