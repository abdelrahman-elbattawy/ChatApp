//
//  ChannelsS1C1.swift
//  ChatApp
//
//  Created by Aboody on 12/08/2021.
//

import UIKit

class ChannelsS1C1: UITableViewCell {

    //MARK: - IBOutlets
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var membersCountLabel: UILabel!
    @IBOutlet weak var lastMessageDateLabel: UILabel!
    
    
    //MARK: - View LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Helpers Functions
    func configure(channel: Channel) {
        
        nameLabel.text = channel.name
        aboutLabel.text = channel.aboutChannel
        membersCountLabel.text = "\(channel.memberIds.count) members"
        
        lastMessageDateLabel.text = timeElapsed(channel.lastMessageDate ?? Date())
        lastMessageDateLabel.adjustsFontSizeToFitWidth = true
        
        
    }
    
    private func setAvatar(avatarLink: String) {
        
        if avatarLink != "" {
            
            FileStorage.downloadImage(imageURL: avatarLink) { (avatarImage) in
                
                DispatchQueue.main.async {
                    self.avatarImageView.image = avatarImage != nil ? avatarImage?.circleMasked : UIImage(named: "avatar")
                }
            }
            
        } else {
            self.avatarImageView.image = UIImage(named: "avatar")
        }
    }
    
}
