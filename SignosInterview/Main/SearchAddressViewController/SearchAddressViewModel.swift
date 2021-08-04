//
//  SearchAddressViewModel.swift
//  SignosInterview
//
//  Created by John Macy on 8/3/21.
//

import Foundation

class SearchAddressViewModel {

    private static let debounceInterval = 0.5

    private var debounceTimer: Timer?
    private let placesService = PlacesService()

    var searchResults: [Place] = [Place]() {
        didSet {
            onSearchResultsChanged?()
        }
    }

    var searchText: String = "" {
        didSet {
            debounceTimer?.invalidate()
            debounceTimer = Timer.scheduledTimer(withTimeInterval: SearchAddressViewModel.debounceInterval, repeats: false, block: { [weak self] _ in
                self?.performSearch()
            })
        }
    }

    var onSearchResultsChanged: (() -> Void)?

    func onCancelSearchPressed() {
        debounceTimer?.invalidate()
        searchResults.removeAll()
    }

    private func performSearch() {
        guard searchText != "" else {
            searchResults.removeAll()
            return
        }

        placesService.searchLocations(searchString: searchText) { [weak self] response in
            guard let response = response else {
                return
            }

            DispatchQueue.main.async {
                self?.searchResults.removeAll()

                guard let results = response.results else {
                    return
                }

                self?.searchResults = results
            }
        }
    }
}
