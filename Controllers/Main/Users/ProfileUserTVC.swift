//
//  ProfileUserTVC.swift
//  ChatApp
//
//  Created by Aboody on 03/08/2021.
//

import UIKit

class ProfileUserTVC: UITableViewController {
        
    //MARK: - Constants
    static let section1Cell1 = "ProfileUserTVS1C1"
    static let section2Cell1 = "ProfileUserTVS2C1"
    var user: User?
    
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavUI()
        setupTableView()
    }
    
    //MARK: - Setup
    private func setupNavUI() {
        
        if user != nil {
            self.navigationItem.title = user?.username
        }
        self.navigationItem.largeTitleDisplayMode = .never
    }
    
    private func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.alwaysBounceVertical = true
        
        // Register Cells
        tableView.register(UINib(nibName: ProfileUserTVC.section1Cell1, bundle: nil), forCellReuseIdentifier: ProfileUserTVC.section1Cell1)
        tableView.register(UINib(nibName: ProfileUserTVC.section2Cell1, bundle: nil), forCellReuseIdentifier: ProfileUserTVC.section2Cell1)
    }
}

extension ProfileUserTVC {
    
    //MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileUserTVC.section1Cell1, for: indexPath) as! ProfileUserTVS1C1
            
            if user != nil {
                
                cell.userNameLabel.text = user?.username
                cell.statusLabel.text = user?.status
                
                if user?.avatarLink != "" {
                    FileStorage.downloadImage(imageURL: user!.avatarLink) { (avatarImage) in
                        cell.avatarImageView.image = avatarImage?.circleMasked
                    }
                }
            }

            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileUserTVC.section2Cell1, for: indexPath)
            return cell
        }
    }
    
    //MARK: - Table view delegates
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 200 : 50
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "tableviewBackgroundColor")
        return headerView
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 {
                        
            let chatId = startChat(user1: User.currentUser!, user2: user!)
            
            let privateChatRoomVC = ChatRoomVC(chatId: chatId, recipientId: user!.id, recipentName: user!.username)
            privateChatRoomVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(privateChatRoomVC, animated: true)
        }
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
}
