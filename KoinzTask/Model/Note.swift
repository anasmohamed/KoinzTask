//
//  Note.swift
//  KoinzTask
//
//  Created by no one on 26/06/2021.
//

import Foundation
import RealmSwift
class Note :Object{
    @objc dynamic var id : String?
    @objc dynamic var title: String?
    @objc dynamic var details: String?
    @objc dynamic var location : String?
    @objc dynamic var imagePath : String?    
}
