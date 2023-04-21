//
//  MapVC.swift
//  FindMyPlace
//
//  Created by Eda Oner on 21.04.2023.
//

import UIKit
import MapKit
import Parse

class MapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "< Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(backClicked))
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItem.Style.plain, target: self, action: #selector(saveClicked))
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecognizer:)))
        recognizer.minimumPressDuration = 2
        mapView.addGestureRecognizer(recognizer)
        
    }
    
    @objc func chooseLocation(gestureRecognizer: UIGestureRecognizer) {
        let touches = gestureRecognizer.location(in: self.mapView)
        let coordinates = self.mapView.convert(touches, toCoordinateFrom: self.mapView)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        annotation.title = PlaceDetail.sharedInstance.placeName
        annotation.subtitle = PlaceDetail.sharedInstance.placeType
        
        self.mapView.addAnnotation(annotation)
        
        PlaceDetail.sharedInstance.placeLatitude = String(coordinates.latitude)
        PlaceDetail.sharedInstance.placeLongitude = String(coordinates.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //locationManager.stopUpdatingLocation()
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    

    @objc func saveClicked() {
        
        let place = PlaceDetail.sharedInstance
        let object = PFObject(className: "Places")
        object["name"] = place.placeName
        object["type"] = place.placeType
        object["atmosphere"] = place.placeAtmosphere
        object["latitude"] = place.placeLatitude
        object["longitude"] = place.placeLongitude
        
        if let imageData = place.placeImage.jpegData(compressionQuality: 0.5) {
            object["image"] = PFFileObject(name: "image.jpg", data: imageData)
        }
        
        object.saveInBackground {
            success, error in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: "Couldn't save to database!", preferredStyle: UIAlertController.Style.alert)
                let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
                alert.addAction(ok)
                self.present(alert, animated: true)
                
            } else {
                self.performSegue(withIdentifier: "fromMapVCtoPlacesVC", sender: nil)
            }
        }
        
    }
    
    @objc func backClicked() {
        self.dismiss(animated: true)
    }

}
