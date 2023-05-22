//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var inputCityText: UITextField!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    var weatherData: WeatherApiData?
    var cityWeatherManger = CityWeatherManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        inputCityText.delegate = self
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
}

