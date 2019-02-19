//
//  ViewController.swift
//  PlaceApp2
//
//  Created by Raju Koushik Gorantla on 13/02/19.
//  Copyright © 2019 Manikanta Chintakunta. All rights reserved.
//
/*
 * Copyright 2019 Manikanta Chintakunta,
 *
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *
 * Right to use :  I give every person the right to  build and evaluate
 * the software package for the purpose of determining me grade and program assessment.
 *
 * Purpose: Displays the description of each place with additional features of adding,deleting and modifying a place.Uses a picker to pick a place inside the decription of a particular place and calculates the geeat circle distance and initial bearing distance between those two places.
 *
 * @author Manikanta Chintakunta
 * mailto:mchintak@asu.edu
 
 * @version February 15, 2019
 */

import UIKit

class ViewController: UIViewController,UIPickerViewDelegate,
UINavigationControllerDelegate {
    
    var places:[String:PlaceDescription] = [String:PlaceDescription]()
    var selectedPlace:String = "unknown"
    var names:[String] = [String]()
    var selected:String = ""
    //var picker = UIPickerView()
    var Name:[String] = [String]()
    
    @IBOutlet weak var placesTF: UITextField!
   // @IBOutlet weak var PlacesPicker: UIPickerView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var elevationLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var picker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(names)
        picker.isHidden = false
        
        let editButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.edit, target: self, action: #selector(ViewController.editPlace))
        self.navigationItem.rightBarButtonItem = editButton
        // Do any additional setup after loading the view, typically from a nib.
        
        nameLabel.text = places[selectedPlace]!.name
        descriptionLabel.text = places[selectedPlace]!.description
        categoryLabel.text = places[selectedPlace]!.category
        addressLabel.text = places[selectedPlace]!.address
        elevationLabel.text = String(places[selectedPlace]!.elevation)
        latitudeLabel.text = String(places[selectedPlace]!.latitude)
        longitudeLabel.text = String(places[selectedPlace]!.longitude)
        
        Name = ["ASU-West", "Barrow-Alaska", "Calgary-Alberta", "Circlestone", "London-England", "Moscow-Russia", "Muir-Woods", "New-York-NY", "Notre-Dame-Paris", "Reavis-Grave", "Reavis-Ranch", "Rogers-Trailhead", "Toreros", "UAK-Anchorage", "Windcave-Peak"]
        
        self.title = places[selectedPlace]?.name
        
        picker.delegate = self
        picker.removeFromSuperview()
        placesTF.inputView = picker
        
        selected =  (Name.count > 0) ? Name[0] : "unknown unknown"
        let crs:[String] = selected.components(separatedBy: " ")
        placesTF.text = crs[0]
        
    }
    
    @objc func editPlace() {
        print("edit place button clicked")
        
        //  query the user for the new student name and number. empty takes
        let promptND = UIAlertController(title: "Edit Place", message: "Edit Place Details", preferredStyle: UIAlertController.Style.alert)
        // if the user cancels, we don't want to add a student so nil handler
        promptND.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        // setup the OK action and provide a closure to be executed when/if OK selected
        promptND.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) -> Void in
            //print("you entered name: \(String(describing: promptND.textFields?[0].text)). Number: \(String(describing: promptND.textFields?[1].text)).")
            // Want to provide default values for name and studentid
            //let newPlaceName:String = (promptND.textFields?[0].text == "") ?
             //   "unknown" : (promptND.textFields?[0].text)!
           // let newPlaceName:String = self.places[self.selectedPlace]!.name
            let newDescription:String = (promptND.textFields?[0].text == "") ?
                "unknown" : (promptND.textFields?[0].text)!
            let newCategory:String = (promptND.textFields?[1].text == "") ?
                "unknown" : (promptND.textFields?[1].text)!
            let newAddress:String = (promptND.textFields?[2].text == "") ?
                "unknown" : (promptND.textFields?[2].text)!
            // since didn't specify the keyboard, don't know whether id is empty, alpha, or numeric:
            var newElevation:Double = 0.0
            var newLatitude:Double = 0.0
            var newLongitude:Double = 0.0
            if let myNumber = NumberFormatter().number(from: (promptND.textFields?[3].text)!) {
                newElevation = myNumber.doubleValue
            }
            if let myNumber = NumberFormatter().number(from: (promptND.textFields?[4].text)!) {
                newLatitude = myNumber.doubleValue
            }
            if let myNumber = NumberFormatter().number(from: (promptND.textFields?[5].text)!) {
                newLongitude = myNumber.doubleValue
            }
            
            self.places[self.selectedPlace]!.address = newAddress
            self.places[self.selectedPlace]!.description = newDescription
            self.places[self.selectedPlace]!.category = newCategory
            self.places[self.selectedPlace]!.elevation = newElevation
            self.places[self.selectedPlace]!.latitude = newLatitude
            self.places[self.selectedPlace]!.longitude = newLongitude
            
            
            
            
            
        /*    self.places.removeValue(forKey: self.selectedPlace)
            self.names = Array(self.places.keys)
            //tableView.deleteRows(at: [indexPath], with: .fade)
            //print("creating and adding student \(newStudName) with id: \(newStudID)")
            let aPlace:PlaceDescription = PlaceDescription(name: newPlaceName, description: newDescription, category: newCategory, address: newAddress, elevation:newElevation, latitude: newLatitude, longitude: newLongitude )
            self.places[newPlaceName] = aPlace
            self.names = Array(self.places.keys).sorted()
        */
           // self.tableView.reloadData()
        }))
      /*  promptND.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "Place Name"
        }) */
        promptND.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "Description"
        })
        promptND.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "Category"
        })
        promptND.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "Address"
        })
        promptND.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "Elevation"
        })
        promptND.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "Latitude"
        })
        promptND.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "Longitude"
        })
        
        present(promptND, animated: true, completion: nil)
    
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool){
        //print("entered navigationController willShow viewController")
        if let controller = viewController as? PlaceTableViewController {
            // pass back the students dictionary with potentially modified takes.
            controller.places = self.places
            // don't need to reload data. Students don't change here, but it can be done
            controller.tableView.reloadData()
        }
    }
    }
   /*
    // touch events on this view
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.placesTF.resignFirstResponder()
    }
    
    // MARK: -- UITextFieldDelegate Method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.placesTF.resignFirstResponder()
        return true
    } */
    
    // MARK: -- UIPickerVeiwDelegate method
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       // placesTF.text = names[row]
       // self.view.endEditing(false)
        selected = Name[row]
        let tokens:[String] = selected.components(separatedBy: " ")
        self.placesTF.text = tokens[0]
        self.placesTF.resignFirstResponder()
    }
    
    // UIPickerViewDelegate method
    func pickerView (_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
          //  return names[row]
        let crs:String = Name[row]
        let tokens:[String] = crs.components(separatedBy: " ")
        return tokens[0]
    }
    
    // MARK: -- UIPickerviewDataSource method
    func numberOfComponentsInPickerView(_ pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // UIPickerviewDataSource method
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Name.count
    }
    
}

