//
//  SettingsTVCell2.swift
//  ChatApp
//
//  Created by Aboody on 01/08/2021.
//

import UIKit

class SettingsTVS2C1: UITableViewCell {

    //MARK: - View LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - IBActions
    @IBAction func tellAFreindButtonPressed(_ sender: UIButton) {
        print("Tell a friend")
    }
    
}
