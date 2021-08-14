//
//  UsersS1C1.swift
//  ChatApp
//
//  Created by Aboody on 03/08/2021.
//

import UIKit

class UsersS1C1: UITableViewCell {

    //MARK: - IBOutlets
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    //MARK: - View LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Helpers Functions
    func configure(user: User) {
        userNameLabel.text = user.username
        statusLabel.text = user.status
        setAvatar(avatarLink: user.avatarLink)
    }
    
    private func setAvatar(avatarLink: String) {
        
        if avatarLink != "" {
            FileStorage.downloadImage(imageURL: avatarLink) { (avatarImage) in
                self.avatarImageView.image = avatarImage?.circleMasked
            }
        } else {
            self.avatarImageView.image = UIImage(named: "avatar")
        }
    }
}
