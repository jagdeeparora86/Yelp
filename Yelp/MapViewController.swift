//
//  MapViewController.swift
//  Yelp
//
//  Created by Singh, Jagdeep on 10/24/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    
    @IBOutlet weak var mapView: MKMapView!
    var businesses: [Business]?
    var test = ["anapoorna"]
    let centerLocation = CLLocation(latitude: 37.785771, longitude: -122.406165)
    
    override func viewWillAppear(_ animated: Bool) {
        mapView.setRegion(MKCoordinateRegionMake(centerLocation.coordinate, MKCoordinateSpanMake(0.1, 0.1)), animated: false)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let centerLocation = CLLocation(latitude: 37.785771, longitude: -122.406165)
        mapView.setRegion(MKCoordinateRegionMake(centerLocation.coordinate, MKCoordinateSpanMake(0.1, 0.1)), animated: false)
        goToLocation()
//        let testlocation = CLLocation(latitude: 37.750308, longitude:  -122.414086)
//        addAnnotationAtCoordinate(coordinate: testlocation.coordinate)
    
    }

    func goToLocation(){
        let regionDistance : CLLocationDistance = 2000
        let region = MKCoordinateRegionMakeWithDistance(centerLocation.coordinate, regionDistance,regionDistance)
        mapView.setRegion(region, animated: false)
        
        
        for buisness: Business in self.businesses! {
            let annotation = MKPointAnnotation()
            annotation.coordinate = buisness.cordinates
                    annotation.title = buisness.name!
                    mapView.addAnnotation(annotation)
        }
        let annotation = MKPointAnnotation()
//        let testlocation = CLLocation(latitude: 37.761908, longitude:  -122.414086)
//        annotation.coordinate = testlocation.coordinate
//        annotation.title = "An annotation!"
        mapView.addAnnotation(annotation)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goBackToList(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    
//    func addAnnotationAtCoordinate(coordinate: CLLocationCoordinate2D) {
//        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
//        let region = MKCoordinateRegion(center: location.coordinate, span: span)
//        mapView.setRegion(region, animated: false)
//
//        
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
