//
//  Comfortaa.swift
//  HUF
//
//  Created by Jordan Wood on 11/18/23.
//

import Foundation
import UIKit

enum ComfortaaFont: String {
    case regular = "Comfortaa-Regular"
    case light = "Comfortaa-Light"
    case medium = "Comfortaa-Medium"
    case semiBold = "Comfortaa-SemiBold"
    case bold = "Comfortaa-Bold"

    func font(size: CGFloat) -> UIFont? {
        return UIFont(name: self.rawValue, size: size)
    }
}
