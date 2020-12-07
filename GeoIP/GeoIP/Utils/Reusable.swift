//
//  Reusable.swift
//  GeoIP
//
//  Created by Serhii Borysov on 12/7/20.
//

import Foundation

protocol Reusable {
    static func reuseIdentifier() -> String
    static func nibName() -> String
}

extension Reusable {
    static func reuseIdentifier() -> String {
        return String(describing: self)
    }

    static func nibName() -> String {
        return String(describing: self)
    }
}
