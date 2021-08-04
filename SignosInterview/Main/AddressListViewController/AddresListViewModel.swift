//
//  AddresListViewModel.swift
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
        //TODO: do i really need this?

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

    var filteredAddresses: [Place]? = [Place]() {
        didSet {
            didUpdateAddressItems?()
        }
    }

    var filterType: AddressFilter = .All {
        didSet {
            filterAddresses()
        }
    }

    weak var delegate: AddressListViewModelDelegate?
    var persistanceProvider: PlacesPersistanceProvider
    var didUpdateAddressItems: (() -> Void)?

    init(delegate: AddressListViewModelDelegate, persistanceProvider: PlacesPersistanceProvider) {
        self.delegate = delegate
        self.persistanceProvider = persistanceProvider
        loadAdresses()
    }

    func onNewAddressPressed() {
        delegate?.didSelectNewAddress()
    }

    func removeFilteredItem(index: Int) {
        guard let filteredAddresses = filteredAddresses,
              index < filteredAddresses.count else {
            return
        }

        let itemToRemove = filteredAddresses[index]

        guard let indexToRemove = addresses.firstIndex(of: itemToRemove) else {
            return
        }

        addresses.remove(at: indexToRemove)
    }

    private func filterAddresses() {
        switch filterType {
        case .All:
            filteredAddresses = addresses
            break

        default:
            filteredAddresses = addresses.filter({ item in
                return item.addressType == filterType.addressType()
            })
            break
        }
    }

    private func loadAdresses() {
        persistanceProvider.seedPersistedPlaces()
        addresses = persistanceProvider.getPersistedPlaces()
    }
}
