//
//  NotesViewController.swift
//  KoinzTask
//
//  Created by no one on 25/06/2021.
//

import UIKit
import CoreLocation

class NotesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
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
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bindData()

    }
    func initView() {
        self.navigationItem.title = "Notes"
        
        notesTableView.rowHeight = UITableView.automaticDimension
    }
    func bindData()  {
        viewModel.getNotesSuccess.bind{_ in
            self.notesTableView.reloadData()
        }
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
        viewModel.fetchNotes()
        
    }
}
