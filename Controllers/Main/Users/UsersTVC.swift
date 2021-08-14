//
//  UsersTVC.swift
//  ChatApp
//
//  Created by Aboody on 01/08/2021.
//

import UIKit

class UsersTVC: UITableViewController {
       
    //MARK: - Constants
    static let section1Cell1 = "UsersS1C1"
    var allUsers: [User] = []
    var filteredUsers: [User] = []
    let searchController = UISearchController(searchResultsController: nil)
    
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        self.tableView.refreshControl = self.refreshControl
        
        setupSearchController()
        setupNavUI()
        setupTableView()
        downloadUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    //MARK: - Setup
    private func setupNavUI() {
        
        self.navigationItem.title = "Users"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.alwaysBounceVertical = true
        
        // Register Cells
        tableView.register(UINib(nibName: UsersTVC.section1Cell1, bundle: nil), forCellReuseIdentifier: UsersTVC.section1Cell1)
    }
    private func setupSearchController() {
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = true
                
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search user"
        searchController.searchResultsUpdater = self
        
        definesPresentationContext = true
    }
   
    //MARK: - UIScrollViewDelegate
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.refreshControl!.isRefreshing {
            self.downloadUsers()
            self.refreshControl!.endRefreshing()
        }
    }
    
    //MARK: - Helpers Functions
    private func downloadUsers() {
        FirebaseUserListener.shared.downloadAllUsersFromFirebase { (allFirebaseUsers) in
            self.allUsers = allFirebaseUsers ?? []
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func filteredContentForSearchText(searchText: String) {
        filteredUsers = allUsers.filter({ (user) -> Bool in
            return user.username.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    
    private func showUserProfile(_ user: User) {
        
        let profileTVC = ProfileUserTVC()
        profileTVC.modalPresentationStyle = .fullScreen
        profileTVC.user = user
        self.navigationController?.pushViewController(profileTVC, animated: true)
        
    }
    
}

extension UsersTVC {
    
    //MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.isActive ? filteredUsers.count : allUsers.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UsersTVC.section1Cell1, for: indexPath) as! UsersS1C1
        
        let user = searchController.isActive ? filteredUsers[indexPath.row] : allUsers[indexPath.row]
        
        cell.configure(user: user)
        
        return cell
    }
    
    //MARK: - Table view delegates
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "tableviewBackgroundColor")
        return headerView
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let user = searchController.isActive ? filteredUsers[indexPath.row] : allUsers[indexPath.row]
        
        showUserProfile(user)
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
}

extension UsersTVC: UISearchResultsUpdating {
    
    //MARK: - Search Controller delegates
    func updateSearchResults(for searchController: UISearchController) {
        
        filteredContentForSearchText(searchText: searchController.searchBar.text!)
    }
}
