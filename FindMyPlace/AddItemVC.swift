//
//  PlaceDetailVC.swift
//  FindMyPlace
//
//  Created by Eda Oner on 21.04.2023.
//

import UIKit

class AddItemVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var placeNameText: UITextField!
    
    
    @IBOutlet weak var placeTypeText: UITextField!
    
    
    @IBOutlet weak var placeAtmosphereText: UITextField!
    
    
    @IBOutlet weak var placeImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        placeImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        placeImageView.addGestureRecognizer(gestureRecognizer)
    }
    

    @IBAction func nextClicked(_ sender: Any) {
        
        if placeNameText.text != "" && placeTypeText.text != "" && placeAtmosphereText.text != "" {
            if let chosenImage = placeImageView.image {
                let placeDetail = PlaceDetail.sharedInstance
                placeDetail.placeName = placeNameText.text!
                placeDetail.placeType = placeTypeText.text!
                placeDetail.placeAtmosphere = placeAtmosphereText.text!
                placeDetail.placeImage = chosenImage
            }
            performSegue(withIdentifier: "toMapVC", sender: nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "Place Name/Type/Atmosphere??", preferredStyle: UIAlertController.Style.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
            alert.addAction(ok)
            self.present(alert, animated: true)
        }
        
    }
    
    @objc func chooseImage() {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        placeImageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }
    
}
