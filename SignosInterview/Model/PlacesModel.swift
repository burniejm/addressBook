/*
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND : String = "". IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation

struct PlacesResponse: Codable {
    let html_attributions : [String]?
    let next_page_token : String?
    let results : [Place]?
    let status : String?

    enum CodingKeys: String, CodingKey {
        case html_attributions = "html_attributions"
        case next_page_token = "next_page_token"
        case results = "results"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        html_attributions = try values.decodeIfPresent([String].self, forKey: .html_attributions)
        next_page_token = try values.decodeIfPresent(String.self, forKey: .next_page_token)
        results = try values.decodeIfPresent([Place].self, forKey: .results)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }
}

struct Place : Codable, Equatable {
    static func == (lhs: Place, rhs: Place) -> Bool {
        return lhs.place_id == rhs.place_id
    }

    let business_status : String?
    let formatted_address : String?
    let icon : String?
    let name : String?
    let photos : [Photo]?
    let place_id : String?
    let rating : Double?
    let reference : String?
    let types : [String]?

    var addressType: AddressType?

    enum CodingKeys: String, CodingKey {
        case business_status = "business_status"
        case formatted_address = "formatted_address"
        case icon = "icon"
        case name = "name"
        case photos = "photos"
        case place_id = "place_id"
        case rating = "rating"
        case reference = "reference"
        case types = "types"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        business_status = try values.decodeIfPresent(String.self, forKey: .business_status)
        formatted_address = try values.decodeIfPresent(String.self, forKey: .formatted_address)
        icon = try values.decodeIfPresent(String.self, forKey: .icon)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        photos = try values.decodeIfPresent([Photo].self, forKey: .photos)
        place_id = try values.decodeIfPresent(String.self, forKey: .place_id)
        rating = try values.decodeIfPresent(Double.self, forKey: .rating)
        reference = try values.decodeIfPresent(String.self, forKey: .reference)
        types = try values.decodeIfPresent([String].self, forKey: .types)

        //Map their types to mine
        guard let types = types else {
            return
        }

        if types.contains("gym") {
            addressType = .Gym
            return
        }

        if types.contains("restaurant") {
            addressType = .Restaurant
            return
        }

        if types.contains("supermarket") {
            addressType = .Supermarket
            return
        }
    }

    init(businessStatus: String = "", formattedAddress: String = "", icon: String = "", name: String = "", placeId: String = "", reference: String = "", rating: Double = 0, addressType: AddressType) {
        self.business_status = businessStatus
        self.formatted_address = formattedAddress
        self.icon = icon
        self.name = name
        self.photos = nil
        self.place_id = placeId
        self.reference = reference
        self.rating = rating
        self.types = nil
        self.addressType = addressType
    }
}

struct Photo : Codable {
    let height : Int?
    let html_attributions : [String]?
    let photo_reference : String?
    let width : Int?

    enum CodingKeys: String, CodingKey {
        case height = "height"
        case html_attributions = "html_attributions"
        case photo_reference = "photo_reference"
        case width = "width"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        height = try values.decodeIfPresent(Int.self, forKey: .height)
        html_attributions = try values.decodeIfPresent([String].self, forKey: .html_attributions)
        photo_reference = try values.decodeIfPresent(String.self, forKey: .photo_reference)
        width = try values.decodeIfPresent(Int.self, forKey: .width)
    }
}
