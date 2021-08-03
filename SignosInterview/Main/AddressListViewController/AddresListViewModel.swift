//
//  AddresListViewModel.swift
//  SignosInterview
//
//  Created by John Macy on 8/3/21.
//

import Foundation

class AddressListViewModel {
    var addresses: [AddressItem]? = [AddressItem]() {
        didSet {
            didUpdateAddressItems?()
        }
    }

    var didUpdateAddressItems: (() -> Void)?

    init() {
        self.fakeAddresses()
    }

    func removeItem(index: Int) {
        addresses?.remove(at: index)
    }

    private func fakeAddresses() {
        let address1 = AddressItem(addressLine1: "Test 1", type: .Gym)
        let address2 = AddressItem(addressLine1: "Test 2", type: .Restaurant)
        let address3 = AddressItem(addressLine1: "Test 3", type: .Supermarket)

        addresses?.append(address1)
        addresses?.append(address2)
        addresses?.append(address3)
    }
}
