//
//  MainModel.swift
//  CityAdviser
//
//  Created by Амир Гезаль on 24.01.2020.
//  Copyright © 2020 Амир Гезаль. All rights reserved.
//

import Foundation
import CoreLocation
import YandexMapKit
import YandexMapKitTransport

struct MainModel {
    //moveCamera with
    //1.coordinates
    func moveCameraTo(_ lat: Double, _ lon: Double,_ mapView: YMKMapView) {
        mapView.mapWindow.map.move(
            with: YMKCameraPosition.init(target: YMKPoint(latitude:lat, longitude:  lon), zoom: 17, azimuth: 0, tilt: 0),
            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 5),
            cameraCallback: nil)
    }
    //2.YMKPoint
    func moveCameraTo(_ forPoint: YMKPoint, _ mapView: YMKMapView) {
        mapView.mapWindow.map.move(
            with: YMKCameraPosition.init(target: forPoint, zoom: 14, azimuth: 0, tilt: 0),
            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 3),
            cameraCallback: nil)
    }
    
    //creates a path between two points
    func createPath(_ mapView: YMKMapView,_ array: [YMKRequestPoint],_ session: inout YMKMasstransitSession?) {
        
        //func when recievPaths
        func onRoutesReceived(_ routes: [YMKMasstransitRoute]) {
            let mapObjects = mapView.mapWindow.map.mapObjects
            for route in routes {
                mapObjects.addPolyline(with: route.geometry)
            }
        }
        //func wher reciveError
        func onRoutesError(_ error: Error) {
            print(error)
        }
        //handler
        let responseHandler = {(routesResponse: [YMKMasstransitRoute]?, error: Error?) -> Void in
            if let routes = routesResponse {
                onRoutesReceived(routes)
            } else {
                onRoutesError(error!)
            }
        }
        let router = YMKTransport.sharedInstance()?.createMasstransitRouter()
        session = router?.requestRoutes(with: array,
                                        masstransitOptions: YMKMasstransitOptions(),
                                        routeHandler: responseHandler)
    }
    
    func firstSet(_ lat: Double?, _ lon: Double?) -> [YMKRequestPoint] {
        //setting start (current GEO) and end points
        let startPoint = YMKPoint(latitude: lat!,
                                  longitude: lon!)
        let endPoint = YMKPoint(latitude: 55.753821,
                                longitude: 37.620139)
        let r1 = YMKRequestPoint(point: startPoint,
                                 type: .waypoint,
                                 pointContext: nil)
        let r2 = YMKRequestPoint(point: endPoint,
                                 type: .viapoint,
                                 pointContext: nil)
        return [r1,r2]
    }
}
