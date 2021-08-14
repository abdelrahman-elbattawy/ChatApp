//
//  FirebaseRecentListener.swift
//  ChatApp
//
//  Created by Aboody on 05/08/2021.
//

import Foundation
import Firebase

class FirebaseRecentListener {
    
    static let shared = FirebaseRecentListener()
    
    private init() {}
    
    func downloadRecentChatsFromFireStore(completion: @escaping (_ allRecent: [RecentChat]) -> Void) {
        
        FirebaseReference(.Recent).whereField(kSENDERID, isEqualTo: User.currentId).addSnapshotListener { (querySnapshot, error) in
            
            var recentChats: [RecentChat] = []
            
            guard let documents = querySnapshot?.documents else { return }
            
            let allRecents = documents.compactMap { (querySnapshot) -> RecentChat? in
                
                return try? querySnapshot.data(as: RecentChat.self)
            }
            
            for recent in allRecents {
                
                if recent.lastMessage != "" {
                 
                    recentChats.append(recent)
                }
            }
            
            recentChats.sort(by: { $0.date! > $1.date! })
            completion(recentChats)
            
        }
    }
    
    func resetRecentCounter(chatRoomId: String) {
        
        FirebaseReference(.Recent).whereField(kCHATROOMID, isEqualTo: chatRoomId).whereField(kSENDERID, isEqualTo: User.currentId).getDocuments { (querySnapshot, error) in
            
            guard let documents = querySnapshot?.documents else { return }
            
            let allRecents = documents.compactMap { (queryDocumentsSnapshot) -> RecentChat? in
                
                return try? queryDocumentsSnapshot.data(as: RecentChat.self)
            }
            
            if allRecents.count > 0 {
                self.clearUnreadCounter(allRecents.first!)
            }
        }
    }
    
    func updateRecents(chatRoomId: String, lastMessage: String) {
        
        FirebaseReference(.Recent).whereField(kCHATROOMID, isEqualTo: chatRoomId).getDocuments { (querySnapshot, error) in
            
            guard let documents = querySnapshot?.documents else {
                print("no documentfor recent update")
                return
            }
            
            let allRecents = documents.compactMap { (queryDocumentSnapshot) -> RecentChat? in
                return try? queryDocumentSnapshot.data(as: RecentChat.self)
            }
            
            for recentChat in allRecents {
                self.updateRecentItemWithNewMessage(recent: recentChat, lastMessage: lastMessage)
            }
        }
    }
    
    private func updateRecentItemWithNewMessage(recent: RecentChat, lastMessage: String) {
        
        var tempRecent = recent
        
        if tempRecent.senderId != User.currentId {
            tempRecent.unreadCounter += 1
        }
        
        tempRecent.lastMessage = lastMessage
        tempRecent.date = Date()
                
        self.saveRecent(tempRecent)
    }
    
    func clearUnreadCounter(_ recent: RecentChat) {
        
        var newRecent = recent
        newRecent.unreadCounter = 0
        self.saveRecent(newRecent)
    }
    
    func saveRecent(_ recent: RecentChat) {
        
        do {
            try FirebaseReference(.Recent).document(recent.id).setData(from: recent)

        } catch {
            print("Error saving recent chat", error.localizedDescription)
        }
    }
    
    func deleteRecent(_ recent: RecentChat) {
        FirebaseReference(.Recent).document(recent.id).delete()
    }
}
