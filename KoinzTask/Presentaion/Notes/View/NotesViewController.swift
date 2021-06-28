//
//  NotesViewController.swift
//  KoinzTask
//
//  Created by no one on 25/06/2021.
//

import UIKit
import CoreLocation

class NotesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var addFirstNoteBtn: UIButton!
    @IBOutlet weak var addFirstNoteStackView: UIStackView!
    let locationManager = CLLocationManager()
    var latitude : Double = 0.0
    var longitude : Double = 0.0
    @IBOutlet weak var notesTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    lazy var viewModel: NoteListViewModel = {
        return NoteListViewModel()
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        notesTableView.delegate = self
        notesTableView.dataSource = self
        setupTableView()
        initView()
        bindData()
        
        locationManager.delegate = self
        getLocationPermission()
        
        //        locationManager.startUpdatingLocation()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    func initView() {
        self.navigationItem.title = "Notes"
        addFirstNoteBtn.layer.borderWidth = 1
        addFirstNoteBtn.layer.cornerRadius = 8
        addFirstNoteBtn.layer.borderColor = UIColor.black.cgColor
        notesTableView.rowHeight = UITableView.automaticDimension
        self.navigationItem.setHidesBackButton(true, animated: true)
        
    }
    func getLocationPermission()  {
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
    func bindData()  {
        viewModel.getNotesSuccess.bind{_ in
            self.notesTableView.isHidden = false
            self.addFirstNoteStackView.isHidden = true
            self.notesTableView.reloadData()
        }
        viewModel.emptyNotes.bind{ status in
            if status {
                self.notesTableView.isHidden = true
                self.addFirstNoteStackView.isHidden = false
            }
        }
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
    func setupTableView() {
        notesTableView.register(UINib(nibName: "NoteTableViewCell", bundle: nil), forCellReuseIdentifier: "NoteTableViewCell")
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteTableViewCell", for:indexPath) as! NoteTableViewCell
        
        let cellVM = viewModel.getCellViewModel(at: indexPath)
        cell.noteListCellViewModel = cellVM
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let noteDetailsStoryboard = UIStoryboard(name: "NoteDetailsView", bundle: nil)
        let noteDetailsViewController = noteDetailsStoryboard.instantiateViewController(identifier: "NoteDetailsTableViewController") as! NoteDetailsTableViewController
        noteDetailsViewController.note = viewModel.getData(index: indexPath.row)
        self.navigationController?.pushViewController(noteDetailsViewController, animated: true)
    }
    
    
}
extension NotesViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        longitude = locValue.longitude
        latitude = locValue.latitude
        viewModel.updateLocation(latitude: latitude, longitude: longitude)
        locationManager.delegate = nil
        viewModel.fetchNotes()
    }
    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if CLLocationManager.locationServicesEnabled() {
            switch locationManager.authorizationStatus {
            case .notDetermined, .restricted, .denied:
                print("No access")
                presentGoToSettingsAlert()
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
                
            @unknown default:
                break
            }
        } else {
            print("Location services are not enabled")
        }
    }
}
