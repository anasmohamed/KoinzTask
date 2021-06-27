//
//  DatabseManager.swift
//  KoinzTask
//
//  Created by no one on 26/06/2021.
//

import Foundation
import RealmSwift
class DatabaseManager {
    static let shared = DatabaseManager()
    private let realm = try! Realm()
    private init() {}
    
    func delete(note: Note) {
        try! realm.write {
            realm.delete(note)
        }
    }
    
    func fetchNote(id:String) -> Note {
        return realm.object(ofType: Note.self, forPrimaryKey: id)!
    }
    func fetchNotes() -> [Note] {
        return Array(realm.objects(Note.self))
    }
    
    
    func add(note: Note) {
        debugPrint("Path to realm file: " + realm.configuration.fileURL!.absoluteString)

        try! realm.write{
            note.id = incrementID()
            realm.add(note)
        }
    }
    func deleteAll()  {
        try! realm.write {
            realm.deleteAll()
        }
    }
    private func incrementID() -> Int {
      return (realm.objects(Note.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
    func isAddedNote(_ note: Note) -> Bool {
        let notes = realm.objects(Note.self).filter("id = %@" ,note.id)
        return !notes.isEmpty
    }
}
