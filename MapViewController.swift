//
//  MapViewController.swift
//  DrugBook
//
//  Created by Maksim Pisaryk on 11/26/19.
//  Copyright © 2019 cecs. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapTypeSegmentedCtrl: UISegmentedControl!
    
    var locationManager: CLLocationManager!
    var drugs:[Drug] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    @IBAction func mapTypeChanged(_ sender: Any) {
        switch mapTypeSegmentedCtrl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
        default:
            break
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        //Get drugs from Core Data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "Drug")
        var fetchedObjects:[NSManagedObject] = []
        
        do {
            fetchedObjects = try context.fetch(request)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        drugs = fetchedObjects as! [Drug]
        //go through all drugs
        for drug in drugs { //as! [Drug] {
            let address = "\(drug.streetAddress!) \(drug.city!) \(drug.state!)"
            //geocoding
            let geoCoder = CLGeocoder()
            
            geoCoder.geocodeAddressString(address) {(placemarks, error) in
                self.processAddressResponse(drug, withPlacemarks: placemarks, error: error)
            }
        }
    }
    
    private func processAddressResponse(_ drug: Drug, withPlacemarks placemarks: [CLPlacemark]?,
                                        error: Error?) {
        if let error = error {
            print("Geocode Error: \(error)")
        }
        else {
            var bestMatch: CLLocation?
            if let placemarks = placemarks, placemarks.count > 0 {
                bestMatch = placemarks.first?.location
            }
            if let coordinate = bestMatch?.coordinate {
                let mapPoint = MapPoint(latitude: coordinate.latitude, longitude: coordinate.longitude)
                mapPoint.title = drug.manufacturerName
                mapPoint.subtitle = drug.streetAddress
                mapView.addAnnotation(mapPoint)
            }
            else {
                print("Didn't find any matching locations")
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
            var coordinateSpan = MKCoordinateSpan()
            coordinateSpan.latitudeDelta = 0.05
            coordinateSpan.longitudeDelta = 0.05
        
            let coordinateRegion = MKCoordinateRegion(center: userLocation.coordinate, span: coordinateSpan)
            mapView.setRegion(coordinateRegion, animated: true)
            mapView.removeAnnotations(self.mapView.annotations)

            let mapPoint = MapPoint(latitude: userLocation.coordinate.latitude,
                                    longitude: userLocation.coordinate.longitude)
            mapPoint.title = "You"
            mapPoint.subtitle = "are here"
            mapView.addAnnotation(mapPoint)

            
        }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
