//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController, UITextFieldDelegate,CLLocationManagerDelegate{
    
    @IBOutlet weak var inputCityText: UITextField!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    var weatherData: WeatherApiData?
    var cityWeatherManger = CityWeatherManager()
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        inputCityText.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
    }
    
    
    @IBAction func citySearch(_ sender: UIButton) {
        inputCityText.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        inputCityText.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = textField.text, !city.isEmpty {
            cityWeatherManger.getCityWeather(city: city) { cityName, temperature, iconURL in
                DispatchQueue.main.async {
                    if let cityName = cityName, let temperature = temperature {
                        self.cityLabel.text = cityName
                        self.temperatureLabel.text = "\(temperature)"
                        
                        if let iconURL = iconURL {
                            URLSession.shared.dataTask(with: iconURL) { data, response, error in
                                if let data = data {
                                    DispatchQueue.main.async {
                                        self.conditionImageView.image = UIImage(data: data)
                                    }
                                }
                            }.resume()
                        }
                    } else {
                        print("Failed to retrieve city weather.")
                    }
                }
            }

        } else {
            textField.placeholder = "Enter city name"
        }
        textField.text = ""
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let updatedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
            if let searchText = updatedText, searchText.count >= 3 {
                cityWeatherManger.fetchAutocompleteResults(searchText: searchText)
            }
            
            return true
        }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            print("Location permission granted.")
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            print("Location permission denied.")
            showLocationPermissionDeniedAlert()
            // Handle denied or restricted case
        case .notDetermined:
            print("Location permission not determined.")
            // Handle not determined case
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        if let location = locations.last {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            print("Latitude: \(latitude), Longitude: \(longitude)")
            // Use the latitude and longitude values as needed
        }
    }
    
    func showLocationPermissionDeniedAlert() {
        let alert = UIAlertController(title: "Location Access Denied", message: "Please grant permission to access your location in the app settings.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
            // Open app settings
            if let appSettingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettingsURL, options: [:], completionHandler: nil)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }


}

