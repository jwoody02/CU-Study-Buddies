//
//  StudySession.swift
//  CU Study Buddies
//
//  Created by Jordan Wood on 12/5/23.
//

import Foundation
struct StudySession {
    var id: String
    var title: String
    var organizer: Organizer
    var bodyContent: String
    var classInfo: String
    var attendees: [Attendee]
    var meetupType: MeetupType
}
