//
//  TableViewController.swift
//  OnTheMap1.1
//
//  Created by Mahmoud Zakaria on 12/05/1439 AH.
//  Copyright © 1439 Mahmoud Zakaria. All rights reserved.
//

import UIKit
import SafariServices

class TableViewController: UIViewController {
    
    @IBOutlet weak var refreshIndicator: UIActivityIndicatorView!
    @IBOutlet weak var studentsLocationsTableView: UITableView!
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        studentsLocationsTableView.delegate = self
        studentsLocationsTableView.dataSource = self
        setUIEnabled(false)
        UDBClient.sharedInstance().getStudentsLocations { (success, error) in
            if success! {
                performUIUpdatesOnMain {
                    self.studentsLocationsTableView.reloadData()
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
}

// MARK: - TableViewController: UITableViewDelegate, UITableViewDataSource

extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /* Get cell type */
        let cellReuseIdentifier = "LocationTableViewCell"
        let student = UDBClient.sharedInstance().students[(indexPath as NSIndexPath).row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        /* Set cell defaults */
        var FN: String = ""
        if student.firstName != nil {
            cell?.textLabel!.text = student.firstName!
            FN = student.firstName!
        }
        if (student.lastName != nil) {
            cell?.textLabel?.text = FN + " " + student.lastName!
        }
        
        cell?.imageView!.image = UIImage(named: "LocationLogo")
        
        if let detailTextLabel = cell?.detailTextLabel {
            detailTextLabel.text = student.mediaURL
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UDBClient.sharedInstance().students.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = UDBClient.sharedInstance().students[(indexPath as NSIndexPath).row]
        
        if verifyUrl(urlString: student.mediaURL!){
            let url = URL(string: student.mediaURL!)!
            let svc = SFSafariViewController(url: url)
            present(svc, animated: true, completion: nil)
        }
            
        else {
            let alertController = UIAlertController(title: "Alert!", message: "Invalid Link", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "Dismiss", style: .default) { (action:UIAlertAction!) in
                print("Ok button tapped");
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion:nil)
            
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
                    print("Ok button tapped");
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

// MARK: - LoginViewController (Configure UI)

private extension TableViewController {
    
    func setUIEnabled(_ enabled: Bool) {
        studentsLocationsTableView.isPagingEnabled = enabled
        if enabled {
            studentsLocationsTableView.alpha = 1
            refreshIndicator.startAnimating()
        } else {
            studentsLocationsTableView.alpha = 0.5
            refreshIndicator.startAnimating()
        }
    }
}
