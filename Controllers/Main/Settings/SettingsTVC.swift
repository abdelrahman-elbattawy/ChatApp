//
//  SettingsTVC.swift
//  ChatApp
//
//  Created by Aboody on 01/08/2021.
//

import UIKit

class SettingsTVC: UITableViewController {
    
    //MARK: - Constants
    static let section1Cell1 = "SettingsTVS1C1"
    static let section2Cell1 = "SettingsTVS2C1"
    static let section2Cell2 = "SettingsTVS2C2"
    static let section3Cell1 = "SettingsTVS3C1"
    static let section3Cell2 = "SettingsTVS3C2"
    var username: String?
    var status: String?
    var avatarImage: UIImage?
    
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavUI()
        setupTableView()
        showUserInfo()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showUserInfo()
    }
    
    //MARK: - Setup
    private func setupNavUI() {
        
        self.navigationItem.title = "Settings"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    private func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.alwaysBounceVertical = true
        
        // Register Cells
        // Section 1
        tableView.register(UINib(nibName: SettingsTVC.section1Cell1, bundle: nil), forCellReuseIdentifier: SettingsTVC.section1Cell1)
        
        // Section 2
        tableView.register(UINib(nibName: SettingsTVC.section2Cell1, bundle: nil), forCellReuseIdentifier: SettingsTVC.section2Cell1)
        tableView.register(UINib(nibName: SettingsTVC.section2Cell2, bundle: nil), forCellReuseIdentifier: SettingsTVC.section2Cell2)
        
        // Section 3
        tableView.register(UINib(nibName: SettingsTVC.section3Cell1, bundle: nil), forCellReuseIdentifier: SettingsTVC.section3Cell1)
        tableView.register(UINib(nibName: SettingsTVC.section3Cell2, bundle: nil), forCellReuseIdentifier: SettingsTVC.section3Cell2)
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
                self.tableView.reloadData()
            }
        }
    }
}

extension SettingsTVC {
    
    //MARK: - TableView Delegates
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : 2
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 { // Section 1
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTVC.section1Cell1, for: indexPath) as! SettingsTVS1C1
            cell.usernameLabel.text = username
            cell.statusLabel.text = status
            cell.avatarImageView.image = avatarImage?.circleMasked
            return cell
        } else if indexPath.section == 1 { // Section 2
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTVC.section2Cell1, for: indexPath) as! SettingsTVS2C1
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTVC.section2Cell2, for: indexPath) as! SettingsTVS2C2
                return cell
            }
        } else { // Section 3
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTVC.section3Cell1, for: indexPath) as! SettingsTVS3C1
                
                if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                    cell.appVersionLabel.text = "App version \(appVersion)"
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTVC.section3Cell2, for: indexPath) as! SettingsTVS3C2
                return cell
            }
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 80 : 50
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0 : 30
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "tableviewBackgroundColor")
        return headerView
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 && indexPath.row == 0 {
            let editProfileVC = EditProfileTVC()
            self.navigationController?.pushViewController(editProfileVC, animated: true)
        }
    }
}

