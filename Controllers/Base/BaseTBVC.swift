//
//  BaseTBVC.swift
//  ChatApp
//
//  Created by Aboody on 19/07/2021.
//

import UIKit

class BaseTBVC: UITabBarController {

    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewControllers()
    }
    
    //MARK: - Setup
    private func setupViewControllers() {
        
        // Chats layout
        let recentChatsVC = RecentChatsTVC()
        
        let recentChatNavVC = BaseNavVC(rootViewController: recentChatsVC)
        recentChatNavVC.title = "Chats"
        recentChatNavVC.tabBarItem.image = UIImage(systemName: "message")
        
        // Channels layout
        let channelsVC = ChannelsTVC()
        
        let channelNavVC = BaseNavVC(rootViewController: channelsVC)
        channelNavVC.title = "Channels"
        channelNavVC.tabBarItem.image = UIImage(systemName: "quote.bubble")
        
        // Users layout
        let usersTVC = UsersTVC()
        
        let usersNavVC = BaseNavVC(rootViewController: usersTVC)
        usersNavVC.title = "Users"
        usersNavVC.tabBarItem.image = UIImage(systemName: "person.2")
        
        // Settings layout
        let settingsTVC = SettingsTVC()
        
        let settigsNavVC = BaseNavVC(rootViewController: settingsTVC)
        settigsNavVC.title = "Settings"
        settigsNavVC.tabBarItem.image = UIImage(systemName: "gear")
        
        self.viewControllers =
            [
                recentChatNavVC,
                usersNavVC,
                settigsNavVC
            ]
    }
}
