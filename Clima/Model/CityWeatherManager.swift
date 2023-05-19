//
//  CityWeatherManager.swift
//  Clima
//
//  Created by Sudharsan on 18/05/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

struct CityWeatherManager {
    
    func getCityWeather(city: String,completion: @escaping (String?, Double?) -> Void) {
        let city = city // Replace with the city you want to retrieve weather for

        guard let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("Invalid city name")
            completion(nil, nil)
            return
        }

        let urlString = "https://api.weatherapi.com/v1/current.json?key=27dc28c8f8e648ce998110334231805&q=\(encodedCity)"

        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(nil, nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(nil, nil)
                return
            }

            guard let data = data else {
                print("No data received")
                completion(nil, nil)
                return
            }

            do {
                let decoder = JSONDecoder()
                let weatherData = try decoder.decode(WeatherApiData.self, from: data)
                let cityName = weatherData.location.name
                let temperature = weatherData.current.temp_c
                completion(cityName, temperature)
            } catch {
                print(String(data: data, encoding: .utf8)!)
                print("City: \(encodedCity)")
                print("Error decoding data: \(error.localizedDescription)")
                completion(nil, nil)
            }
        }.resume()
    }
    
}
