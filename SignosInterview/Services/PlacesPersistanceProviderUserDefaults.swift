//
//  PlacesPersistanceProviderUserDefaults.swift
//  SignosInterview
//
//  Created by John Macy on 8/3/21.
//

import Foundation

protocol PlacesPersistanceProvider {
    func getPersistedPlaces() -> [Place]
    func persistPlaces(_ places: [Place])
    func seedPersistedPlaces()
}

class PlacesPersistanceProviderUserDefaults: PlacesPersistanceProvider {

    static let defaultsKeyHasSeeded: String = "defaultsSeeded"
    static let defaultsKeyPersistedPlaces: String = "persistedPlaces"

    func getPersistedPlaces() -> [Place] {
        let places: [Place]? = UserDefaults.standard.structArrayData(Place.self, forKey: PlacesPersistanceProviderUserDefaults.defaultsKeyPersistedPlaces)

        return places ?? [Place]()
    }

    func persistPlaces(_ places: [Place]) {
        UserDefaults.standard.setStructArray(places, forKey: PlacesPersistanceProviderUserDefaults.defaultsKeyPersistedPlaces)
    }

    func seedPersistedPlaces() {
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }

        let alreadySeeded = UserDefaults.standard.bool(forKey: PlacesPersistanceProviderUserDefaults.defaultsKeyPersistedPlaces)
        if alreadySeeded {
            return
        }

        let place = Place(formattedAddress: "123 address st", name: "test", rating: 5, addressType: .Restaurant)
        persistPlaces([place])
        UserDefaults.standard.setValue(true, forKey: PlacesPersistanceProviderUserDefaults.defaultsKeyHasSeeded)
    }
}
