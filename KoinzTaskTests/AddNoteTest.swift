//
//  AddNoteTest.swift
//  KoinzTaskTests
//
//  Created by no one on 27/06/2021.
//

import XCTest
@testable import KoinzTask
class AddNoteTest: XCTestCase {

    var noteDetailsViewModel : NoteDetailsViewModel!
    var note = Note()
    override func setUp() {
        noteDetailsViewModel = NoteDetailsViewModel()
        note.title = "title"
        note.details = "details"
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    func testAddNote()  {
        DatabaseManager.shared.add(note: note)
        XCTAssertNotNil(DatabaseManager.shared.fetchNotes())
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
