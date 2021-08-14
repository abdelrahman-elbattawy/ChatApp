//
//  ProfileTVS1C2.swift
//  ChatApp
//
//  Created by Aboody on 01/08/2021.
//

import UIKit

class EditProfileTVS1C2: UITableViewCell {

    //MARK: - IBOutlets
    @IBOutlet weak var usernameTextField: UITextField!
    
    //MARK: - View LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configureTextField()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Helpers Functions
    private func configureTextField() {
        usernameTextField.delegate = self
    }
}

extension EditProfileTVS1C2: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            if textField.text != "" {
                if var user = User.currentUser {
                    user.username = textField.text!
                    saveUserLocally(user)
                    FirebaseUserListener.shared.saveUserToFireStore(user)
                }
            }
            textField.resignFirstResponder()
            return false
        }
        return true
    }
}
