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
        bindData()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        // Do any additional setup after loading the view.
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
