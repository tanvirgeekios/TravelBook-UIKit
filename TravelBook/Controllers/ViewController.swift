//
//  ViewController.swift
//  TravelBook
//
//  Created by MD Tanvir Alam on 24/3/21.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    var latitude = Double()
    var longitude = Double()
    var locationManger = CLLocationManager()
    
    var selectedPlace:Places?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManger.delegate = self
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
        locationManger.requestWhenInUseAuthorization()
        locationManger.startUpdatingLocation()
        
        let gestureRecogniser = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecogniser:)))
        gestureRecogniser.minimumPressDuration = 3
        mapView.addGestureRecognizer(gestureRecogniser)
        
        if let selectedPlace = selectedPlace{
            if let title = selectedPlace.title, let subTitle = selectedPlace.subtitle{
                let annotation = MKPointAnnotation()
                annotation.title = title
                annotation.subtitle = subTitle
                let coordinate = CLLocationCoordinate2D(latitude: selectedPlace.lattitude, longitude: selectedPlace.longitude)
                annotation.coordinate = coordinate
                mapView.addAnnotation(annotation)
                nameText.text = title
                commentText.text = subTitle
                locationManger.stopUpdatingLocation()
                let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
                let region = MKCoordinateRegion(center: coordinate, span: span)
                mapView.setRegion(region, animated: true)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation{
            return nil
        }
        let reUseID = "myAnnotation"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reUseID) as? MKPinAnnotationView
        if pinView == nil{
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reUseID)
            pinView?.canShowCallout = true
            pinView?.tintColor = UIColor.black
            let button = UIButton(type: UIButton.ButtonType.detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
        }else{
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let selectedPlace = selectedPlace{
            let requestLocation = CLLocation(latitude: selectedPlace.lattitude, longitude: selectedPlace.longitude)
            CLGeocoder().reverseGeocodeLocation(requestLocation) { (placemarks, error) in
                if let placemarks = placemarks{
                    if placemarks.count > 0 {
                        let newPlaceMark = MKPlacemark(placemark: placemarks[0])
                        let item = MKMapItem(placemark: newPlaceMark)
                        item.name = self.selectedPlace?.title
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving]
                        item.openInMaps(launchOptions: launchOptions)
                    }
                }
            }
        }
    }
    
    
    @objc func chooseLocation(gestureRecogniser:UILongPressGestureRecognizer){
        if gestureRecogniser.state == .began{
            let touchedPoint = gestureRecogniser.location(in: self.mapView)
            let touchedCoordinate = self.mapView.convert(touchedPoint, toCoordinateFrom: self.mapView)
            latitude = touchedCoordinate.latitude
            longitude = touchedCoordinate.longitude
            let annotaiton = MKPointAnnotation()
            annotaiton.coordinate = touchedCoordinate
            annotaiton.title = nameText.text
            annotaiton.subtitle = commentText.text
            self.mapView.addAnnotation(annotaiton)
        }
    }
    

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if selectedPlace == nil{
            let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: location, span: span)
            mapView.setRegion(region, animated: true)
        
        }else{
            
        }
    }
    
    //MARK:- IBActions
    @IBAction func saveButtonClicked(_ sender: UIButton) {
        let newPlace = PlacesCoreDataModel(uuid: UUID(), title: nameText.text ?? "No Title", subtitle: commentText.text ?? "No Comment", latitude: latitude, longitude: longitude)
        CoredataHelper.shared.saveNewPlace(place: newPlace)
    }
}

