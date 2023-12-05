//
//  Organizer.swift
//  CU Study Buddies
//
//  Created by Jordan Wood on 12/5/23.
//

import Foundation
struct Organizer {
    var id: String
    var name: String
    var type: OrganizerType = .Student
    var contactInfo: String // This could be an email, phone number, etc. (maybe make a new enum + struct for this)
}

enum OrganizerType: Int {
    case TA = 0
    case Student = 1
}
