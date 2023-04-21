//
//  DetailsVC.swift
//  FindMyPlace
//
//  Created by Eda Oner on 21.04.2023.
//

import UIKit
import MapKit
import Parse

class DetailsVC: UIViewController, MKMapViewDelegate {

    
    
    @IBOutlet weak var detailsImageView: UIImageView!
    
    @IBOutlet weak var detailsNameLabel: UILabel!
    
    @IBOutlet weak var detailsTypeLabel: UILabel!
    
    
    @IBOutlet weak var detailsAtmosphereLabel: UILabel!
    
    @IBOutlet weak var detailsMapView: MKMapView!
    
    
    var chosenPlaceId = ""
    var chosenLatitude = Double()
    var chosenLongitude = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailsMapView.delegate = self
        getDataFromParse()
    }
    
    func getDataFromParse() {
        let query = PFQuery(className: "Places")
        query.whereKey("objectId", equalTo: chosenPlaceId)
        query.findObjectsInBackground{
            objects, error in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: "Could not find data", preferredStyle: UIAlertController.Style.alert)
                let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
                
                alert.addAction(ok)
                self.present(alert, animated: true)
            } else {
                if objects != nil {
                    if objects!.count > 0 {
                        let chosenPlace = objects![0]
                        if let placeName = chosenPlace.object(forKey: "name") as? String {
                            self.detailsNameLabel.text = placeName
                        }
                        if let placeType = chosenPlace.object(forKey: "type") as? String {
                            self.detailsTypeLabel.text = placeType
                        }
                        if let placeAtmosphere = chosenPlace.object(forKey: "atmosphere") as? String {
                            self.detailsAtmosphereLabel.text = placeAtmosphere
                        }
                        if let placeLatitude = chosenPlace.object(forKey: "latitude") as? String {
                            if let placeLatitudeDouble = Double(placeLatitude) {
                                self.chosenLatitude = placeLatitudeDouble
                            }
                        }
                        if let placeLongitude = chosenPlace.object(forKey: "longitude") as? String {
                            if let placeLongitudeDouble = Double(placeLongitude) {
                                self.chosenLongitude = placeLongitudeDouble
                            }
                        }
                        
                        if let imageData = chosenPlace.object(forKey: "image") as? PFFileObject {
                            imageData.getDataInBackground {
                                (data, error) in
                                if error != nil {
                                    
                                } else {
                                    if data != nil {
                                        self.detailsImageView.image = UIImage(data: data!)
                                    }
                                }
                            }
                        }
                        
                        let location = CLLocationCoordinate2D(latitude: self.chosenLatitude, longitude: self.chosenLongitude)
                        let span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
                        let region = MKCoordinateRegion(center: location, span: span)
                        self.detailsMapView.setRegion(region, animated: true)
                        
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = location
                        annotation.title = self.detailsNameLabel.text
                        annotation.subtitle = self.detailsTypeLabel.text
                        
                        self.detailsMapView.addAnnotation(annotation)
                    }
                }
            }
        }

    }
    
 
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        
        if pinView == nil {
            pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            let button = UIButton(type: .detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
        } else {
            pinView?.annotation = annotation
        }
        return pinView
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if self.chosenLatitude != 0.0 && self.chosenLongitude != 0.0 {
            let requestLocation = CLLocation(latitude: self.chosenLatitude, longitude: self.chosenLongitude)
            
            CLGeocoder().reverseGeocodeLocation(requestLocation) { (placemarks, error) in
                if let placemark = placemarks {
                    if placemark.count > 0 {
                        let mkPlacemark = MKPlacemark(placemark: placemark[0])
                        let mapItem = MKMapItem(placemark: mkPlacemark)
                        mapItem.name = self.detailsNameLabel.text
                        
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                        
                        mapItem.openInMaps(launchOptions: launchOptions)
                    }
                }
            }
        }
    }


}
