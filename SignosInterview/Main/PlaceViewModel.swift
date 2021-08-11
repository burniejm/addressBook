//
//  PlaceViewModel.swift
//  SignosInterview
//
//  Created by John Macy on 8/5/21.
//

import Foundation
import UIKit

class PlaceViewModel {

    private(set) var place: Place!
    var placeDetail: PlaceDetail? {
        didSet {
            onPlaceDetailLoaded?()
        }
    }

    var placeImage: UIImage? {
        didSet {
            onPlaceImageLoaded?()
        }
    }

    var onPlaceDetailLoaded: (() -> Void)?
    var onPlaceImageLoaded: (() -> Void)?

    init(place: Place) {
        self.place = place
    }

    func address() -> String? {
        return place.formatted_address
    }

    func name() -> String? {
        return place.name
    }

    func addressType() -> AddressType? {
        return place.addressType
    }

    func phoneNumber() -> String? {
        guard let placeDetail = placeDetail,
              let phoneNum = placeDetail.formatted_phone_number else {
            return nil
        }

        return phoneNum.digits
    }

    func loadDetail() {
        if placeDetail != nil {
            //already loaded info
            onPlaceDetailLoaded?()
            return
        }

        if let placeId = place?.place_id {
            PlacesService.getDetails(placeId: placeId) { [weak self] response in
                self?.placeDetail = response?.result
            }
        }
    }

    func getPlacePhoto() {
        if placeImage != nil {
            //already loaded photo
            onPlaceImageLoaded?()
            return
        }

        let noImage = UIImage.init(named: "no_image")

        if let photoRef = place.photos?.first?.photo_reference {
            PlacesService.getPhoto(reference: photoRef, maxHeight: 180, maxWidth: 180) { img in
                DispatchQueue.main.async { [weak self] in
                    guard let img = img else {
                        self?.placeImage = noImage
                        return
                    }
                    self?.placeImage = img
                }
            }
            return
        }

        if let address = place.formatted_address, let lat = place.geometry?.location?.lat, let lng = place.geometry?.location?.lng {
            PlacesService.getMapPhoto(address: address, lat: lat, long: lng, width: 180, height: 180) { img in
                DispatchQueue.main.async { [weak self] in
                    guard let img = img else {
                        self?.placeImage = noImage
                        return
                    }
                    self?.placeImage = img
                }
            }
            return
        }

        placeImage = noImage
    }

    func setAddressLabelText(_ label: UILabel) {
        guard let address = address() else {
            label.text = ""
            return
        }

        guard place.isPinned else {
            label.text = address
            return
        }

        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "pin")
        let imageOffsetY: CGFloat = -5.0
        imageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: imageAttachment.image!.size.width, height: imageAttachment.image!.size.height)
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        let completeText = NSMutableAttributedString(string: "")
        completeText.append(attachmentString)
        let textAfterIcon = NSAttributedString(string: address)
        completeText.append(textAfterIcon)
        label.attributedText = completeText
    }
}
