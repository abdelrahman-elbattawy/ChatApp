//
//  addChannelTVC.swift
//  ChatApp
//
//  Created by Aboody on 12/08/2021.
//

import UIKit

class AddChannelTVC: UITableViewController {
     
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavUI()
        setupTableView()
        setupBarButtonItem()
    }
    
    //MARK: - Setup
    private func setupNavUI() {
        
        self.navigationItem.title = "New Channel"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.alwaysBounceVertical = true
    }
    
    private func setupBarButtonItem() {
        
        let saveChannel = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.saveChannelButtonPressed))
        self.navigationItem.rightBarButtonItem  = saveChannel
    }
    
    //MARK: - IBActions
    @objc private func saveChannelButtonPressed() {
        
    }
}

extension AddChannelTVC {
    
    //MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    //MARK: - Table View Delegates
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 80 : 140
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "tableviewBackgroundColor")
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
}

