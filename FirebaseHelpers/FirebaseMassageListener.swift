//
//  FirebaseMassageListener.swift
//  ChatApp
//
//  Created by Aboody on 06/08/2021.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class FirebaseMassageListener {
    
    static let shared = FirebaseMassageListener()
    var newChatListener: ListenerRegistration!
    var updatedChatListener: ListenerRegistration!
    
    
    private init() { }
    
    func listenForNewChats(_ documentId: String, collectionId: String, lastMessageDate: Date) {
        
        newChatListener = FirebaseReference(.Messages).document(documentId).collection(collectionId).whereField(kDATE, isGreaterThan: lastMessageDate).addSnapshotListener({ (querySnapshot, error) in
            
            guard let snapshot = querySnapshot else { return }
            
            for change in snapshot.documentChanges {
                
                if change.type == .added {
                    
                    let result = Result {
                        try? change.document.data(as: LocalMessage.self)
                    }
                    
                    switch result {
                    case .success(let messageObject):
                        
                        if let message = messageObject {
                            
                            if message.senderId != User.currentId {
                                RealmManager.shared.saveToRealm(message)
                            }
                        } else {
                            print("Document doesnt exist")
                        }
                        
                    case .failure(let error):
                    print("Error deconding local message: \(error.localizedDescription)")
                    }
                    
                }
            }
        })
    }
    
    func listenForReadStatusChange(_ documentId: String, collectionId: String, completion: @escaping (_ updatedMessage: LocalMessage) -> Void) {
        
        updatedChatListener = FirebaseReference(.Messages).document(documentId).collection(collectionId).addSnapshotListener({ (querySnapshot, error) in
            
            guard let snapshot = querySnapshot else { return }
          
            for change in snapshot.documentChanges {
                
                if change.type == .modified {
                    
                    let result = Result {
                        try? change.document.data(as: LocalMessage.self)
                    }
                    
                    switch result {
                    case .success(let messageObject):
                        
                        if let message = messageObject {
                            completion(message)
                        } else {
                            print("Document does not exist in chat")
                        }
                    case .failure(let error):
                        print("Error decoding local message:", error.localizedDescription)
                    }
                }
            }
        })
    }
    
    func checkForOldChats(_ documentId: String, collectionId: String) {
        
        FirebaseReference(.Messages).document(documentId).collection(collectionId).getDocuments { (querySnapshot, error) in
            
            guard let documents = querySnapshot?.documents else {
                print("no documents for old chats")
                return
            }
            
            var oldMessage = documents.compactMap { (queryDocumentsSnapshot) -> LocalMessage? in
                return try? queryDocumentsSnapshot.data(as: LocalMessage.self)
            }
            
            oldMessage.sort(by: { $0.date < $1.date })
            
            for message in oldMessage {
                RealmManager.shared.saveToRealm(message)
            }
        }
    }
    
    //MARK: - Add, Update, Delete
    func addMessage(_ message: LocalMessage, memberId: String) {
        
        do {
            
            let _ = try FirebaseReference(.Messages).document(memberId).collection(message.chatRoomId).document(message.id).setData(from: message)
            
        } catch {
            print("Error saving message ", error.localizedDescription)
        }
    }
    
    //MARK: - UpdateMessageStatus
    func updateMessageInFirebase(_ message: LocalMessage, memberIds: [String]) {
        
        let values = [kSTATUS: kREAD, kREADDATE: Date()] as [String: Any]
        
        for userId in memberIds {
            FirebaseReference(.Messages).document(userId).collection(message.chatRoomId).document(message.id).updateData(values)
        }
    }
    
    func removeListeners() {
        self.newChatListener.remove()
        self.updatedChatListener.remove()
    }
}
