//
//  NoteDetailsViewModel.swift
//  KoinzTask
//
//  Created by no one on 26/06/2021.
//

import Foundation
class NoteDetailsViewModel {
    
    
    
    private var note = Note()
    private var title = ""
    private var details = ""
    private var location = ""
    private var imagePath = ""
    
    var errorMessage: Observable<String?> = Observable(nil)
    
    
    func setNoteData(title:String,details:String,location:String,imagePath:String,latitude:Double,longitude:Double)  {
        note.title = title
        note.details = details
        note.location = location
        note.imagePath = imagePath
        note.latitude = latitude
        note.longitude = longitude
        note.creationDate = getCreationDate()
    }
    func getCreationDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        return          formatter.string(from: Date())
        
    }
    func addNote() {
        DatabaseManager.shared.add(note: note)
    }
    func getData()->[Note]  {
        return DatabaseManager.shared.fetchNotes()
    }
    func delete(note:Note)  {
        DatabaseManager.shared.delete(note: note)
    }
    func update(noteId : Int)  {
        note.id = noteId
        DatabaseManager.shared.update(note: note)
    }
    func credentialsInput() -> CredentialsInputStatus {
        if note.title.isEmpty {
            errorMessage.value = "Password should be 6 digits or more"
            return .Incorrect
            
        }
        if note.details.isEmpty {
            errorMessage.value = "email field is empty."
            return .Incorrect
        }
        
        
        return .Correct
    }
}
extension NoteDetailsViewModel{
    enum CredentialsInputStatus {
        case Correct
        case Incorrect
    }
}
