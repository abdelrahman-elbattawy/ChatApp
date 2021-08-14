//
//  Status.swift
//  ChatApp
//
//  Created by Aboody on 02/08/2021.
//

import Foundation

enum Status: String, CaseIterable {
    
    case Available = "Available"
    case Busy = "Busy"
    case AtSchool = "At School"
    case AtTheMovies = "At The Movies"
    case AtWork = "At Work"
    case BatteryAboutToDie = "Battery About to die"
    case CantTalk = "Can't talk"
    case InAMeeting = "In a Meeting"
    case AtTheGym = "At the gym"
    case Sleeping = "Sleeping"
    case UrgentCallsOnly = "Urgent calls only"
}
