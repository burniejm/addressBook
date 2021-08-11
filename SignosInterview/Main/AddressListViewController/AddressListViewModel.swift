//
//  AddressListViewModel.swift
//  SignosInterview
//
//  Created by John Macy on 8/3/21.
//

import Foundation

enum AddressFilter: String, CaseIterable {
    case All
    case Gyms
    case Restaurants
    case Supermarkets

    func addressType() -> AddressType? {
        switch self {

        case .All:
            return nil
        case .Gyms:
            return .Gym
        case .Restaurants:
            return .Restaurant
        case .Supermarkets:
            return .Supermarket
        }
    }
}

protocol AddressListViewModelDelegate: AnyObject {
    func didSelectNewAddress()
}

class AddressListViewModel {
    private var addresses: [Place] = [Place]() {
        didSet {
            filterAddresses()
        }
    }

    var filteredAddresses: [Place] = [Place]() {
        didSet {
            onAddressItemsChanged?()
        }
    }

    var filterType: AddressFilter = .All {
        didSet {
            expandedCells.removeAll()
            filterAddresses()
        }
    }

    weak var delegate: AddressListViewModelDelegate?
    var onAddressItemsChanged: (() -> Void)?
    var expandedCells = IndexSet()

    private var persistenceProvider: PlacesPersistenceProvider

    init(delegate: AddressListViewModelDelegate, persistenceProvider: PlacesPersistenceProvider) {
        self.delegate = delegate
        self.persistenceProvider = persistenceProvider
    }

    func onViewAppeared() {
        loadAdresses()
    }

    func onNewAddressPressed() {
        expandedCells.removeAll()
        delegate?.didSelectNewAddress()
    }

    func setFilteredAddressPinned(index: Int) {
        guard index < filteredAddresses.count else {
            return
        }

        let filteredPlace = filteredAddresses[index]

        guard let indexToPin = addresses.firstIndex(of: filteredPlace) else {
            return
        }

        let isPinned = addresses[indexToPin].isPinned

        addresses[indexToPin].isPinned = !isPinned
        persistenceProvider.persistPlaces(addresses)
    }

    func removeFilteredItem(index: Int) {
        guard index < filteredAddresses.count else {
            return
        }

        let itemToRemove = filteredAddresses[index]

        guard let indexToRemove = addresses.firstIndex(of: itemToRemove) else {
            return
        }

        //first remove from expanded cells...
        expandedCells.remove(index)

        //... then remove from list...
        addresses.remove(at: indexToRemove)

        //... finally remove from persisted places
        persistenceProvider.persistPlaces(addresses)
    }

    func rowSelected(index: Int) {
        if expandedCells.contains(index) {
            expandedCells.remove(index)
        } else {
            expandedCells.insert(index)
        }
    }

    private func filterAddresses() {
        var filtered = filteredAddresses

        switch filterType {
        case .All:
            filtered = addresses
            break

        default:
            filtered = addresses.filter({ item in
                return item.addressType == filterType.addressType()
            })
            break
        }

        filtered.sort { p1, p2 in
            return p1.isPinned
        }

        filteredAddresses = filtered
    }

    private func loadAdresses() {
        addresses = persistenceProvider.getPersistedPlaces()
    }
}
