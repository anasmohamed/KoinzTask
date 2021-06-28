//
//  AlertService.swift
//  KoinzTask
//
//  Created by no one on 27/06/2021.
//

import Foundation
import UIKit
struct AlertService {
    static func showAlert(alertTitle:String,okBtnTitle:String,meassage:String,isCancel: Bool,actionHandler: @escaping (UIAlertAction) -> Void) -> UIAlertController {
        
        
        
        let alert = UIAlertController(title: alertTitle, message: meassage, preferredStyle: .alert)
        let action = UIAlertAction(title: okBtnTitle, style: .default, handler: actionHandler)
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        
        alert.addAction(action)
        if isCancel{
        alert.addAction(cancelAction)
        }
        return alert
    }
}
