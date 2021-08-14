//
//  ProfileTVC.swift
//  ChatApp
//
//  Created by Aboody on 01/08/2021.
//

import UIKit

class EditProfileTVC: UITableViewController {
    
    //MARK: - Constants
    static let section1Cell1 = "EditProfileTVS1C1"
    static let section1Cell2 = "EditProfileTVS1C2"
    static let section2Cell1 = "EditProfileTVS2C1"
    var username: String?
    var status: String?
    var avatarImage: UIImage?
    
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showUserInfo()
        setupTableView()
        setupUI()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showUserInfo()
    }
    
    //MARK: - Setup
    private func setupTableView() {
        self.navigationItem.title = "Edit Profile"
        tableView.tableFooterView = UIView()
        tableView.alwaysBounceVertical = true
        
        // Register Cells
        // Section 1
        tableView.register(UINib(nibName: EditProfileTVC.section1Cell1, bundle: nil), forCellReuseIdentifier: EditProfileTVC.section1Cell1)
        tableView.register(UINib(nibName: EditProfileTVC.section1Cell2, bundle: nil), forCellReuseIdentifier: EditProfileTVC.section1Cell2)
        
        // Section 2
        tableView.register(UINib(nibName: EditProfileTVC.section2Cell1, bundle: nil), forCellReuseIdentifier: EditProfileTVC.section2Cell1)
    }
    private func setupUI() {
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    //MARK: - Helpers Functions
    private func showUserInfo() {
        if let user = User.currentUser {
            username = user.username
            status = user.status
            
            if user.avatarLink != "" {
                FileStorage.downloadImage(imageURL: user.avatarLink) { (avatarImage) in
                    self.avatarImage = avatarImage
                }
            }
            
            DispatchQueue.main.async {
                //Reload status cell
                let index = IndexPath(row: 0, section: 1)
                self.tableView.reloadRows(at: [index], with: .automatic)
            }
        }
    }
}

extension EditProfileTVC {
    
    //MARK: - TableView Delegates
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 2 : 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 { // Section 1
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: EditProfileTVC.section1Cell1
                                                         , for: indexPath) as! EditProfileTVS1C1
                cell.avatarImageView.image = self.avatarImage?.circleMasked
                cell.editProfile = self
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: EditProfileTVC.section1Cell2, for: indexPath) as! EditProfileTVS1C2
                cell.usernameTextField.text = username
                return cell
            }
        } else { // Section 2
            let cell = tableView.dequeueReusableCell(withIdentifier: EditProfileTVC.section2Cell1, for: indexPath) as! EditProfileTVS2C1
            cell.statusLabel.text = status
            return cell
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? indexPath.row == 0 ? 100 : 40 : 40
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0 : 30.0
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "tableviewBackgroundColor")
        return headerView
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 && indexPath.row == 0 {
            let stautsTVC = StatusTVC()
            self.navigationController?.pushViewController(stautsTVC, animated: true)
        }
    }
}

