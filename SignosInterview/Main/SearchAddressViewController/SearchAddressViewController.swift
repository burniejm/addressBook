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

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.startAnimating()
        return indicator
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
            self?.tableViewSearchResults.reloadSections([0], with: .automatic)
        }

        viewModel.onSearchStarted = { [weak self] in
            self?.addSpinner()
        }

        viewModel.onSearchFinished = { [weak self] in
            self?.removeSpinner()
        }

        viewModel.onAddressAlreadyAdded = { [weak self] in
            self?.showError("This address has already been added.")
        }
    }

    private func addSpinner() {
        tableViewSearchResults.backgroundView = activityIndicator
    }

    private func removeSpinner() {
        tableViewSearchResults.backgroundView = nil
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

        let placeVM = PlaceViewModel(place: viewModel.searchResults[indexPath.row])
        cell.configure(placeVM: placeVM, showAddButton: true, isExpanded: viewModel.expandedCells.contains(indexPath.row))

        cell.onAddButtonPressed = { [weak self] placeVM in
            self?.viewModel.addPlaceToMyAddresses(placeVM.place)
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

