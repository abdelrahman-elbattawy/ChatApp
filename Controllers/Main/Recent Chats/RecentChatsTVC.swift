//
//  ChatsTVC.swift
//  ChatApp
//
//  Created by Aboody on 04/08/2021.
//

import UIKit

class RecentChatsTVC: UITableViewController {
     
    //MARK: - Constants
    static let section1Cell1 = "RecentChatsTVS1C1"
    let searchController = UISearchController(searchResultsController: nil)
    
    //MARK: - Vars
    var allRecents: [RecentChat] = []
    var filteredRecents: [RecentChat] = []
    
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavUI()
        setupTableView()
        downloadRecentChats()
        setupSearchController()
    }
    
    //MARK: - IBActions
    @objc private func usersButtonPressed() {
        
        let usersTVC = UsersTVC()
        self.navigationController?.pushViewController(usersTVC, animated: true)
    }
    
    //MARK: - Setup
    private func setupNavUI() {
        
        self.navigationItem.title = "Chats"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        // Users Button
        let usersButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(usersButtonPressed))
        self.navigationItem.rightBarButtonItem  = usersButton
    }
    
    private func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.alwaysBounceVertical = true
        
        //Register cell
        tableView.register(UINib(nibName: RecentChatsTVC.section1Cell1, bundle: nil), forCellReuseIdentifier: RecentChatsTVC.section1Cell1)
    }
    
    private func setupSearchController() {
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = true
                
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search user"
        searchController.searchResultsUpdater = self
        
        definesPresentationContext = true
    }
    
    //MARK: - Helpers Functions
    private func downloadRecentChats() {
        
        FirebaseRecentListener.shared.downloadRecentChatsFromFireStore { (allChats) in
            
            self.allRecents = allChats
            
            DispatchQueue.main.async {
                
                self.tableView.reloadData()
            }
        }
    }
    
    private func filteredContentForSearchText(searchText: String) {
        
        filteredRecents = allRecents.filter({ (recent) -> Bool in
            return recent.receiverName.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    
    private func goToChat(recent: RecentChat) {
        
        restartChat(chatRoomId: recent.chatRoomId, memberIds: recent.memberIds)
            
        let privateChatView = ChatRoomVC(chatId: recent.chatRoomId, recipientId: recent.receiverId, recipentName: recent.receiverName)
        privateChatView.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(privateChatView, animated: true)
    }
}

extension RecentChatsTVC {
    
    //MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.isActive ? filteredRecents.count : allRecents.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: RecentChatsTVC.section1Cell1, for: indexPath) as! RecentChatsTVS1C1
        
        let recent = searchController.isActive ? filteredRecents[indexPath.row] : allRecents[indexPath.row]
        
        cell.configure(recent: recent)
        
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
        
        let recent = searchController.isActive ? filteredRecents[indexPath.row] : allRecents[indexPath.row]
        FirebaseRecentListener.shared.clearUnreadCounter(recent)
        
        goToChat(recent: recent)
        
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let recent = searchController.isActive ? filteredRecents[indexPath.row] : allRecents[indexPath.row]
            FirebaseRecentListener.shared.deleteRecent(recent)
            
            if searchController.isActive {
                self.filteredRecents.remove(at: indexPath.row)
            } else {
                self.allRecents.remove(at: indexPath.row)
            }
                        
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        }
    }
}

extension RecentChatsTVC: UISearchResultsUpdating {
    
    //MARK: - Search Controller delegates
    func updateSearchResults(for searchController: UISearchController) {
        filteredContentForSearchText(searchText: searchController.searchBar.text!)
    }
}
