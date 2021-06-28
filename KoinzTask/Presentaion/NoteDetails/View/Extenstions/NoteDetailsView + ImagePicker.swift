//
//  NoteDetailsView + ImagePicker.swift
//  KoinzTask
//
//  Created by no one on 27/06/2021.
//

import Foundation
import UIKit
import PhotosUI

extension NoteDetailsTableViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("\(info)")
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage{
            noteImageView.isHidden = false
            addPhotoLbl.isHidden = true
            noteImageView.image = image
            saveImage(image,imageName: "\(Int.random(in: 1..<100)).jpg")
        }
        picker.dismiss(animated: true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
  

    private func presentGoToSettingsAlert() {
        let openSettingsActionHandler: (UIAlertAction) -> Void = { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        
        let openSettingsAlertController = AlertService.showAlert(alertTitle:"Open Settings", okBtnTitle: "Open", meassage: "you need to go to app settings to give location permission",isCancel:false,actionHandler: openSettingsActionHandler)
        
        
        
        present(openSettingsAlertController, animated: true)
    }
}
