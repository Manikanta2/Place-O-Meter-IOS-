//
//  PlaceTableViewController.swift
//  PlaceApp2
//
//  Created by Raju Koushik Gorantla on 14/02/19.
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

class PlaceTableViewController: UITableViewController {
    
    @IBOutlet var PlaceTableView: UITableView!
    
    var places:[String:PlaceDescription] = [String:PlaceDescription]()
    var names:[String] = [String]()
    var selectedPlace:String = "unknown"
    var selectedTakesIndex:Int = -1
    var Name:[String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PlaceTableView.delegate = self
        PlaceTableView.dataSource = self
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(PlaceTableViewController.addPlace))
        self.navigationItem.rightBarButtonItem = addButton
        
        if let path = Bundle.main.path(forResource: "Places", ofType: "json"){
            do {
                let jsonStr:String = try String(contentsOfFile:path)
                let data:Data = jsonStr.data(using: String.Encoding.utf8)!
                let dict:[String:Any] = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String:Any]
                for aPlaceName:String in dict.keys {
                    let aPlace:PlaceDescription = PlaceDescription(dict: dict[aPlaceName] as! [String:Any])
                    self.places[aPlaceName] = aPlace
                }
            } catch {
                print("contents of students.json could not be loaded")
            }
        }
        // sort so the names are listed in the table alphabetically (first name)
        //print(Array(places.keys).sorted())
        self.names = Array(places.keys).sorted()
        self.title = "Places List"
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func addPlace() {
        print("add place button clicked")
        
        //  query the user for the new student name and number. empty takes
        let promptND = UIAlertController(title: "New Place", message: "Enter Place Name & Details", preferredStyle: UIAlertController.Style.alert)
        // if the user cancels, we don't want to add a student so nil handler
        promptND.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        // setup the OK action and provide a closure to be executed when/if OK selected
        promptND.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) -> Void in
            //print("you entered name: \(String(describing: promptND.textFields?[0].text)). Number: \(String(describing: promptND.textFields?[1].text)).")
            // Want to provide default values for name and studentid
            let newPlaceName:String = (promptND.textFields?[0].text == "") ?
                "unknown" : (promptND.textFields?[0].text)!
            let newDescription:String = (promptND.textFields?[1].text == "") ?
                "unknown" : (promptND.textFields?[1].text)!
            let newCategory:String = (promptND.textFields?[2].text == "") ?
                "unknown" : (promptND.textFields?[2].text)!
            let newAddress:String = (promptND.textFields?[3].text == "") ?
                "unknown" : (promptND.textFields?[3].text)!
            // since didn't specify the keyboard, don't know whether id is empty, alpha, or numeric:
            var newElevation:Double = 0.0
            var newLatitude:Double = 0.0
            var newLongitude:Double = 0.0
            if let myNumber = NumberFormatter().number(from: (promptND.textFields?[4].text)!) {
                newElevation = myNumber.doubleValue
            }
            if let myNumber = NumberFormatter().number(from: (promptND.textFields?[5].text)!) {
                newLatitude = myNumber.doubleValue
            }
            if let myNumber = NumberFormatter().number(from: (promptND.textFields?[6].text)!) {
                newLongitude = myNumber.doubleValue
            }
            //print("creating and adding student \(newStudName) with id: \(newStudID)")
            let aPlace:PlaceDescription = PlaceDescription(name: newPlaceName, description: newDescription, category: newCategory, address: newAddress, elevation:newElevation, latitude: newLatitude, longitude: newLongitude )
            self.places[newPlaceName] = aPlace
            self.names = Array(self.places.keys).sorted()
            self.tableView.reloadData()
        }))
        promptND.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "Place Name"
        })
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
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return names.count
    }

    
    internal override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Place View Cell", for: indexPath)
        let aPlace = places[names[indexPath.row]]! as PlaceDescription
        cell.textLabel?.text = aPlace.name
        print(aPlace.name)
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        print("tableView editing row at: \(indexPath.row)")
        if editingStyle == .delete {
            let selectedPlace:String = names[indexPath.row]
            print("deleting the Place \(selectedPlace)")
            places.removeValue(forKey: selectedPlace)
            names = Array(places.keys)
            tableView.deleteRows(at: [indexPath], with: .fade)
            // don't need to reload data, using delete to make update
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("tableView didSelectRowAT \(indexPath.row)")
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "PlaceDetail", sender: names[indexPath.row])
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "PlaceDetail" {
            let viewController:ViewController = segue.destination as! ViewController
           // let indexPath = self.PlaceTableView.indexPathForSelectedRow!
            viewController.places = self.places
            viewController.names = self.names
            viewController.selectedPlace = sender as! String
        }
    }
    

}
