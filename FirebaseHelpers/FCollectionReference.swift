//
//  FCollectionReference.swift
//  ChatApp
//
//  Created by Aboody on 19/07/2021.
//

import Foundation
import FirebaseFirestore

enum FCollectionReference: String {
    case User
    case Recent
    case Messages
    case Typing
}

func FirebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference {
    return Firestore.firestore().collection(collectionReference.rawValue)
}
