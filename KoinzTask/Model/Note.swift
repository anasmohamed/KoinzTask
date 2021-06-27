//
//  Note.swift
//  KoinzTask
//
//  Created by no one on 26/06/2021.
//

import Foundation
import RealmSwift
class Note :Object{
    @objc dynamic var id : Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var details: String = ""
    @objc dynamic var location : String = ""
    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var longitude : Double = 0.0

    @objc dynamic var imagePath : String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }

  
}
