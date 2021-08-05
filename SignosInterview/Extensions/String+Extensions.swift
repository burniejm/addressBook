//
//  String+Extensions.swift
//  SignosInterview
//
//  Created by John Macy on 8/4/21.
//

import Foundation

extension String {
    //https://stackoverflow.com/questions/29971505/filter-non-digits-from-string
    var digits: String {
        components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
}
