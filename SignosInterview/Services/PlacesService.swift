//
//  PlacesService.swift
//  SignosInterview
//
//  Created by John Macy on 8/3/21.
//

import Foundation

protocol PlacesAPI {
    func searchLocations(searchString: String, completion: @escaping ((PlacesResponse?) -> Void))
    func getPhoto(reference: String)
}

class PlacesService: PlacesAPI {

    private static let apiKey = "AIzaSyAYJk3vTAJCmrEjoq5zdNHsBERlwhdk1f4"

    func searchLocations(searchString: String, completion: @escaping ((PlacesResponse?) -> Void)) {
        let searchAPIEndpoint = "https://maps.googleapis.com/maps/api/place/textsearch/json?key=\(PlacesService.apiKey)&types=restaurant,supermarket,gym&query=\(searchString.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? "")"

        guard let url = URL(string: searchAPIEndpoint) else { return }

        URLSession.shared.dataTask(with: url) { (data, response, err) in

            guard let data = data else { return }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let response = try decoder.decode(PlacesResponse.self, from: data)
                completion(response)
            } catch {
                print(error)
                completion(nil)
            }

        }.resume()
    }

    func getPhoto(reference: String) {
        let url = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(reference)&key=\(PlacesService.apiKey)"
    }
}
