//
//  String+Extensions.swift
//  SignosInterview
//
//  Created by John Macy on 8/4/21.
//

import Foundation

extension String {
    var digits: String {
        components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
}
