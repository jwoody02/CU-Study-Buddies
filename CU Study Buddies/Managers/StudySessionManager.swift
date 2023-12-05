//
//  StudySessionManager.swift
//  CU Study Buddies
//
//  Created by Jordan Wood on 12/5/23.
//

import Foundation
import UIKit
class StudySessionManager {

    // Singleton instance for global access (if needed)
    static let shared = StudySessionManager()

    func fetchStudySessions(completion: @escaping ([StudySession]) -> Void) {
        // Here you would normally make an API call to fetch the data.
        // For now, returning mock data.

        let mockData = createMockStudySessions()
        completion(mockData)
    }

    private func createMockStudySessions() -> [StudySession] {
        // Example test data
            let organizerAlice = Organizer(id: "org1", name: "Alice", contactInfo: "alice@example.com")
            let organizerBob = Organizer(id: "org2", name: "Bob", contactInfo: "bob@example.com")
            let organizerEve = Organizer(id: "org3", name: "Eve", contactInfo: "eve@example.com")
            
            let attendeesGroup1 = [
                Attendee(id: "att1", name: "Charlie"),
                Attendee(id: "att2", name: "Dave")
            ]
            
            let attendeesGroup2 = [
                Attendee(id: "att3", name: "Emma"),
                Attendee(id: "att4", name: "Frank")
            ]
            
            let attendeesGroup3 = [
                Attendee(id: "att5", name: "Grace"),
                Attendee(id: "att6", name: "Henry")
            ]

            let session1 = StudySession(
                id: "ss1",
                title: "Calculus Study Group",
                organizer: organizerAlice,
                bodyContent: "Looking for a few people to study for upcoming calc exam",
                classInfo: "MATH101",
                attendees: attendeesGroup1,
                meetupType: .zoom(link: "https://zoom.us/j/123456789")
            )

            let session2 = StudySession(
                id: "ss2",
                title: "Physics Study Group",
                organizer: organizerAlice,
                bodyContent: "Looking to study the stuff covered last week in lecture",
                classInfo: "PHYS201",
                attendees: attendeesGroup1,
                meetupType: .inPerson(location: "Library Meeting Room 5")
            )
            
            let session3 = StudySession(
                id: "ss3",
                title: "Chemistry Review Session",
                organizer: organizerBob,
                bodyContent: "Group study for upcoming Chemistry midterm",
                classInfo: "CHEM101",
                attendees: attendeesGroup2,
                meetupType: .zoom(link: "https://zoom.us/j/987654321")
            )
            
            let session4 = StudySession(
                id: "ss4",
                title: "Computer Science Algorithms",
                organizer: organizerEve,
                bodyContent: "Discussion on algorithms covered in recent classes",
                classInfo: "CS301",
                attendees: attendeesGroup3,
                meetupType: .inPerson(location: "Comp Sci Building Room 104")
            )
        let TAOrganizer = Organizer(id: "ajz", name: "John", type: .TA, contactInfo: "exampleTA@gmail.com")
              let TASession1 = StudySession(
                  id: "tass1",
                  title: "Calculus Study Session",
                  organizer: TAOrganizer,
                  bodyContent: "TA organized study session for upcoming exam #1.",
                  classInfo: "MATH101",
                  attendees: attendeesGroup3,
                  meetupType: .inPerson(location: "ECCN 1B50")
              )
              
              let TASession2 = StudySession(
                  id: "tass2",
                  title: "EBIO Study Session",
                  organizer: TAOrganizer,
                  bodyContent: "EBIO Study session hosted by TA",
                  classInfo: "EBIO",
                  attendees: attendeesGroup3,
                  meetupType: .inPerson(location: "ENG 292")
              )
        return [TASession2, TASession1, session1, session2, session3, session4]
    }
    
    // simple hash function to generate a unique color based on the class name
    func colorForClassName(_ className: String) -> UIColor {
        var total: Int = 0
        for u in className.unicodeScalars {
            total += Int(u.value)
        }

        srand48(total)  // Seed the random number generator
        let red = CGFloat(drand48())  // Generate a random number for red
        let green = CGFloat(drand48())  // Generate a random number for green
        let blue = CGFloat(drand48())  // Generate a random number for blue

        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
