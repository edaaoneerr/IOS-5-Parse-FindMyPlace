//
//  PlaceDetail.swift
//  FindMyPlace
//
//  Created by Eda Oner on 21.04.2023.
//
//Sınıfın icinde olusturulmus obje haric hicbir obje olusturulamaz

import Foundation
import UIKit

class PlaceDetail {
    
    static let sharedInstance = PlaceDetail()
    
    var placeName = ""
    var placeType = ""
    var placeAtmosphere = ""
    var placeImage = UIImage()
    var placeLongitude  = ""
    var placeLatitude = ""
    
    private init() {
        
    }
}
