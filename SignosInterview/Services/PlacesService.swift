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

protocol Endpoint {
    var baseURLString: String { get }
    var path: String { get }
    var apiKey: String { get }
}

extension Endpoint {
    var url: String {
        return baseURLString + path
    }
}

enum APIError: Error {
    case MalformedURL
}

enum GoogleApiEndpoints: Endpoint {
    case searchPlaces(searchString: String)
    case getPhoto(reference: String, maxHeight: Int, maxWidth: Int)
    case getPlaceDetails(placeId: String)
    case getStaticMapPhoto(address: String, lat: Double, long: Double, width: Int, height: Int)

    var baseURLString: String {
        return "https://maps.googleapis.com/maps/api/"
    }

    var apiKey: String {
        return "AIzaSyAYJk3vTAJCmrEjoq5zdNHsBERlwhdk1f4"
    }

    var path: String {
        switch self {
        case .searchPlaces(let searchString):
            return "place/textsearch/json?key=\(apiKey)&types=restaurant,supermarket,gym&query=\(searchString.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? "")"

        case .getPhoto(let reference, let maxHeight, let maxWidth):
            return "place/photo?maxwidth=400&photoreference=\(reference)&key=\(apiKey)&maxheight=\(maxHeight)&maxwidth=\(maxWidth)"

        case .getPlaceDetails(let placeId):
            return "place/details/json?key=\(apiKey)&place_id=\(placeId)"

        case .getStaticMapPhoto(let address, let lat, let long, let width, let height):
            return "staticmap?center=\(address.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? "")&zoom=13&size=\(width)x\(height)&maptype=roadmap&key=\(apiKey)&markers=color:red%7C\(lat),\(long)"
        }
    }
}

class PlacesService: PlacesAPI {

    static func searchLocations(searchString: String, completion: @escaping ((PlacesResponse?) -> Void)) {
        let endpoint = GoogleApiEndpoints.searchPlaces(searchString: searchString)

        request(endpoint: endpoint) { data, response, err in
            guard
                let httpURLResponse = response as? HTTPURLResponse,
                httpURLResponse.statusCode == 200,
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
        }
    }

    static func getPhoto(reference: String, maxHeight: Int, maxWidth: Int, completion: @escaping (UIImage?) -> Void) {
        let endpoint = GoogleApiEndpoints.getPhoto(reference: reference, maxHeight: maxHeight, maxWidth: maxWidth)

        request(endpoint: endpoint) { data, response, err in
            guard
                let httpURLResponse = response as? HTTPURLResponse,
                httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, err == nil,
                let image = UIImage(data: data)
            else {
                completion(nil)
                return
            }

            completion(image)
        }
    }

    static func getMapPhoto(address: String, lat: Double, long: Double, width: Int, height: Int, completion: @escaping (UIImage?) -> Void) {
        let endpoint = GoogleApiEndpoints.getStaticMapPhoto(address: address, lat: lat, long: long, width: width, height: height)

        request(endpoint: endpoint) { data, response, err in
            guard
                let httpURLResponse = response as? HTTPURLResponse,
                httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, err == nil,
                let image = UIImage(data: data)
            else {
                completion(nil)
                return
            }

            completion(image)
        }
    }

    static func getDetails(placeId: String, completion: @escaping (PlaceDetailResponse?) -> Void) {
        let endpoint = GoogleApiEndpoints.getPlaceDetails(placeId: placeId)

        request(endpoint: endpoint) { data, response, err in
            guard
                let httpURLResponse = response as? HTTPURLResponse,
                httpURLResponse.statusCode == 200,
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
        }
    }

    private static func request(endpoint: Endpoint, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        guard let url = URL(string: endpoint.url) else {
            completion(nil, nil, APIError.MalformedURL)
            return
        }

        let session = URLSession.shared
        let urlRequest = URLRequest(url: url)

        let task = session.dataTask(with: urlRequest) { data, response, error in
            completion(data, response, error)
        }

        task.resume()
    }
}
