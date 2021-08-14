//
//  OutgoingMessage.swift
//  ChatApp
//
//  Created by Aboody on 06/08/2021.
//

import Foundation
import UIKit
import FirebaseFirestoreSwift
import Gallery

class OutgoingMessage {
    
    class func send(chatId: String, text: String?, photo: UIImage?, video: Video?, audio: String?, audioDuration: Float = 0.0, location: String?, memberIds: [String]) {
        
        let currentUser = User.currentUser!
        
        let message = LocalMessage()
        message.id = UUID().uuidString
        message.chatRoomId = chatId
        message.senderId = currentUser.id
        message.senderName = currentUser.username
        message.senderInitials = String(currentUser.username.first!)
        message.date = Date()
        message.status = kSENT
        
        if text != nil {
            sendTextMessage(message: message, text: text!, memberIds: memberIds)
        }
        
        if photo != nil {
            sendPhotoMessage(message: message, photo: photo!, memberIds: memberIds)
        }
        
        if video != nil {
            sendVideoMessage(message: message, video: video!, memberIds: memberIds)
        }
        
        if location != nil {
            sendLocationMessage(message: message, memberIds: memberIds)
        }
        
        if audio != nil {
            sendAudioMessage(message: message, audioFileName: audio!, audioDuration: audioDuration, memberIds: memberIds)
        }
        
        //TODO: Send push notification
        FirebaseRecentListener.shared.updateRecents(chatRoomId: chatId, lastMessage: message.message)
    }
    
    class func sendMessage(message: LocalMessage, memberIds: [String]) {
        
        RealmManager.shared.saveToRealm(message)
        
        for memberId in memberIds {
            FirebaseMassageListener.shared.addMessage(message, memberId: memberId)
        }
    }
}

func sendTextMessage(message: LocalMessage, text: String, memberIds: [String]) {
    
    message.message = text
    message.type = kTEXT
    OutgoingMessage.sendMessage(message: message, memberIds: memberIds)
}

func sendPhotoMessage(message: LocalMessage, photo: UIImage, memberIds: [String]) {
    
    message.message = "[Picture Message]"
    message.type = kPHOTO
    
    let fileName = Date().stringDate()
    let fileDirectory = "MediaMessages/Photos/" + "\(message.chatRoomId)/" + "_\(fileName)" + ".jpg"
    
    FileStorage.saveFileLocally(fileData: photo.jpegData(compressionQuality: 0.6)! as NSData, fileName: fileName)
    
    FileStorage.uploadImage(photo, directory: fileDirectory) { (imageURL) in
        
        if imageURL != nil {
            message.pictureURL = imageURL!
            OutgoingMessage.sendMessage(message: message, memberIds: memberIds)
        }
    }
}

func sendVideoMessage(message: LocalMessage, video: Video, memberIds: [String]) {
    
    message.message = "[Video Message]"
    message.type = kVIDEO
    
    let fileName = Date().stringDate()
    let thumbnailDirectory = "MediaMessages/Photos/" + "\(message.chatRoomId)/" + "_\(fileName)" + ".jpg"
    let videoDirectory = "MediaMessages/Videos/" + "\(message.chatRoomId)/" + "_\(fileName)" + ".mov"
    
    let editor = VideoEditor()
    editor.process(video: video) { (precessedVideo, videoURL) in
        
        if let tempPath = videoURL {
            
            let thumbnail = vidoeThumbnail(video: tempPath)
            
            FileStorage.saveFileLocally(fileData: thumbnail.jpegData(compressionQuality: 0.7)! as NSData, fileName: fileName)
            
            FileStorage.uploadImage(thumbnail, directory: thumbnailDirectory) { (imageURL) in
                
                if imageURL != nil {
                    
                    let videoData = NSData(contentsOfFile: tempPath.path)
                    
                    FileStorage.saveFileLocally(fileData: videoData!, fileName: fileName + ".mov")
                    FileStorage.uploadVideo(videoData!, directory: videoDirectory) { (videoURL) in
                        
                        message.pictureURL = imageURL ?? ""
                        message.videoURL = videoURL ?? ""
                        
                        OutgoingMessage.sendMessage(message: message, memberIds: memberIds)
                    }
                }
            }
        }
    }
}

func sendLocationMessage(message: LocalMessage, memberIds: [String]) {
    
    let currentLocation = LocationManager.shared.currentLocation
    
    message.message = "[Location Message]"
    message.type = kLOCATION
    message.latitude = currentLocation?.latitude ?? 0
    message.longitude = currentLocation?.longitude ?? 0
    
    OutgoingMessage.sendMessage(message: message, memberIds: memberIds)
}
  
func sendAudioMessage(message: LocalMessage, audioFileName: String, audioDuration: Float, memberIds: [String]) {

    message.message = "[Audio Message]"
    message.type = kAUDIO
    
    let fileDirectory = "MediaMessages/Audio/" + "\(message.chatRoomId)/" + "_\(audioFileName)" + ".m4a"
    
    FileStorage.uploadAudio(audioFileName, directory: fileDirectory) { (audioURL) in
        
        if audioURL != nil {
            
            message.audioURL = audioURL ?? ""
            message.audioDuratio = Double(audioDuration)

            OutgoingMessage.sendMessage(message: message, memberIds: memberIds)
        }
    }

}
