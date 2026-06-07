//
//  Theme.swift
//  Homey
//
//  Shared design tokens. Prefer these over magic numbers.
//

import CoreGraphics

enum Theme {
    enum Radius {
        static let button: CGFloat = 12
        static let control: CGFloat = 14
        static let card: CGFloat = 18
    }

    enum Spacing {
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
    }
}
