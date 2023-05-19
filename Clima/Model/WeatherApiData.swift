// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

struct WeatherApiData: Codable {
    struct Location: Codable {
        let name: String
        let region: String
        let country: String
        let lat: Double
        let lon: Double
        let tz_id: String
        let localtime_epoch: Int
        let localtime: String
    }
    
    struct Condition: Codable {
        let text: String
        let icon: String
        let code: Int
    }
    
    struct Current: Codable {
        let last_updated_epoch: Int
        let last_updated: String
        let temp_c: Double
        let temp_f: Double
        let is_day: Int
        let condition: Condition
        let wind_mph: Double
        let wind_kph: Double
        let wind_degree: Int
        let wind_dir: String
        let pressure_mb: Double
        let pressure_in: Double
        let precip_mm: Double
        let precip_in: Double
        let humidity: Int
        let cloud: Int
        let feelslike_c: Double
        let feelslike_f: Double
        let vis_km: Double
        let vis_miles: Double
        let uv: Double
        let gust_mph: Double
        let gust_kph: Double
    }
    
    let location: Location
    let current: Current
}
