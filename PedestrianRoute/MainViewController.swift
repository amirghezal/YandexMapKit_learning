//
//  MainViewController.swift
//  CityAdviser
//
//  Created by Амир Гезаль on 24.01.2020.
//  Copyright © 2020 Амир Гезаль. All rights reserved.
//

import UIKit
import YandexMapKit
import CoreLocation
import YandexMapKitTransport

class MainViewController: UIViewController {
    //MapKitOutlet
    @IBOutlet weak var mapView: YMKMapView!
    
    //Constants
    //session for tracking
    var session : YMKMasstransitSession?
    //locationManager
    let manager = CLLocationManager()
    //Class model struct
    let model = MainModel()
    

    
    //ViewControllerLifeCicle
    //ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        manager.startUpdatingLocation()
        
        //sets userIcon layer
        let mapkit = YMKMapKit.sharedInstance()
        let userLayer = mapkit?.createUserLocationLayer(with: mapView.mapWindow)
        userLayer?.setVisibleWithOn(true)
        }
    
}

extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let lat = location?.coordinate.latitude
        let lon = location?.coordinate.longitude
        DispatchQueue.main.async {
            self.model.moveCameraTo(lat!, lon!, self.mapView)
            self.model.createPath(self.mapView,
                                  self.model.firstSet(lat, lon),
                                  &self.session)
            manager.stopUpdatingLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

