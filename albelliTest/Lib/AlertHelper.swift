//
//  AlertHelper.swift
//  albelliTest
//
//  Created by Pavle Mijatovic on 26/01/2020.
//  Copyright © 2020 albelli BV. All rights reserved.
//

import UIKit

struct AlertText {
    static let ok = "OK"
    static let cancel = "Cancel"
}

struct AlertHelper {
    
    static var topVC: UIViewController? {
        return UIApplication.shared.windows.last?.rootViewController
    }
    
    static func showInfoAlert(txt: String) {
        let userDescription = "\(txt) initiated from .html"
        let alertController = UIAlertController(title: nil, message: userDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: AlertText.ok, style: .default, handler: { (_) in }))
        topVC?.present(alertController, animated: true)
    }
    
    static func showAlert(txt: String, cancelTapped: @escaping ()->(), okTapped: @escaping ()->()) {
        let userDescription = "\(txt) was clicked, are you sure you want to go back?"
        let alertController = UIAlertController(title: nil, message: userDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: AlertText.ok, style: .default, handler: {  (_) in
            okTapped()
        }))
        
        alertController.addAction(UIAlertAction(title: AlertText.cancel, style: .cancel, handler: {  (_) in
            cancelTapped()
        }))
        
        topVC?.present(alertController, animated: true)
    }
}
