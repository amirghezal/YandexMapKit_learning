import UIKit
import YandexMapKit
import CoreLocation

class gitHubViewController: UIViewController {
    
    //setting LocationManager
    let locationManager = CLLocationManager()
    
    //mapView
    @IBOutlet weak var mapView: YMKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    //метод, перемещающий карту на указанные координаты
    func moveMap(_ latitude: Double,_ longitude: Double) {
        let mapPoint = YMKPoint(latitude: latitude, longitude: longitude)
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
            self.locationManager.startUpdatingLocation()
            self.moveMap(latitude!, longitude!)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
