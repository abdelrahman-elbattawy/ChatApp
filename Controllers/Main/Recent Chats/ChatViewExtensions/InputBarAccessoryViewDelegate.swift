//
//  InputBarAccessoryViewDelegate.swift
//  ChatApp
//
//  Created by Aboody on 06/08/2021.
//

import Foundation
import InputBarAccessoryView

extension ChatRoomVC: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
        
        if text != "" {
            typingIndicatorUpdate()
        }
        
        updateMicButtonStatus(show: text == "")
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {

        for compnent in inputBar.inputTextView.components {

            if let text = compnent as? String {
                messageSend(text: text, photo: nil, video: nil, audio: nil, location: nil)
            }
        }
        
        messageInputBar.inputTextView.text = ""
        messageInputBar.invalidatePlugins()
    }
}
