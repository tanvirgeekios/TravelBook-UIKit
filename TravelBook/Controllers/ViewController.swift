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
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    //MARK:- IBActions
    @IBAction func saveButtonClicked(_ sender: UIButton) {
        let newPlace = PlacesCoreDataModel(uuid: UUID(), title: nameText.text ?? "No Title", subtitle: commentText.text ?? "No Comment", latitude: latitude, longitude: longitude)
        CoredataHelper.shared.saveNewPlace(place: newPlace)
    }
}

