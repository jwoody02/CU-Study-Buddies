//
//  FontSizeManager.swift
//  CU Study Buddies
//
//  Created by Jordan Wood on 12/5/23.
//

import Foundation
import UIKit

class FontSizeManager {
    // Define content types for which you want to manage font sizes
    enum ContentType {
        case title
        case body
        case caption
    }

    static func fontSize(for contentType: ContentType) -> CGFloat {
        // Adjust these values according to your design
        switch contentType {
        case .title:
            return dynamicFontSize(baseSize: 17)
        case .body:
            return dynamicFontSize(baseSize: 15)
        case .caption:
            return dynamicFontSize(baseSize: 12)
        }
    }

    private static func dynamicFontSize(baseSize: CGFloat) -> CGFloat {
        // scale your font size relative to the screen size
        let screenSize = UIScreen.main.bounds.size
        let scalingFactor = min(screenSize.width, screenSize.height) / 420 // 375 is the width of a standard iPhone 7/8

        return baseSize * scalingFactor
    }
}
