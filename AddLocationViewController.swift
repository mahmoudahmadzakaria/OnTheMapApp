//
//  AddLocationViewController.swift
//  OnTheMap1.1
//
//  Created by Mahmoud Zakaria on 16/05/1439 AH.
//  Copyright © 1439 Mahmoud Zakaria. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

class AddLocationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var website: UITextField!
    @IBOutlet weak var findLocation: UIButton!
    @IBOutlet weak var debugTextLabel: UILabel!
   
    @IBOutlet weak var refreshIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        website.delegate = self
        location.delegate = self
        subscribeToKeyboardNotifications()
        refreshIndicator.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if location.isFirstResponder {
            view.frame.origin.y = 0
        }
        if website.isFirstResponder {
            view.frame.origin.y = 0
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func findLocationPressed(_ sender: AnyObject) {
        if location.text!.isEmpty || website.text!.isEmpty {
            debugTextLabel.text = "Location or Website Empty."
        } else{
            let geocoder = CLGeocoder()
             self.refreshIndicator.isHidden = false
            refreshIndicator.startAnimating()
            geocoder.geocodeAddressString(location.text!, completionHandler: {(placemarks, error) -> Void in
                if((error) != nil){
                    self.refreshIndicator.isHidden = true
                    self.refreshIndicator.stopAnimating()
                    print("Error", error ?? "")
                    self.debugTextLabel.text = " Error, try again"
                }
                if let placemark = placemarks?.first {
                    let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                    UDBClient.sharedInstance().latidude = coordinates.latitude
                    UDBClient.sharedInstance().longitude = coordinates.longitude
                    UDBClient.sharedInstance().mapString = self.location.text
                    UDBClient.sharedInstance().mediaURL = self.website.text
                     self.refreshIndicator.isHidden = false
                    self.refreshIndicator.stopAnimating()
                    self.presentController()
                }
            })
        }
    }
    func presentController() {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "AddLocationOnMapViewController") as! AddLocationOnMapViewController
        //self.present(detailController, animated: true, completion: nil)
         _ = detailController.view
        self.navigationController!.pushViewController(detailController, animated: true)
    }
}
