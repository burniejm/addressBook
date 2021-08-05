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

    var onAddButtonPressed: ((PlaceViewModel) -> Void)?
    var onCallUnsupported: (() -> Void)?

    private var placeVM: PlaceViewModel?

    @IBAction private func btnAddPressed(_ sender: Any) {
        guard let placeVM = placeVM else {
            return
        }
        onAddButtonPressed?(placeVM)
    }

    override func prepareForReuse() {
        placeVM = nil
        onAddButtonPressed = nil
        onCallUnsupported = nil
        isExpanded = false
        lblAddress.text = ""
        lblName.text = ""
        lblType.text = ""
        btnPhone.isHidden = true
        btnPhone.setTitle(nil, for: .normal)
        btnPhone.removeTarget(self, action: #selector(callPhone), for: .touchUpInside)
    }

    func configure(placeVM: PlaceViewModel, showAddButton: Bool, isExpanded: Bool) {
        self.placeVM = placeVM
        self.isExpanded = isExpanded
        selectionStyle = .none

        btnAdd.isHidden = !showAddButton
        btnPhone.isHidden = true

        lblAddress.text = placeVM.address()
        lblName.text = placeVM.name()
        lblType.text = placeVM.addressType()?.rawValue

        placeVM.onPlaceDetailLoaded = { [weak self] in
            if let phoneNum = placeVM.placeDetail?.formatted_phone_number {
                DispatchQueue.main.async {
                    self?.btnPhone.setTitle(phoneNum, for: .normal)
                    self?.btnPhone.isHidden = false
                    self?.btnPhone.addTarget(self, action: #selector(self?.callPhone), for: .touchUpInside)
                }
            }
        }

        placeVM.onPlaceImageLoaded = { [weak self] in
            DispatchQueue.main.async {
                self?.imgPlace.image = placeVM.placeImage
            }
        }
    }

    private func updateForExpansion() {
        lblAddress.numberOfLines = isExpanded ? 2 : 1
        containerDetails.isHidden = !isExpanded

        if isExpanded {
            placeVM?.loadDetail()
            placeVM?.getPlacePhoto()
        }
    }

    @objc private func callPhone() {
        guard let phoneNum = placeVM?.phoneNumber() else { return }

        if let url = URL(string: "tel://\(phoneNum)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                onCallUnsupported?()
            }
        }
    }
}
