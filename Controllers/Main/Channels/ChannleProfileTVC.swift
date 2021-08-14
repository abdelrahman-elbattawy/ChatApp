//
//  ChannleProfileTVC.swift
//  ChatApp
//
//  Created by Aboody on 12/08/2021.
//

import UIKit

class ChannleProfileTVC: UITableViewController {
        
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavUI()
        setupTableView()
        setupBarButtonItem()
    }
    
    //MARK: - Setup
    private func setupNavUI() {
        
        self.navigationItem.title = "My Channels"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.alwaysBounceVertical = true
        
        //Register Cells
        tableView.register(UINib(nibName: ChannelsTVC.section1Cell1, bundle: nil), forCellReuseIdentifier: ChannelsTVC.section1Cell1)
    }
    
    private func setupBarButtonItem() {
        
        let addChannel = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addChannelButtonPressed))
        self.navigationItem.rightBarButtonItem  = addChannel
    }
    
    //MARK: - IBActions
    @objc private func addChannelButtonPressed() {
        
        
    }
}

extension ChannleProfileTVC {
    
    //MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ChannelsTVC.section1Cell1, for: indexPath) as! ChannelsS1C1
                
//        cell.configure(channel: channel)
        
        return cell
    }
    
    //MARK: - Table View Delegates
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
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
