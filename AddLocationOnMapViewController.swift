//
//  AddLocationOnMapViewController.swift
//  OnTheMap1.1
//
//  Created by Mahmoud Zakaria on 17/05/1439 AH.
//  Copyright © 1439 Mahmoud Zakaria. All rights reserved.
//

import UIKit
import MapKit

class AddLocationOnMapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        //mapView.delegate = self
        let annotation = MKPointAnnotation()
        print("rourou")
        
        let lat = UDBClient.sharedInstance().latidude!
        let long = UDBClient.sharedInstance().longitude!
        let mapString = UDBClient.sharedInstance().mapString!
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        annotation.coordinate = coordinate
        annotation.title = mapString
        
        let span = MKCoordinateSpanMake(0.005, 0.005)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView!.setRegion(region, animated: true)
        
        self.mapView!.addAnnotation(annotation)
        
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    @IBAction func finish(){
        let objectId = UDBClient.sharedInstance().objectId
        // user has already posted his location
        
        if objectId != nil {
                print("account exist")
                UDBClient.sharedInstance().updateStudentLocation(objectId: UDBClient.sharedInstance().objectId) { (success, error) in
                    if success! {
                        //self.dismiss(animated: true, completion: nil)
                        let controller = self.storyboard!.instantiateViewController(withIdentifier: "ManagerNavigationController") as! UITabBarController
                        self.present(controller, animated: true, completion: nil)
                    }
                    else {
                        print("error while updating a student location")
                        let alertController = UIAlertController(title: "Alert!", message: "error while updating a student location", preferredStyle: .alert)
                        let OKAction = UIAlertAction(title: "Dismiss", style: .default) { (action:UIAlertAction!) in
                            print("Ok button tapped");
                        }
                        alertController.addAction(OKAction)
                        self.present(alertController, animated: true, completion:nil)
                    }
                }
        }
        // user never posted his location
            else {
                UDBClient.sharedInstance().postStudentLocation() { (success, error) in
                    if success! {
                        //self.dismiss(animated: true, completion: nil)
                        let controller = self.storyboard!.instantiateViewController(withIdentifier: "ManagerNavigationController") as! UITabBarController
                        self.present(controller, animated: true, completion: nil)
                    }
                    else {
                        print("error while posting a student")
                        let alertController = UIAlertController(title: "Alert!", message: "error while posting a student", preferredStyle: .alert)
                        let OKAction = UIAlertAction(title: "Dismiss", style: .default) { (action:UIAlertAction!) in
                            print("Ok button tapped");
                        }
                        alertController.addAction(OKAction)
                        self.present(alertController, animated: true, completion:nil)
                    }
                }
            }
    }
}
