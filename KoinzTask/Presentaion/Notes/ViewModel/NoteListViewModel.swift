//
//  NotesViewModel.swift
//  KoinzTask
//
//  Created by no one on 25/06/2021.
//

import Foundation
import CoreLocation
class NoteListViewModel {
    private var notes: [Note] = [Note]()
    private var finalNotes = [Note]()
    private var cellViewModels : [NoteListCellViewModel] = [NoteListCellViewModel](){
        didSet{
            getNotesSuccess.value = notes
        }
    }
    
    
    var numberOfItems: Int {
        return notes.count
    }
    
    var latitude = 0.0
    var longitude = 0.0
    var distancesInMeter = [CLLocationDistance:Int]()
    var getNotesSuccess: Observable<[Note]> = Observable([])
    var emptyNotes: Observable<Bool> = Observable(false)
    
    func updateLocation(latitude:Double,longitude:Double)  {
        self.latitude = latitude
        self.longitude = longitude
    }
    func getDistanceBetweenUserLocationAndNoteLocation() {
        for note in notes {
            let coordinate₀ = CLLocation(latitude: latitude, longitude: longitude)
            let coordinate₁ = CLLocation(latitude: note.latitude, longitude: longitude)
            let distance = coordinate₀.distance(from: coordinate₁)
            distancesInMeter[distance] = note.id
        }
    }
    func fetchNotes() {
        notes = DatabaseManager.shared.fetchNotes()
        print(notes.count)
        if notes.count == 0 {
            emptyNotes.value = true
        }else{
            self.processFetchedNotes(notes: notes)
        }
        
    }
    
    func createCellViewModel( note: Note ) -> NoteListCellViewModel {
        
        //Wrap a description
        var hasGPS = false
        var hasImage = false
        var nearest = ""
        
        if note.id == distancesInMeter[distancesInMeter.keys.min() ?? 0]{
            nearest = "Nearest"
        }
        if note.latitude == 0.0 && note.longitude == 0.0 {
            hasGPS = false
        }else{
            hasGPS = true
        }
        
        if note.imagePath.isEmpty {
            hasImage = false
        }else{
            hasImage = true
        }
        
        return NoteListCellViewModel(noteTitle: note.title, noteBody: note.details, nearestNote: nearest, hasImage: hasImage, hasGPS: hasGPS)
    }
    private func processFetchedNotes( notes: [Note] ) {
        self.notes = notes // Cache
        var vms = [NoteListCellViewModel]()
        getDistanceBetweenUserLocationAndNoteLocation()
        let sortedNotes = notes.sorted { $0.creationDate < $1.creationDate }
        for note in sortedNotes {
            if note.id == distancesInMeter[distancesInMeter.keys.min() ?? 0]{
                vms.insert(createCellViewModel(note:note), at: 0)
                self.finalNotes.insert(note, at: 0)
            }else{
                self.finalNotes.append(note)
                vms.append( createCellViewModel(note:note) )}
        }
        
        self.cellViewModels = vms
    }
    func getData(index: Int) -> Note {
        print(notes.count)

        return finalNotes[index]
    }
    func getCellViewModel( at indexPath: IndexPath ) -> NoteListCellViewModel {
        return cellViewModels[indexPath.row]
    }
    
    func getNotes()-> [Note] {
        DatabaseManager.shared.fetchNotes()
    }
}
