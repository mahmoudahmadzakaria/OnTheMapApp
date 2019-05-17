//
//  UDBConvenience.swift
//  OnTheMap1.1
//
//  Created by Mahmoud Zakaria on 11/05/1439 AH.
//  Copyright © 1439 Mahmoud Zakaria. All rights reserved.
//

import Foundation

extension UDBClient {
    
    // MARK: Authentication (GET & POST) Methods (Udacity)
    
    func authenticateWithEmailAndPassword (Email: String, Password: String, authenticateWithEmailAndPassword: @escaping (_ sucess: Bool?, _ error: String?) -> Void) {
        
        getAccountKey(Email: Email, Password: Password) { (success, accoutKey, error) in
            if success! {
                self.accountKey = accoutKey
                self.getFirstAndLastName(accoutKey) { (success, firstName, lastName, error) in
                    if success! {
                        self.firstName = firstName
                        self.lastName = lastName
                    }
                    authenticateWithEmailAndPassword(success, error)
                }
            }
            else {
                authenticateWithEmailAndPassword(success,error)
            }
        }
    }
    
    /* Get the Account Key (Udacity): POST Method */
    func getAccountKey (Email: String, Password: String, completionHandlerForgetAkkountKey: @escaping (_ success: Bool?, _ accountKey: String?, _ error: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [String:AnyObject]()
        let mutableMethod = UDBClient.Methods.Udacity_Session
        let jsonBody = "{\"udacity\": {\"username\": \"\(Email)\", \"password\": \"\(Password)\"}}"
        print(jsonBody)
        
        /* 2. Make the request */
        let _ = taskForPOSTMethod(mutableMethod, parameters: parameters as [String:AnyObject], jsonBody: jsonBody) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForgetAkkountKey(false, nil, "Login Failed (Sessin ID)")
            } else {
                if let results = results?[UDBClient.JSONResponseKeys.Account] as? [String: AnyObject] {
                    let sendResults = results [UDBClient.JSONResponseKeys.Account_Registered] as? Bool
                    let accountKey = results [UDBClient.JSONResponseKeys.Account_Key] as? String
                            completionHandlerForgetAkkountKey(sendResults, accountKey,nil)
                } else {
                    completionHandlerForgetAkkountKey(false, nil, "Login Failed (Session ID")
                }
            }
        }
    }
    
    /* Get the First and Last Name (Udacity): GET Method */
    func getFirstAndLastName (_ accountKey: String?, CompletionHandlerForGetFirstAndLastName: @escaping (_ success: Bool?, _ firstName: String?, _ lastName: String?, _ error: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [String:AnyObject]()
        var mutableMethod: String = UDBClient.Methods.Udacity_User
        mutableMethod = substituteKeyInMethod(mutableMethod, key: UDBClient.URLKeys.UserID, value: accountKey!)!
        
        /* 2. Make the request */
        let _ = taskForGETMethod (mutableMethod, parameters: parameters as [String:AnyObject]) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                CompletionHandlerForGetFirstAndLastName(false, nil, nil, "error")
            } else {
                if let results = results?[UDBClient.JSONResponseKeys.User] as? [String:AnyObject] {
                    let firstName = results[UDBClient.JSONResponseKeys.First_Name_Udacity] as? String
                    let lastName = results[UDBClient.JSONResponseKeys.Last_Name_Udacity] as? String
                    CompletionHandlerForGetFirstAndLastName(true, firstName, lastName, nil)
                } else {
                    CompletionHandlerForGetFirstAndLastName(false, nil, nil, "error")
                }
            }
        }
    }
    
    /* Delete Session (Udacity): DELETE Method */
    func deleteSession (completionHandlerFordeleteSession: @escaping (_ success: Bool?, _ error: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [String:AnyObject]()
        let mutableMethod = UDBClient.Methods.Udacity_Session
        let jsonBody = ""
        
        /* 2. Make the request */
        let _ = taskForDELETEMethod(mutableMethod, parameters: parameters as [String:AnyObject], jsonBody: jsonBody) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerFordeleteSession(false, "Error")
            } else {
                if let results = results?[UDBClient.JSONResponseKeys.Session] as? [String: AnyObject] {
                    if let results = results [UDBClient.JSONResponseKeys.Session_id] as? String {
                        completionHandlerFordeleteSession(true, nil)
                    }
                    else {
                        completionHandlerFordeleteSession(false, "Error")
                    }
                } else {
                    completionHandlerFordeleteSession(false, "Error")
                }
            }
        }
    }
    
    // MARK: GET Convenience Methods (Parse): get Students Locations
    
    func getStudentsLocations(_ completionHandlerForStudentsLocations: @escaping (_ success: Bool?, _ error: NSError?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [UDBClient.ParameterKeys.Order: UDBClient.JSONBodyKeys.UpdateDate,
                          UDBClient.ParameterKeys.Limit: UDBClient.JSONBodyKeys.LimitNumber]
        var mutableMethod: String = UDBClient.Methods.Parse_Method
        
        /* 2. Make the request */
        let _ = taskForGETMethod_Parse(mutableMethod, parameters: parameters as [String:AnyObject]) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForStudentsLocations(false, error)
            } else {
                if let results = results?[UDBClient.JSONResponseKeys.Results] as? [[String:AnyObject]] {
                    let studentsLocations = PDBStudentsLocations.locationsFromResults (results)
                    UDBClient.sharedInstance().students = studentsLocations
                    completionHandlerForStudentsLocations(true, nil)
                } else {
                    completionHandlerForStudentsLocations(false, NSError(domain: "getStudentsLocations parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudentsLocations"]))
                }
            }
        }
    }
    
    // MARK: GET Convenience Methods (Parse): get Student Location
    
    func getStudentLocation (accountKey: String?, _ completionHandlerForStudentLocation: @escaping (_ objectId: String?, _ success: Bool?, _ error: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [UDBClient.ParameterKeys.wherekey: substituteKeyInMethod(UDBClient.JSONBodyKeys.uniqueKey, key: UDBClient.URLKeys.UserID, value: accountKey!)!]
        let mutableMethod: String = UDBClient.Methods.Parse_Method
        
        /* 2. Make the request */
        let _ = taskForGETMethod_Parse(mutableMethod, parameters: parameters as [String:AnyObject]) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForStudentLocation(nil, false, "error while getting the object ID")
            } else {
                let datas: [[String:AnyObject]]
                if let results = results?[UDBClient.JSONResponseKeys.Results] as? [[String:AnyObject]] {
                    datas = results
                    var data1: [String: AnyObject] = [:]
                    for data in datas{
                        data1 = data
                    }
                    print(data1)
                    if data1.isEmpty{
                        completionHandlerForStudentLocation(nil, true, nil)
                    }
                    else
                    {
                        completionHandlerForStudentLocation(data1["objectId"] as? String, true, nil)
                    }
                    //if let results = results["objectId"] as? String {
                            //completionHandlerForStudentLocation(results, true, nil)
                        //print(results)
                        
                       // }
                    //else {
                        //completionHandlerForStudentLocation(nil, true, nil)
                       // print("waaaaaa")
                    //}
                }else {
                    completionHandlerForStudentLocation(nil, false, "error while getting the object ID")
                    print("ddd")
                }
            }
        }
    }
    
    // MARK: POST Convenience Methods (Parse)
    
    func postStudentLocation(_ completionHandlerForpostStudentLocation: @escaping (_ success: Bool?, _ error: NSError?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [String:AnyObject]()
        let mutableMethod: String = UDBClient.Methods.Parse_Method
        let jsonBody = "{\"uniqueKey\": \"\(String(describing: UDBClient.sharedInstance().accountKey!))\", \"firstName\": \"\(UDBClient.sharedInstance().firstName!)\", \"lastName\": \"\(String(describing: UDBClient.sharedInstance().lastName!))\",\"mapString\": \"\(String(describing: UDBClient.sharedInstance().mapString!))\", \"mediaURL\": \"\(String(describing: UDBClient.sharedInstance().mediaURL!))\",\"latitude\": \(String(describing: UDBClient.sharedInstance().latidude!)), \"longitude\": \(String(describing: UDBClient.sharedInstance().longitude!))}"
       
        
        /* 2. Make the request */
        let _ = taskForPOSTMethod_Parse(mutableMethod, parameters: parameters as [String:AnyObject], jsonBody: jsonBody) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForpostStudentLocation(false, error)
            } else {
                if let results = results?[UDBClient.JSONResponseKeys.ObjectID] as? String {
                    completionHandlerForpostStudentLocation(true, nil)
                } else {
                    completionHandlerForpostStudentLocation(false, NSError(domain: "postStudentLocation parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse postStudentLocation"]))
                }
            }
        }
    }
    
    // MARK: POST Convenience Methods (Parse)
    
    func updateStudentLocation(objectId: String?, _ completionHandlerForupdateStudentLocation: @escaping (_ success: Bool?, _ error: NSError?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [String:AnyObject]()
        let mutableMethod: String = substituteKeyInMethod(UDBClient.Methods.Parse_Method_Put, key: UDBClient.URLKeys.UserID, value: objectId!)!
        
        var jsonBody = "{\"uniqueKey\": \"\(String(describing: UDBClient.sharedInstance().accountKey!))\", \"firstName\": \"\(String(describing: UDBClient.sharedInstance().firstName!))\", \"lastName\": \"\(String(describing: UDBClient.sharedInstance().lastName!))\",\"mapString\": \"\(String(describing: UDBClient.sharedInstance().mapString!))\", \"mediaURL\": \"\(String(describing: UDBClient.sharedInstance().mediaURL!))\",\"latitude\": \(String(describing: UDBClient.sharedInstance().latidude!)), \"longitude\": \(String(describing: UDBClient.sharedInstance().longitude!))}"

        
        /* 2. Make the request */
        let _ = taskForPUTMethod_Parse(mutableMethod, parameters: parameters as [String:AnyObject], jsonBody: jsonBody) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForupdateStudentLocation(false, error)
            } else {
                print(results)
                if let results = results?[UDBClient.JSONResponseKeys.UpdatedDate] as? String {
                    completionHandlerForupdateStudentLocation(true, nil)
                } else {
                    completionHandlerForupdateStudentLocation(false, NSError(domain: "postStudentLocation parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse postStudentLocation"]))
                }
            }
        }
    }
}
