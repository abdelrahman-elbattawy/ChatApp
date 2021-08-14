//
//  AudioMessage.swift
//  ChatApp
//
//  Created by Aboody on 11/08/2021.
//

import Foundation
import MessageKit

class AudioMessage: NSObject, AudioItem {
    
    var url: URL
    var duration: Float
    var size: CGSize
    
    init(duration: Float) {
        
        self.url = URL(fileURLWithPath: "")
        self.duration = duration
        self.size = CGSize(width: 200, height: 35)
    }
    
    
}
