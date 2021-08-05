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

    var onSearchStarted: (() -> Void)?
    var onSearchFinished: (() -> Void)?
    var onAddressAlreadyAdded: (() -> Void)?
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
        if isAddressAlreadyAdded(place: place) {
            onAddressAlreadyAdded?()
            return
        }

        //Persist place...
        var places = persistenceProvider.getPersistedPlaces()
        places.append(place)
        persistenceProvider.persistPlaces(places)

        guard let indexToRemove = searchResults.firstIndex(of: place) else {
            return
        }

        //... then remove from expanded cell list
        expandedCells.remove(indexToRemove)

        //... then remove from the list of search results
        searchResults.remove(at: indexToRemove)
    }

    private func isAddressAlreadyAdded(place: Place) -> Bool {
        let places = persistenceProvider.getPersistedPlaces()
        return places.contains { p in
            p.place_id == place.place_id
        }
    }

    private func performSearch() {
        guard searchText != "" else {
            searchResults.removeAll()
            return
        }

        onSearchStarted?()

        PlacesService.searchLocations(searchString: searchText) { [weak self] response in
            guard let response = response else {
                return
            }

            DispatchQueue.main.async {
                self?.onSearchFinished?()
                self?.searchResults.removeAll()
                self?.expandedCells.removeAll()

                guard let results = response.results else {
                    return
                }

                self?.searchResults = results
            }
        }
    }
}
