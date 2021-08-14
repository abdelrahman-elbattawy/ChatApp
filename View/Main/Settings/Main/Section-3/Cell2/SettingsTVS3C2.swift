//
//  SettingsTVS3C2.swift
//  ChatApp
//
//  Created by Aboody on 01/08/2021.
//

import UIKit

class SettingsTVS3C2: UITableViewCell {
    
    //MARK: - View LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - IBActions
    @IBAction func logoutButtonPreesed(_ sender: UIButton) {
        FirebaseUserListener.shared.logOutCurrentUser { (error) in
            if error == nil {
                let loginView = LoginVC()
                
                DispatchQueue.main.async {
                    loginView.modalPresentationStyle = .fullScreen
                    self.window?.rootViewController?.present(loginView, animated: true, completion: nil)
                }
            }
        }
    }
}
