//
//  BaseNVC.swift
//  ChatApp
//
//  Created by Aboody on 01/08/2021.
//

import UIKit

class BaseNavVC: UINavigationController {

    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavUI()
    }
    
    //MARK: - Setup
    private func setupNavUI() {
        self.isNavigationBarHidden = false
    }
}
