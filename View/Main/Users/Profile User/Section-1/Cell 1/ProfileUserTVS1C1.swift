//
//  ProfileUserTVCS1C1.swift
//  ChatApp
//
//  Created by Aboody on 03/08/2021.
//

import UIKit

class ProfileUserTVS1C1: UITableViewCell {

    //MARK: - IBOutlets
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    //MARK: - View LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
