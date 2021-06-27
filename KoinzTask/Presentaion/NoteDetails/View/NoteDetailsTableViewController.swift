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
    
    let locationManager = CLLocationManager()
    var viewModel: NoteDetailsViewModel = NoteDetailsViewModel()
    var imagePath : String = ""
    var latitude : Double = 0.0
    var longitude : Double = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapFunction))
        addPhotoLbl.isUserInteractionEnabled = true
        addPhotoLbl.addGestureRecognizer(tap)
        let addLocationTap = UITapGestureRecognizer(target: self, action: #selector(addLoctionBtnDidTapped))
        locationLbl.isUserInteractionEnabled = true
        locationLbl.addGestureRecognizer(addLocationTap)
       
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    func documentDirectoryPath() -> URL? {
        let path = FileManager.default.urls(for: .documentDirectory,
                                            in: .userDomainMask)
        return path.first
    }
    // MARK: - Table view data source
    func saveJpg(_ image: UIImage) {
        if let jpgData = image.jpegData(compressionQuality: 0.5),
            let path = documentDirectoryPath()?.appendingPathComponent("exampleJpg.jpg") {
            imagePath = path.absoluteString
            try? jpgData.write(to: path)
        }
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
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        let vc = UIImagePickerController()
        vc.sourceType  = .photoLibrary
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    @IBAction func editNoteBtnDidTapped(_ sender: Any) {
    }
    @IBAction func AddNoteBtnDidTapped(_ sender: Any) {
        viewModel.setNoteData(title: noteTitleTextField.text!, details: noteBodyTextView.text, location: locationLbl.text ?? "", imagePath: imagePath,latitude:latitude,longitude: longitude )
               
               //Here we check user's credentials input - if it's correct we call login()
               switch viewModel.credentialsInput() {
               
               case .Correct:
                viewModel.addNote()
               case .Incorrect:
                   return
               }
    }
    @IBAction func deleteNoteBtnDidTapped(_ sender: Any) {
    }

}
extension NoteDetailsTableViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("\(info)")
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage{
            noteImageView.isHidden = false
            noteImageView.image = image
            saveJpg(image)
        }
        picker.dismiss(animated: true, completion: nil)

    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
extension NoteDetailsTableViewController : CLLocationManagerDelegate {
   
    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.locality,
                       placemarks?.first?.country,
                       error)
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocation = manager.location else { return }
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        fetchCityAndCountry(from: location) { city, country, error in
            guard let city = city, let country = country, error == nil else { return }
            self.locationLbl.text = city + ", " + country
            print(city + ", " + country)
        }
    }
}
