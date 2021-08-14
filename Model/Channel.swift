//
//  Channel.swift
//  ChatApp
//
//  Created by Aboody on 12/08/2021.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase

struct Channel: Codable {
    
    var id = ""
    var name = ""
    var adminId = ""
    var memberIds = [""]
    var avatarLink = ""
    var aboutChannel = ""
    @ServerTimestamp var createdDate = Date()
    @ServerTimestamp var lastMessageDate = Date()
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case name
        case adminId
        case memberIds
        case avatarLink
        case aboutChannel
        case lastMessageDate = "date"
    }
}
