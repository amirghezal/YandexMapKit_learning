Данный пример очень плох с точки зрения разработчика: мы не проверяем возможность отслеживания, мы не проверяем статус разрешения,
не промисываем что делать в случае ручного изменения разрешения и тд. Этот пример просто занакомит нас с тем, как добавлять mapKit 
в свой проект


import UIKit
import YandexMapKit
import CoreLocation

class gitHubViewController: UIViewController {
    
    //создаем менеджера локации 
    let locationManager = CLLocationManager()
    
    //mapView
    @IBOutlet weak var mapView: YMKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        //получаем разрешение на использование
        locationManager.requestWhenInUseAuthorization()
        //начием отслеживать локацию
        locationManager.startUpdatingLocation()
    }
    
    //метод, перемещающий карту на указанные координаты
    func moveMap(_ latitude: Double,_ longitude: Double) {
        //создаем точку
        let mapPoint = YMKPoint(latitude: latitude, longitude: longitude)
        //перемещаем карту на указанную точку
        self.mapView.mapWindow.map.move(with: YMKCameraPosition(target: mapPoint, zoom: 17, azimuth: 0, tilt: 0))
    }
}

extension gitHubViewController: CLLocationManagerDelegate {
    
    //необходимые методы делегата
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations.last
        let latitude = currentLocation?.coordinate.latitude
        let longitude = currentLocation?.coordinate.longitude
        DispatchQueue.main.async {
            //останавливаем отслеживание локации
            self.locationManager.stopUpdatingLocation()
            //двигаем карту на первые полученные координаты
            self.moveMap(latitude!, longitude!)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
