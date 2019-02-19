//
//  PlaceDescription.swift
//  PlaceApp2
//
//  Created by Raju Koushik Gorantla on 14/02/19.
//  Copyright © 2019 Manikanta Chintakunta. All rights reserved.
//

import Foundation
import UIKit

class PlaceDescription {
    var name: String
    var description: String
    var category: String
    var address: String
    var elevation: Double
    var latitude: Double
    var longitude: Double
    
    public init(name: String, description: String, category: String, address: String, elevation: Double, latitude: Double, longitude: Double){
        self.name = name
        self.description = description
        self.category = category
        self.address = address
        self.elevation = elevation
        self.latitude = latitude
        self.longitude = longitude
    }
    
    
    public init (jsonStr: String){
        self.name = ""
        self.description=""
        self.category = ""
        self.address = ""
        self.elevation = 0
        self.latitude = 0
        self.longitude = 0
        
        if let data: NSData = jsonStr.data(using: String.Encoding.utf8) as NSData?{
            do{
                let dict = try JSONSerialization.jsonObject(with: data as Data,options:.mutableContainers) as?[String:AnyObject]
                self.name = (dict!["name"] as? String)!
                self.description = (dict!["description"] as? String)!
                self.category = (dict!["category"] as? String)!
                self.address = (dict!["address-street"] as? String)!
                self.elevation = (dict!["elevation"] as? Double)!
                self.latitude = (dict!["latitude"] as? Double)!
                self.longitude = (dict!["longitude"] as? Double)!
                
            } catch {
                print("unable to convert to dictionary")
                print(jsonStr)
                
            }
        }
        
    }
    
    public init(dict:[String:Any]){
        self.name = dict["name"] == nil ? "unknown" : dict["name"] as! String
        self.description = dict["description"] == nil ? "unknown" : dict["description"] as! String
        self.category = dict["category"] == nil ? "unknown" : dict["category"] as! String
        self.address = dict["address-street"] == nil ? "unknown" : dict["address-street"] as! String
        self.elevation = dict["elevation"] == nil ? 0.0 : dict["elevation"] as! Double
        self.latitude = dict["latitude"] == nil ? 0.0 : dict["latitude"] as! Double
        self.longitude = dict["longitude"] == nil ? 0.0 : dict["longitude"] as! Double
    }
    
    public func toJsonString() -> String {
        var jsonStr = "";
        let dict:[String : Any] = ["name": name, "description": description, "category":category, "address-street":address, "elevation":elevation, "latitude":latitude, "longitude":longitude] as [String : Any]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
            jsonStr = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        } catch let error as NSError {
            print("unable to convert dictionary to a Json Object with error: \(error)")
        }
        return jsonStr
    }
}

