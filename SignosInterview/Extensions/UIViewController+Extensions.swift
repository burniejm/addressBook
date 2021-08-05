//
//  UIViewController+Extensions.swift
//  SignosInterview
//
//  Created by John Macy on 8/4/21.
//

import UIKit

extension UIViewController {

    func showError(_ message: String, completion: (() -> Void)? = nil) {
        let errorAlertView = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        errorAlertView.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(errorAlertView, animated: true, completion: completion)
    }
}
