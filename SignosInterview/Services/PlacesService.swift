//
//  PlacesService.swift
//  SignosInterview
//
//  Created by John Macy on 8/3/21.
//

import Foundation
import UIKit

protocol PlacesAPI {
    static func searchLocations(searchString: String, completion: @escaping ((PlacesResponse?) -> Void))
    static func getPhoto(reference: String, maxHeight: Int, maxWidth: Int, completion: @escaping (UIImage?) -> Void)
    static func getDetails(placeId: String, completion: @escaping (PlaceDetailResponse?) -> Void)
    static func getMapPhoto(address: String, lat: Double, long: Double, width: Int, height: Int, completion: @escaping (UIImage?) -> Void)
}

class PlacesService: PlacesAPI {

    private static let apiKey = "AIzaSyAYJk3vTAJCmrEjoq5zdNHsBERlwhdk1f4"

    static func searchLocations(searchString: String, completion: @escaping ((PlacesResponse?) -> Void)) {
        let searchAPIEndpoint = "https://maps.googleapis.com/maps/api/place/textsearch/json?key=\(PlacesService.apiKey)&types=restaurant,supermarket,gym&query=\(searchString.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? "")"

        guard let url = URL(string: searchAPIEndpoint) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, err) in

            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let data = data, err == nil
            else {
                completion(nil)
                return
            }

            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(PlacesResponse.self, from: data)
                completion(response)
            } catch {
                print(error)
                completion(nil)
            }

        }.resume()
    }

    static func getPhoto(reference: String, maxHeight: Int, maxWidth: Int, completion: @escaping (UIImage?) -> Void) {
        let photoEndpoint = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(reference)&key=\(PlacesService.apiKey)&maxheight=\(maxHeight)&maxwidth=\(maxWidth)"

        guard let url = URL(string: photoEndpoint) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, err) in

            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, err == nil,
                let image = UIImage(data: data)
            else {
                completion(nil)
                return
            }

            completion(image)

        }.resume()
    }

    static func getMapPhoto(address: String, lat: Double, long: Double, width: Int, height: Int, completion: @escaping (UIImage?) -> Void) {
        let mapPhotoEndpoint = "https://maps.googleapis.com/maps/api/staticmap?center=\(address.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? "")&zoom=13&size=\(width)x\(height)&maptype=roadmap&key=\(PlacesService.apiKey)&markers=color:red%7C\(lat),\(long)"

        guard let url = URL(string: mapPhotoEndpoint) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, err) in

            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, err == nil,
                let image = UIImage(data: data)
            else {
                completion(nil)
                return
            }

            completion(image)

        }.resume()
    }

    static func getDetails(placeId: String, completion: @escaping (PlaceDetailResponse?) -> Void) {
        let detailsEndpoint = "https://maps.googleapis.com/maps/api/place/details/json?key=\(PlacesService.apiKey)&place_id=\(placeId)"

        guard let url = URL(string: detailsEndpoint) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, err) in

            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let data = data, err == nil
            else {
                completion(nil)
                return
            }

            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(PlaceDetailResponse.self, from: data)
                completion(response)
            } catch {
                print(error)
                completion(nil)
            }

        }.resume()
    }
}
