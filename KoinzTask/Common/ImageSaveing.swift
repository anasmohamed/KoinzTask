//
//  ImageSaveing.swift
//  KoinzTask
//
//  Created by no one on 27/06/2021.
//

import Foundation
import UIKit
class ImageSaveing {
    public static func loadImageFromDocumentDirectory(fileName: String) -> UIImage? {
        
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!;
        let fileURL = documentsUrl.appendingPathComponent(fileName)
        print(fileURL)
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {}
        return nil
    }
   static func documentDirectoryPath() -> URL? {
        let path = FileManager.default.urls(for: .documentDirectory,
                                            in: .userDomainMask)
        return path.first
    }
  public static func saveImage(_ image: UIImage,imageName:String) {
        if let jpgData = image.jpegData(compressionQuality: 0.5),
           let path = documentDirectoryPath()?.appendingPathComponent(imageName) {
            try? jpgData.write(to: path)
        }
    }
}
