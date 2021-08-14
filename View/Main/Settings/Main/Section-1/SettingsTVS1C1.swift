//
//  SettingsTVCell1.swift
//  ChatApp
//
//  Created by Aboody on 01/08/2021.
//

import UIKit

class SettingsTVS1C1: UITableViewCell {

    //MARK: - IBOutlets
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    //MARK: - View LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
