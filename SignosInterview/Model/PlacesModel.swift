/*
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND : String = "". IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation

enum AddressType: String, Codable {
    case Gym
    case Restaurant
    case Supermarket
}

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
    let geometry : Geometry?
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
        case geometry = "geometry"
        case icon = "icon"
        case name = "name"
        case photos = "photos"
        case place_id = "place_id"
        case rating = "rating"
        case reference = "reference"
        case types = "types"
        case addressType = "addressType"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        business_status = try values.decodeIfPresent(String.self, forKey: .business_status)
        formatted_address = try values.decodeIfPresent(String.self, forKey: .formatted_address)
        geometry = try values.decodeIfPresent(Geometry.self, forKey: .geometry)
        icon = try values.decodeIfPresent(String.self, forKey: .icon)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        photos = try values.decodeIfPresent([Photo].self, forKey: .photos)
        place_id = try values.decodeIfPresent(String.self, forKey: .place_id)
        rating = try values.decodeIfPresent(Double.self, forKey: .rating)
        reference = try values.decodeIfPresent(String.self, forKey: .reference)
        types = try values.decodeIfPresent([String].self, forKey: .types)
        addressType = try values.decodeIfPresent(AddressType.self, forKey: .addressType)

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
}

struct Geometry : Codable {
    let location : Location?

    enum CodingKeys: String, CodingKey {
        case location = "location"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        location = try values.decodeIfPresent(Location.self, forKey: .location)
    }

}

struct Location : Codable {
    let lat : Double?
    let lng : Double?

    enum CodingKeys: String, CodingKey {
        case lat = "lat"
        case lng = "lng"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        lat = try values.decodeIfPresent(Double.self, forKey: .lat)
        lng = try values.decodeIfPresent(Double.self, forKey: .lng)
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

struct PlaceDetailResponse : Codable {
    let html_attributions : [String]?
    let result : PlaceDetail?
    let status : String?

    enum CodingKeys: String, CodingKey {

        case html_attributions = "html_attributions"
        case result = "result"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        html_attributions = try values.decodeIfPresent([String].self, forKey: .html_attributions)
        result = try values.decodeIfPresent(PlaceDetail.self, forKey: .result)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }
}

struct PlaceDetail : Codable {
    let adr_address : String?
    let business_status : String?
    let formatted_address : String?
    let formatted_phone_number : String?
    let icon : String?
    let icon_background_color : String?
    let icon_mask_base_uri : String?
    let international_phone_number : String?
    let name : String?
    let place_id : String?
    let rating : Double?
    let reference : String?
    let types : [String]?
    let url : String?
    let user_ratings_total : Int?
    let utc_offset : Int?
    let vicinity : String?
    let website : String?

    enum CodingKeys: String, CodingKey {
        case adr_address = "adr_address"
        case business_status = "business_status"
        case formatted_address = "formatted_address"
        case formatted_phone_number = "formatted_phone_number"
        case icon = "icon"
        case icon_background_color = "icon_background_color"
        case icon_mask_base_uri = "icon_mask_base_uri"
        case international_phone_number = "international_phone_number"
        case name = "name"
        case place_id = "place_id"
        case rating = "rating"
        case reference = "reference"
        case types = "types"
        case url = "url"
        case user_ratings_total = "user_ratings_total"
        case utc_offset = "utc_offset"
        case vicinity = "vicinity"
        case website = "website"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        adr_address = try values.decodeIfPresent(String.self, forKey: .adr_address)
        business_status = try values.decodeIfPresent(String.self, forKey: .business_status)
        formatted_address = try values.decodeIfPresent(String.self, forKey: .formatted_address)
        formatted_phone_number = try values.decodeIfPresent(String.self, forKey: .formatted_phone_number)
        icon = try values.decodeIfPresent(String.self, forKey: .icon)
        icon_background_color = try values.decodeIfPresent(String.self, forKey: .icon_background_color)
        icon_mask_base_uri = try values.decodeIfPresent(String.self, forKey: .icon_mask_base_uri)
        international_phone_number = try values.decodeIfPresent(String.self, forKey: .international_phone_number)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        place_id = try values.decodeIfPresent(String.self, forKey: .place_id)
        rating = try values.decodeIfPresent(Double.self, forKey: .rating)
        reference = try values.decodeIfPresent(String.self, forKey: .reference)
        types = try values.decodeIfPresent([String].self, forKey: .types)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        user_ratings_total = try values.decodeIfPresent(Int.self, forKey: .user_ratings_total)
        utc_offset = try values.decodeIfPresent(Int.self, forKey: .utc_offset)
        vicinity = try values.decodeIfPresent(String.self, forKey: .vicinity)
        website = try values.decodeIfPresent(String.self, forKey: .website)
    }
}
