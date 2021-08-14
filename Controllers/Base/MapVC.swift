//
//  MapVC.swift
//  ChatApp
//
//  Created by Aboody on 11/08/2021.
//

import UIKit
import MapKit
import CoreLocation

class MapVC: UIViewController {

    //MARK: - Vars
    var location: CLLocation?
    var mapView: MKMapView!
    
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTitle()
        configureMapView()
        configureLefBarButton()
    }
    
    //MARK: - Configuration
    private func configureMapView() {
        
        mapView = MKMapView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        mapView.showsUserLocation = true
        
        if location != nil {
            mapView.setCenter(location!.coordinate, animated: true)
            mapView.addAnnotation(MapAnnotation(title: "User Location", coordinate: location!.coordinate))
        }
        
        view.addSubview(mapView)
    }
    
    private func configureLefBarButton() {
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(self.backButtonPressed))
    }
    
    private func configureTitle() {
        
        self.title = "Map View"
    }
    
    //MARK: - IBActions
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
}
