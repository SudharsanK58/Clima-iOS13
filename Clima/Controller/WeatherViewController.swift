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
        if textField.text == ""{
            textField.placeholder = "Enter city name"
            print("Nothing")
        }else{
            cityWeatherManger.getCityWeather(city: textField.text!) { cityName, temperature in
                // Handle the returned values here
                if let cityName = cityName, let temperature = temperature {
                    // Access and use the cityName and temperature values
                    DispatchQueue.main.async {
                        self.cityLabel.text = cityName
                        self.temperatureLabel.text = "\(temperature)"
                    }
                } else {
                    // Handle the case when cityName or temperature is nil
                    print("Failed to retrieve city weather.")
                }
            }
        }
            inputCityText.text = ""
        }
    
}

