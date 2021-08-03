//
//  AddressItem.swift
//  SignosInterview
//
//  Created by John Macy on 8/3/21.
//

import Foundation

enum AddressType: String {
    case Gym
    case Restaurant
    case Supermarket
}

struct AddressItem {
    let addressLine1: String
    let type: AddressType
}