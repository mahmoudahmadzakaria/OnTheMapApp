//
//  PDBStudentsLocations.swift
//  OnTheMap1.1
//
//  Created by Mahmoud Zakaria on 13/05/1439 AH.
//  Copyright © 1439 Mahmoud Zakaria. All rights reserved.
//

struct PDBStudentsLocations {
    
    // MARK: Properties
    
    let createdDate: String
    let firstName: String?
    let lastName: String?
    let latitude: Double
    let longitude: Double
    let mapString: String?
    let mediaURL: String?
    let objectId: String
    let uniqueKey: String?
    let updatedDate: String
    
    // MARK: Initializers
    
    // construct a PDBStudentsLocations from a dictionary
    init(dictionary: [String:AnyObject]) {
        createdDate = dictionary[UDBClient.JSONResponseKeys.CreatedDate] as! String
        firstName = dictionary[UDBClient.JSONResponseKeys.FirstName] as? String
        lastName = dictionary[UDBClient.JSONResponseKeys.LastName] as? String
        latitude = dictionary[UDBClient.JSONResponseKeys.Latitude] as! Double
        longitude = dictionary[UDBClient.JSONResponseKeys.Longitude] as! Double
        mapString = dictionary[UDBClient.JSONResponseKeys.MapString] as? String
        mediaURL = dictionary[UDBClient.JSONResponseKeys.MediaURL] as? String
        objectId = dictionary[UDBClient.JSONResponseKeys.ObjectID] as! String
        uniqueKey = dictionary[UDBClient.JSONResponseKeys.UniqueKey] as? String
        updatedDate = dictionary[UDBClient.JSONResponseKeys.UpdatedDate] as! String
    }
    
    static func locationsFromResults(_ results: [[String:AnyObject]]) -> [PDBStudentsLocations] {
        
        var studentsLocations = [PDBStudentsLocations]()
        
        // iterate through array of dictionaries, each Movie is a dictionary
        for result in results {
            if result["latitude"] != nil && result["longitude"] != nil {
                studentsLocations.append(PDBStudentsLocations(dictionary: result))
            }
        }
        return studentsLocations
    }
}


