//
//  SearchAddressViewModel.swift
//  SignosInterview
//
//  Created by John Macy on 8/3/21.
//

import Foundation

protocol SearchAddressViewModelDelegate {

}

class SearchAddressViewModel {

    private static let debounceInterval = 0.5

    private var debounceTimer: Timer?
    private var delegate: SearchAddressViewModelDelegate
    private var persistenceProvider: PlacesPersistenceProvider

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
    var expandedCells = IndexSet()

    init(delegate: SearchAddressViewModelDelegate, persistenceProvider: PlacesPersistenceProvider) {
        self.delegate = delegate
        self.persistenceProvider = persistenceProvider
    }

    func onCancelSearchPressed() {
        debounceTimer?.invalidate()
        searchResults.removeAll()
    }

    func rowSelected(index: Int) {
        if expandedCells.contains(index) {
            expandedCells.remove(index)
        } else {
            expandedCells.insert(index)
        }
    }

    func addPlaceToMyAddresses(_ place: Place) {
        //Persist place...
        var places = persistenceProvider.getPersistedPlaces()
        places.append(place)
        persistenceProvider.persistPlaces(places)

        guard let index = searchResults.firstIndex(of: place) else {
            return
        }

        //... then remove from expanded cell list
        expandedCells.remove(index)

        //... then remove from the list of search results
        searchResults.remove(at: index)
    }

    private func performSearch() {
        guard searchText != "" else {
            searchResults.removeAll()
            return
        }

        PlacesService.searchLocations(searchString: searchText) { [weak self] response in
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
