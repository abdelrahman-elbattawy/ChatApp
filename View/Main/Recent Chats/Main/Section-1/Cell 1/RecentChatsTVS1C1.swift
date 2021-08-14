//
//  ChatsTVS1C1.swift
//  ChatApp
//
//  Created by Aboody on 04/08/2021.
//

import UIKit

class RecentChatsTVS1C1: UITableViewCell {

    //MARK: - IBOutlets
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    @IBOutlet weak var unreadCounterLabel: UILabel!
    @IBOutlet weak var unreadCounterBackgroundView: UIView! {
        didSet {
            unreadCounterBackgroundView.layer.cornerRadius = unreadCounterBackgroundView.frame.width / 2
        }
    }
    
    //MARK: - View LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: Helper Functions
    func configure(recent: RecentChat) {
        
        usernameLabel.text = recent.receiverName
        usernameLabel.adjustsFontSizeToFitWidth = true
        usernameLabel.minimumScaleFactor = 0.9
        
        lastMessageLabel.text = recent.lastMessage
        lastMessageLabel.adjustsFontSizeToFitWidth = true
        lastMessageLabel.numberOfLines = 2
        lastMessageLabel.minimumScaleFactor = 0.9
        
        if recent.unreadCounter != 0 {
            self.unreadCounterLabel.text = "\(recent.unreadCounter)"
            self.unreadCounterBackgroundView.isHidden = false
        } else {
            self.unreadCounterBackgroundView.isHidden = true
        }
        
        setAvatar(avatarLink: recent.avatarLink)
        
        dateLabel.text = timeElapsed(recent.date ?? Date())
        dateLabel.adjustsFontSizeToFitWidth = true
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
