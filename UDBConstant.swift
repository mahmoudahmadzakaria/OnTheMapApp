//
//  UDBConstant.swift
//  OnTheMap1.1
//
//  Created by Mahmoud Zakaria on 11/05/1439 AH.
//  Copyright © 1439 Mahmoud Zakaria. All rights reserved.
//

import Foundation

extension UDBClient {
   
    // MARK: Constants
    struct Constants {
        
        // MARK: URLs for Udacity
        static let Udacity_ApiScheme = "https"
        static let Udacity_ApiHost = "www.udacity.com"
        static let Udacity_ApiPath = "/api"
        
        // MARK: URLs for Parse
        static let Parse_ApiScheme = "https"
        static let Parse_ApiHost = "parse.udacity.com"
        static let Parse_ApiPath = "/parse"
    }
    
    // MARK: Methods
    struct Methods {
        
        // MARK: Udacity Account
        static let Udacity_Session = "/session"
        static let Udacity_User = "/users/{id}"
        
        //MARK: Parse
        static let Parse_Method = "/classes/StudentLocation"
        static let Parse_Method_Put = "/classes/StudentLocation/{id}"
    }
    
    // MARK: URL Keys
    struct URLKeys {
        static let UserID = "id"
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        
        //MARK: Parse
        static let Order = "order"
        static let Limit = "limit"
        static let wherekey = "where"
    }
    
    // MARK: JSON Body Keys
    struct JSONBodyKeys {
        
        //MARK: Parse
        static let UpdateDate = "-updatedAt"
        static let LimitNumber = "100"
        static let uniqueKey = "{\"uniqueKey\":\"{id}\"}"
        
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        //Udacity Account
        static let Account = "account"
        static let Account_Registered = "registered"
        static let Account_Key = "key"
        static let Session = "session"
        static let Session_id = "id"
        
        //Udacity
        static let User = "user"
        static let First_Name_Udacity = "first_name"
        static let Last_Name_Udacity = "last_name"
        
        //Students Locations
        static let Results = "results"
        static let CreatedDate = "createdAt"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let ObjectID = "objectId"
        static let UniqueKey = "uniqueKey"
        static let UpdatedDate = "updatedAt"

    }
}
