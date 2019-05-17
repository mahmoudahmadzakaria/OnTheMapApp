//
//  MapViewController.swift
//  OnTheMap1.1
//
//  Created by Mahmoud Zakaria on 15/05/1439 AH.
//  Copyright © 1439 Mahmoud Zakaria. All rights reserved.
//

import UIKit
import MapKit
import SafariServices

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var refreshIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mapView: MKMapView!

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        //mapView.delegate = self
        setUIEnabled(false)
        UDBClient.sharedInstance().getStudentsLocations { (success, error) in
            //print(students)
            if success! {
                performUIUpdatesOnMain {
                    //self.mapView.reloadInputViews()
                    self.complete()
                    self.setUIEnabled(true)
                }
            } else {
                print(error ?? "empty error")
                let alertController = UIAlertController(title: "Alert!", message: "Bad Connection", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "Dismiss", style: .default) { (action:UIAlertAction!) in
                    print("Ok button tapped");
                    self.setUIEnabled(true)
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion:nil)
            }
        }
    }
    
    func complete()
    {
        var annotations = [MKPointAnnotation]()
        
        for dictionary in UDBClient.sharedInstance().students {
            
            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
            let lat = CLLocationDegrees(dictionary.latitude)
            
            let long = CLLocationDegrees(dictionary.longitude)
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = dictionary.firstName
            let last = dictionary.lastName
            let mediaURL = dictionary.mediaURL
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            //annotation.title = "\(first) \(last)"
            var FN: String = ""
            if first != nil {
                annotation.title = first
                FN = first!
            }
            if (last != nil) {
                annotation.title = FN + " " + last!
            }
            
            annotation.subtitle = mediaURL
            
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        
        self.mapView.removeAnnotations(mapView.annotations)
        
        // When the array is complete, we add the annotations to the map.
        self.mapView.addAnnotations(annotations)
        
    
    }
    
    // MARK: - MKMapViewDelegate
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
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
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let toOpen = view.annotation?.subtitle! {
                if verifyUrl(urlString: toOpen) {
                    let url = URL(string: toOpen)!
                    let svc = SFSafariViewController(url: url)
                    present(svc, animated: true, completion: nil)
                } else {
                    let alertController = UIAlertController(title: "Alert!", message: "Invalid Link", preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "Dismiss", style: .default) { (action:UIAlertAction!) in
                        print("Ok button tapped");
                    }
                    alertController.addAction(OKAction)
                    self.present(alertController, animated: true, completion:nil)
                }
            }
        }
    }
    
    func verifyUrl(urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = URL(string: urlString) {
                return UIApplication.shared.canOpenURL(url)
            }
        }
        return false
    }
    
    @IBAction func Logout(_ sender: Any) {
        UDBClient.sharedInstance().deleteSession() { (success, error) in
            if success! {
                self.dismiss(animated: true, completion: nil)
            }
            else {
                print("cannot log out")
            }
        }
    }
    
    @IBAction func Add(_ sender: Any) {
        let objectId = UDBClient.sharedInstance().objectId
        if objectId != nil {
                // account exist
                let alertController = UIAlertController(title: "Alert!", message: "User \(String(describing: UDBClient.sharedInstance().firstName!)) \(UDBClient.sharedInstance().lastName!) Has Alreday Posted a StudentLocation. Would You Like to Overwrite Their Location", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "Overwrite", style: .default) { (action:UIAlertAction!) in
                    print("Ok button tapped")
                    let detailController = self.storyboard!.instantiateViewController(withIdentifier: "AddLocationViewController") as! AddLocationViewController
                    //self.present(detailController, animated: true, completion: nil)
                    self.navigationController!.pushViewController(detailController, animated: true)
                }
                let cancleAction = UIAlertAction(title: "Cancel", style: .default) { (action:UIAlertAction!) in
                    print("Cancel button tapped");
                }
                alertController.addAction(OKAction)
                alertController.addAction(cancleAction)
                self.present(alertController, animated: true, completion:nil)
                
            }
            else
            {
                // new account
                let detailController = self.storyboard!.instantiateViewController(withIdentifier: "AddLocationViewController") as! AddLocationViewController
                //self.present(detailController, animated: true, completion: nil)
                self.navigationController!.pushViewController(detailController, animated: true)
            }
        
        
    }
    @IBAction func Refresh(_ sender: Any) {
        viewWillAppear(true)
    }

}

private extension MapViewController {
    
    func setUIEnabled(_ enabled: Bool) {
        //mapView.is
        //mapView.isPagingEnabled = enabled
        if enabled {
            mapView.alpha = 1
            refreshIndicator.startAnimating()
        } else {
            mapView.alpha = 0.5
            refreshIndicator.startAnimating()
        }
    }
}
