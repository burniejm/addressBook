//
//  PlaceTableViewCell.swift
//  SignosInterview
//
//  Created by John Macy on 8/4/21.
//

import UIKit

class PlaceTableViewCell: UITableViewCell {

    static let reuseIdentifier = "PlaceTableViewCell"

    @IBOutlet private weak var lblAddress: UILabel!
    @IBOutlet private weak var containerDetails: UIView!
    @IBOutlet private weak var lblName: UILabel!
    @IBOutlet private weak var lblType: UILabel!
    @IBOutlet private weak var btnAdd: UIButton!
    @IBOutlet private weak var btnPhone: UIButton!
    @IBOutlet private weak var imgPlace: UIImageView!

    var isExpanded: Bool = false {
        didSet {
            updateForExpansion()
        }
    }

    var onAddButtonPressed: ((Place) -> Void)?
    var onCallUnsupported: (() -> Void)?

    private var place: Place?
    private var placeDetail: PlaceDetail?

    @IBAction private func btnAddPressed(_ sender: Any) {
        guard let place = place else {
            return
        }
        onAddButtonPressed?(place)
    }

    override func prepareForReuse() {
        place = nil
        placeDetail = nil
        onAddButtonPressed = nil
        onCallUnsupported = nil
        isExpanded = false
        lblAddress.text = ""
        lblName.text = ""
        lblType.text = ""
        imgPlace.image = nil
        btnPhone.isHidden = true
        btnPhone.setTitle(nil, for: .normal)
    }

    func configure(place: Place, showAddButton: Bool, isExpanded: Bool) {
        self.place = place
        self.isExpanded = isExpanded
        selectionStyle = .none

        btnAdd.isHidden = !showAddButton
        self.btnPhone.isHidden = true

        lblAddress.text = place.formatted_address
        lblName.text = place.name
        lblType.text = place.addressType?.rawValue
    }

    private func updateForExpansion() {
        lblAddress.numberOfLines = isExpanded ? 2 : 1
        containerDetails.isHidden = !isExpanded

        if isExpanded {
            loadDetail()
            loadPhoto()
        }
    }

    private func loadDetail() {
        if placeDetail != nil {
            //already loaded info
            return
        }

        if let placeId = self.place?.place_id {
            PlacesService.getDetails(placeId: placeId) { [weak self] response in
                self?.placeDetail = response?.result

                DispatchQueue.main.async {
                    if let phoneNum = response?.result?.formatted_phone_number {
                        self?.btnPhone.setTitle(phoneNum, for: .normal)
                        self?.btnPhone.isHidden = false
                        self?.btnPhone.addTarget(self, action: #selector(self?.callPhone), for: .touchUpInside)
                    }
                }
            }
        }
    }

    @objc private func callPhone() {
        guard let placeDetail = placeDetail,
              let phoneNum = placeDetail.formatted_phone_number else {
            return
        }

        if let url = URL(string: "tel://\(phoneNum.digits)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                onCallUnsupported?()
            }
        }
    }

    private func loadPhoto() {
        if let photoRef = self.place?.photos?.first?.photo_reference {
            PlacesService.getPhoto(reference: photoRef, maxHeight: 180, maxWidth: 180) { [weak self] img in
                DispatchQueue.main.async {
                    guard let img = img else {
                        self?.imgPlace.image = UIImage.init(named: "no_image")
                        return
                    }

                    self?.imgPlace.image = img
                }
            }
            return
        }

        if let address = self.place?.formatted_address, let lat = self.place?.geometry?.location?.lat, let lng = self.place?.geometry?.location?.lng {
            PlacesService.getMapPhoto(address: address, lat: lat, long: lng, width: 180, height: 180) { [weak self] img in
                DispatchQueue.main.async {
                    guard let img = img else {
                        self?.imgPlace.image = UIImage.init(named: "no_image")
                        return
                    }

                    self?.imgPlace.image = img
                }
            }
            return
        }

        self.imgPlace.image = UIImage.init(named: "no_image")
    }
}
