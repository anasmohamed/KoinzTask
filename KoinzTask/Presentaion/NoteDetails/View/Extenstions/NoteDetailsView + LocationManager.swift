//
//  NoteDetailsView + LocationManager.swift
//  KoinzTask
//
//  Created by no one on 27/06/2021.
//

import Foundation
import CoreLocation
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
