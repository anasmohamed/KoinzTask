//
//  AlertService.swift
//  KoinzTask
//
//  Created by no one on 27/06/2021.
//

import Foundation
import UIKit
struct AlertService {
    static func deleteAlert(deleteActionHandler: @escaping (UIAlertAction) -> Void) -> UIAlertController {
        
        let deleteTitle = "Delete"
        
//        if numberOfProducts > 1 {
//            let products = NSLocalizedString("Products", comment: "")
//            deleteTitle = "\(delete) \(numberOfProducts) \(products)"
//        } else {
//            let product = NSLocalizedString("Product", comment: "")
//            deleteTitle = "\(delete) \(product)"
//        }
        
        let deleteAlert = UIAlertController(title: deleteTitle, message: "are you sure you want to delete this note", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: deleteActionHandler)
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        
        deleteAlert.addAction(deleteAction)
        deleteAlert.addAction(cancelAction)
        
        return deleteAlert
    }
}
