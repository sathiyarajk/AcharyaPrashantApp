//
//  Constant.swift
//  AcharyaPrashantApp
//
//  Created by Sathiyaraj on 04/05/24.
//

import Foundation
import UIKit


public enum URLConstant: String, CaseIterable {
    case login = "https://acharyaprashant.org/api/v2/content/misc/media-coverages?limit=100"
    
    var url: URL? {
        return URL(string: self.rawValue)
    }
}
extension ViewController{
enum Constant {
       
    static let NoInternet = "No Internet Connection!"
    static let nointernetmessage = "Need your device is connected to the internet."
    static let navigationTitle = "Acharya Prahant Images"
    static let cellName = "ImageCell"
    static let placeholderImagename = "No-Image-Placeholder.svg"
    static let ok = "OK"
}
}
