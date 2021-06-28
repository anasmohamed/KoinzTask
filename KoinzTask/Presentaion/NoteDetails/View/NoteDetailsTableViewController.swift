//
//  NoteDetailsTableViewController.swift
//  KoinzTask
//
//  Created by no one on 26/06/2021.
//

import UIKit
import MapKit
import CoreLocation
import RealmSwift
class NoteDetailsTableViewController: UITableViewController  {
    
    @IBOutlet weak var noteImageView: UIImageView!
    @IBOutlet weak var addPhotoLbl: UILabel!
    @IBOutlet weak var AddNoteBtn: UIButton!
    @IBOutlet weak var noteBodyTextView: UITextView!
    @IBOutlet weak var editNoteBtn: UIButton!
    @IBOutlet weak var deleteNoteBtn: UIButton!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var noteTitleTextField: UITextField!
    let imagePicker = UIImagePickerController()

    let locationManager = CLLocationManager()
    var viewModel: NoteDetailsViewModel = NoteDetailsViewModel()
    var imagePath : String = "\(Int.random(in: 1..<100)).jpg"
    var latitude : Double = 0.0
    var longitude : Double = 0.0
    
    var note : Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let openImagePickerTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        addPhotoLbl.isUserInteractionEnabled = true
        addPhotoLbl.addGestureRecognizer(openImagePickerTap)
        
        
        let addLocationTap = UITapGestureRecognizer(target: self, action: #selector(addLoctionBtnDidTapped))
        locationLbl.isUserInteractionEnabled = true
        locationLbl.addGestureRecognizer(addLocationTap)
        
        imagePicker.delegate = self

        setupButtons()
        setupUI()
        bindData()
    }
    
    
    func setupUI(){
        guard let note = note else {
            noteBodyTextView.delegate = self
            noteBodyTextView.text = "Note Body Here"
            noteBodyTextView.textColor = UIColor.lightGray
            addPhotoLbl.isHidden = false
            noteImageView.isHidden = true
            locationLbl.isHidden = false
            editNoteBtn.isHidden = true
            deleteNoteBtn.isHidden = true
            return
        }
        noteTitleTextField.isEnabled = false
        noteBodyTextView.isEditable = false
        noteTitleTextField.text = note.title
        noteBodyTextView.text = note.details
        if note.latitude == 0.0 && note.longitude == 0.0 {
            locationLbl.textColor = UIColor.lightGray

        }else{
            locationLbl.textColor = UIColor.black

        }
        locationLbl.text = note.location
        noteImageView.isHidden = false
        AddNoteBtn.isHidden = true
        guard let image = ImageSaveing.loadImageFromDocumentDirectory(fileName: note.imagePath) else {
            addPhotoLbl.isHidden = false
            return
        }
        addPhotoLbl.isHidden = true
        noteImageView.image = image
        
    }
    func bindData() {
        viewModel.errorMessage.bind{ message in
            guard let message = message else{
                return
            }
            let deleteActionHandler: (UIAlertAction) -> Void = { _ in
               
            }
            let deleteAlertController = AlertService.showAlert(alertTitle:"Error", okBtnTitle: "OK", meassage: message , isCancel: false,actionHandler: deleteActionHandler)
            self.present(deleteAlertController, animated: true)
        }
    }
    func setupButtons()  {
        setupButtonBorder(button: AddNoteBtn)
        setupButtonBorder(button: editNoteBtn)
        setupButtonBorder(button: deleteNoteBtn)
    }
    func setupButtonBorder(button : UIButton)  {
        button.layer.cornerRadius = 8
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
    }
   
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
   
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    @objc func addLoctionBtnDidTapped(sender:UITapGestureRecognizer) {
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
    }
    @objc func openImagePicker(sender:UITapGestureRecognizer) {
        imagePicker.sourceType  = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    func navigateToNoteView() {
        let notesViewStoryboard = UIStoryboard(name: "NotesView", bundle: nil)
        let notesViewController = notesViewStoryboard.instantiateViewController(identifier: "NotesViewController") as! NotesViewController
        self.navigationController?.pushViewController(notesViewController, animated: true)
    }
    @IBAction func editNoteBtnDidTapped(_ sender: Any) {
        if editNoteBtn.titleLabel?.text == "Edit"{
            noteBodyTextView.isEditable = true
            noteTitleTextField.isEnabled = true
            noteTitleTextField.becomeFirstResponder()
            locationLbl.text = "Add Location"
            locationLbl.textColor = UIColor.lightGray
            noteImageView.isHidden = true
            addPhotoLbl.isHidden = false
            editNoteBtn.setTitle("Save", for: .normal)
        }else{
            viewModel.setNoteData(title: noteTitleTextField.text!, details: noteBodyTextView.text, location: locationLbl.text ?? "", imagePath: imagePath,latitude:latitude,longitude: longitude)
            viewModel.update(noteId: note!.id)
            editNoteBtn.setTitle("Edit", for: .normal)

        }
        
    }
    func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
    @IBAction func AddNoteBtnDidTapped(_ sender: Any) {
        viewModel.setNoteData(title: noteTitleTextField.text!, details: noteBodyTextView.text, location: locationLbl.text ?? "", imagePath: imagePath,latitude:latitude,longitude: longitude )
        
        //Here we check user's credentials input - if it's correct we call login()
        switch viewModel.credentialsInput() {
        
        case .Correct:
            addNote()
        case .Incorrect:
            return
        }
    }
    @IBAction func deleteNoteBtnDidTapped(_ sender: Any) {
        presentDeleteAlert()
        
    }
    func addNote()  {
        viewModel.addNote()
        navigateToNoteView()
    }
   
    private func presentDeleteAlert() {
        let deleteActionHandler: (UIAlertAction) -> Void = { _ in
            self.viewModel.delete(note: self.note!)
            self.navigateToNoteView()
        }
        let deleteAlertController = AlertService.showAlert(alertTitle:"Delete Note", okBtnTitle: "Delete", meassage: "Sure You Want To Delete This Note", isCancel: true,actionHandler: deleteActionHandler)
        present(deleteAlertController, animated: true)
        }
}

