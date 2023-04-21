//
//  PlacesVCViewController.swift
//  FindMyPlace
//
//  Created by Eda Oner on 21.04.2023.
//

import UIKit
import Parse

class PlacesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var placeNameArray = [String]()
    var placeIdArray = [String]()
    var selectedPlaceId = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addClicked))
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: UIBarButtonItem.Style.plain, target: self, action: #selector(logoutClicked))
        
        tableView.dataSource = self
        tableView.delegate = self
        
        getDataFromParse()
    }
    
    @objc func addClicked() {
        performSegue(withIdentifier: "toAddItemVC", sender: nil)
    }

    @objc func logoutClicked() {
        
        PFUser.logOutInBackground {
            error in
            if error != nil {
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Logout failed")
                
            } else {
                // segue
                self.performSegue(withIdentifier: "toSignUpVC", sender: nil)
            }
            
        }
    }
    
    func getDataFromParse() {
        let query = PFQuery(className: "Places")
        query.findObjectsInBackground {
            objects, error in
            if error != nil {
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Could not get data")
            } else {
                if objects != nil {
                    
                    self.placeNameArray.removeAll(keepingCapacity: false)
                    self.placeIdArray.removeAll(keepingCapacity: false)
                    
                    for object in objects! {
                        if let placeName = object.object(forKey: "name") as? String {
                            if let placeId = object.objectId {
                                self.placeNameArray.append(placeName)
                                self.placeIdArray.append(placeId)
                            }
                        }
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = placeNameArray[indexPath.row]
        cell.contentConfiguration = content
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC" {
            let destination = segue.destination as! DetailsVC
            destination.chosenPlaceId = selectedPlaceId
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPlaceId = placeIdArray[indexPath.row]
        self.performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
    func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        
        alert.addAction(ok)
        self.present(alert, animated: true)
    }

}
