//
//  IncomingMessage.swift
//  ChatApp
//
//  Created by Aboody on 06/08/2021.
//

import Foundation
import MessageKit
import CoreLocation

class IncomingMessage {
    
    var messageCollectionView: MessagesViewController
    
    init(_collectionView: MessagesViewController) {
        messageCollectionView = _collectionView
    }
    
    //MARK: - CreateMessage
    func createMessage(localMessage: LocalMessage) -> MKMessage? {
        
        let mkMessage = MKMessage(message: localMessage)
        
        if localMessage.type == kPHOTO {
            
            let photoItem = PhotoMessage(path: localMessage.pictureURL)
            mkMessage.photoItem = photoItem
            mkMessage.kind = MessageKind.photo(photoItem)
            
            FileStorage.downloadImage(imageURL: localMessage.pictureURL) { (image) in
                mkMessage.photoItem?.image = image
                self.messageCollectionView.messagesCollectionView.reloadData()
            }
        }
        
        if localMessage.type == kVIDEO {
            
            FileStorage.downloadImage(imageURL: localMessage.pictureURL) { (tumbNail) in
                
                FileStorage.downloadVideo(videoLink: localMessage.videoURL) { (readyToPlay, fileName) in
                    
                    let videoURL = URL(fileURLWithPath: fileInDocumentsDirectory(fileName: fileName))
                    
                    let videoItem = VideoMessage(url: videoURL)
                    mkMessage.videoItem = videoItem
                    mkMessage.kind = MessageKind.video(videoItem)
                }
                mkMessage.videoItem?.image = tumbNail
                self.messageCollectionView.messagesCollectionView.reloadData()
            }
        }
        
        if localMessage.type == kLOCATION {
            
            let locationItem = LocationMessage(location: CLLocation(latitude: localMessage.latitude, longitude: localMessage.longitude))
            
            mkMessage.kind = MessageKind.location(locationItem)
            mkMessage.locationItem = locationItem
        }
        
        if localMessage.type == kAUDIO {
            
            let audioItem = AudioMessage(duration: Float(localMessage.audioDuratio))
            mkMessage.kind = MessageKind.audio(audioItem)
            mkMessage.audioItem = audioItem
            
            FileStorage.downloadAudio(audioLink: localMessage.audioURL) { (fileName) in
                
                let audioURL = URL(fileURLWithPath: fileInDocumentsDirectory(fileName: fileName))
                
                mkMessage.audioItem?.url = audioURL
            }
            self.messageCollectionView.messagesCollectionView.reloadData()
        }
        
        return mkMessage
    }
    
}
