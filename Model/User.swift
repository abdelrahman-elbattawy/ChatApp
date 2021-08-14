//
//  User.swift
//  ChatApp
//
//  Created by Aboody on 19/07/2021.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct User: Codable, Equatable {
    
    var id = ""
    var username: String
    var email: String
    var pushId = ""
    var avatarLink = ""
    var status: String
    
    static var currentId: String {
        return Auth.auth().currentUser!.uid
    }
    
    static var currentUser: User? {
        if Auth.auth().currentUser != nil {
            if let dictionary = userDefaults.data(forKey: kCURRENTUSER) {
                let decoder = JSONDecoder()
                
                do {
                    let userObject = try decoder.decode(User.self, from: dictionary)
                    return userObject
                } catch {
                    print("Error decoding user form user defaults", error.localizedDescription)
                }
            }
        }
        
        return nil
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
}

func saveUserLocally(_ user: User) {
    
    let encoder = JSONEncoder()
    
    do {
        let data = try encoder.encode(user)
        UserDefaults.standard.set(data, forKey: kCURRENTUSER)
    } catch {
        print("Error saving user locally", error.localizedDescription)
    }
}

//func createDummyUsers() {
//    
//    let names = ["Alison Stamp", "Inayah Duggan", "Alfie Thornton", "Rachelle Neale", "Anya Gates", "Juanita Bate"]
//    
//    var imageIndex = 1
//    var userIndex = 1
//    
//    for i in 0 ..< 5 {
//        let id = UUID().uuidString
//        let fileDirectory = "Avatars/" + "_\(id)" + ".jpeg"
//        
//        FileStorage.uploadImage(UIImage(named: "user\(imageIndex)")!, directory: fileDirectory) { (avatarLink) in
//            let user = User(id: id, username: names[i], email: "user\(userIndex)@gmail.com", pushId: "", avatarLink: avatarLink!, status: "No Status")
//            userIndex += 1
//            FirebaseUserListener.shared.saveUserToFireStore(user)
//        }
//        imageIndex += 1
//        if imageIndex == 5 {
//            imageIndex = 1
//        }
//    }
//    
//}
