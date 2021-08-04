//
//  SearchAddressViewController.swift
//  SignosInterview
//
//  Created by John Macy on 8/3/21.
//

import UIKit

class SearchAddressViewController: UIViewController {

    private static let reuseIdentifier = "SearchAddressCell"

    @IBOutlet private var tableViewSearchResults: UITableView!
    var viewModel: SearchAddressViewModel?

    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchResultsUpdater = self
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.placeholder = "Search Locations"
        controller.automaticallyShowsSearchResultsController = true
        return controller
    }()

    override func viewDidLoad() {
        setupView()
        setupViewModel()
    }

    private func setupView() {
        self.tableViewSearchResults.register(UITableViewCell.self, forCellReuseIdentifier: SearchAddressViewController.reuseIdentifier)

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
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
        let cell = tableViewSearchResults.dequeueReusableCell(withIdentifier: SearchAddressViewController.reuseIdentifier, for: indexPath)

        let place = viewModel?.searchResults[indexPath.row]
        cell.textLabel?.text = place?.name

        return cell
    }
}

extension SearchAddressViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let place = viewModel?.searchResults[indexPath.row]
        print("place Type:\(place!.addressType)")
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
