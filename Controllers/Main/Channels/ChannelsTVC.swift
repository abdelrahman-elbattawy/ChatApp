//
//  ChannelsTVC.swift
//  ChatApp
//
//  Created by Aboody on 12/08/2021.
//

import UIKit

class ChannelsTVC: UITableViewController {
    
    //MARK: - Constants
    static let section1Cell1 = "ChannelsS1C1"
    
    //MARK: - Vars
    var channelSegment: UISegmentedControl!
    var allChannels: [Channel] = []
    var subscribedChannels: [Channel] = []
    
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSegmented()
        setupNavUI()
        setupTableView()
        setupBarButtonItem()
    }
    
    //MARK: - Setup
    private func setupNavUI() {
        
        self.navigationItem.title = "Channels"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.alwaysBounceVertical = true
        
        //Register Cells
        tableView.register(UINib(nibName: ChannelsTVC.section1Cell1, bundle: nil), forCellReuseIdentifier: ChannelsTVC.section1Cell1)
    }
    
    private func setupSegmented() {
        
        channelSegment = UISegmentedControl (items: ["Subscribed", "All Channels"])
        
        channelSegment.frame = CGRect(x: 10, y: 10, width: 300, height: 30)
        channelSegment.selectedSegmentIndex = 0
        channelSegment.addTarget(self, action: #selector(self.segmentedValueChanged(_:)), for: .valueChanged)
        
        navigationItem.titleView = channelSegment
    }
    
    private func setupBarButtonItem() {
        
        let usersButton = UIBarButtonItem(image: UIImage(systemName: "person.2"), style: .plain, target: self, action: #selector(self.usersButtonPressed))
        self.navigationItem.rightBarButtonItem = usersButton
    }
    
    //MARK: - IBActions
    @objc private func segmentedValueChanged(_ sender:UISegmentedControl!) {
        
    }
    
    @objc private func usersButtonPressed(){
        
        let channelProfile = ChannleProfileTVC()
        channelProfile.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(channelProfile, animated: true)
    }
}

extension ChannelsTVC {
    
    //MARK: - Table View Data Source    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channelSegment.selectedSegmentIndex == 0 ? subscribedChannels.count : allChannels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ChannelsTVC.section1Cell1, for: indexPath) as! ChannelsS1C1
        
        let channel = channelSegment.selectedSegmentIndex == 0 ? subscribedChannels[indexPath.row] : allChannels[indexPath.row]
        
        cell.configure(channel: channel)
        
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
