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
}

class PlacesPersistenceProviderUserDefaults: PlacesPersistenceProvider {

    static let defaultsKeyPersistedPlaces: String = "persistedPlaces"

    func getPersistedPlaces() -> [Place] {
        let places: [Place]? = UserDefaults.standard.structArrayData(Place.self, forKey: PlacesPersistenceProviderUserDefaults.defaultsKeyPersistedPlaces)

        return places ?? [Place]()
    }

    func persistPlaces(_ places: [Place]) {
        UserDefaults.standard.setStructArray(places, forKey: PlacesPersistenceProviderUserDefaults.defaultsKeyPersistedPlaces)
    }
}
