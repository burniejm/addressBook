//
//  PlacesPersistenceProviderUserDefaults.swift
//  SignosInterview
//
//  Created by John Macy on 8/3/21.
//

import Foundation

protocol PlacesPersistenceProvider {
    func getPersistedPlaces() -> [Place]
    func persistPlaces(_ places: [Place])
    func seedPersistedPlaces()
}

class PlacesPersistenceProviderUserDefaults: PlacesPersistenceProvider {

    static let defaultsKeyHasSeeded: String = "defaultsSeeded"
    static let defaultsKeyPersistedPlaces: String = "persistedPlaces"

    func getPersistedPlaces() -> [Place] {
        let places: [Place]? = UserDefaults.standard.structArrayData(Place.self, forKey: PlacesPersistenceProviderUserDefaults.defaultsKeyPersistedPlaces)

        return places ?? [Place]()
    }

    func persistPlaces(_ places: [Place]) {
        UserDefaults.standard.setStructArray(places, forKey: PlacesPersistenceProviderUserDefaults.defaultsKeyPersistedPlaces)
    }

    func seedPersistedPlaces() {
        let alreadySeeded = UserDefaults.standard.bool(forKey: PlacesPersistenceProviderUserDefaults.defaultsKeyHasSeeded)
        if alreadySeeded {
            return
        }

        let place = Place(formattedAddress: "123 address st", name: "test", rating: 5, addressType: .Restaurant)
        persistPlaces([place])
        UserDefaults.standard.setValue(true, forKey: PlacesPersistenceProviderUserDefaults.defaultsKeyHasSeeded)
    }
}
