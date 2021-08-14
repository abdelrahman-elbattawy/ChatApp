//
//  LocalMessage.swift
//  ChatApp
//
//  Created by Aboody on 06/08/2021.
//

import Foundation
import RealmSwift

class LocalMessage: Object, Codable {
    
    @objc dynamic var id = ""
    @objc dynamic var chatRoomId = ""
    @objc dynamic var date = Date()
    @objc dynamic var senderName = ""
    @objc dynamic var senderId = ""
    @objc dynamic var senderInitials = ""
    @objc dynamic var readDate = Date()
    @objc dynamic var type = ""
    @objc dynamic var status = ""
    @objc dynamic var message = ""
    @objc dynamic var audioURL = ""
    @objc dynamic var videoURL = ""
    @objc dynamic var pictureURL = ""
    @objc dynamic var latitude = 0.0
    @objc dynamic var longitude = 0.0
    @objc dynamic var audioDuratio = 0.0
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
