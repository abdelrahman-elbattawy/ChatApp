//
//  StatusTVC.swift
//  ChatApp
//
//  Created by Aboody on 02/08/2021.
//

import UIKit

class StatusTVC: UITableViewController {
    
    //MARK: - Constants
    static let section1Cell1 = "StatusS1C1"
    var allStatuses: [String] = []
    
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupUI()
        
        loadUserStatus()
    }
    
    //MARK: - Setup
    private func setupTableView() {
        self.navigationItem.title = "Status"
        tableView.tableFooterView = UIView()
        
        //Register cells
        tableView.register(UINib(nibName: StatusTVC.section1Cell1, bundle: nil), forCellReuseIdentifier: StatusTVC.section1Cell1)
    }
    private func setupUI() {
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    //MARK: - Helpers Functions
    private func loadUserStatus() {
        allStatuses = userDefaults.object(forKey: kSTATUS) as! [String]
        tableView.reloadData()
    }
    
    private func updateCellCheck(_ indexPath: IndexPath) {
        
        if var user = User.currentUser {
            user.status = allStatuses[indexPath.row]
            saveUserLocally(user)
            FirebaseUserListener.shared.saveUserToFireStore(user)
        }
    }
}

extension StatusTVC {
    
    //MARK: - Table view delegates
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allStatuses.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StatusTVC.section1Cell1, for: indexPath) as! StatusS1C1
        
        let status = allStatuses[indexPath.row]
        cell.textLabel?.text = status
        
        cell.accessoryType = User.currentUser?.status == status ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        updateCellCheck(indexPath)
        tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "tableviewBackgroundColor")
        return headerView
    }
}
