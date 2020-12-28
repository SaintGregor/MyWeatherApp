//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Георгий Старков on 27.12.2020.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=7cf0c476206bcb08e3ed5946ac4dd601&units=metric&lang=ru"
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let city = cityName.trimmingCharacters(in: .whitespaces)
        let urlString = "\(weatherURL)&q=\(city)".encodeUrl
        performRequest(with: urlString)
        
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)".encodeUrl
        performRequest(with: urlString)
        
    }
    
    func performRequest(with urlString: String) {
        guard let url = URL(string: urlString) else {return}
        print(url)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            guard let data = data else {delegate?.didFailWithError(error: error!); return}
            if let weather = self.parseJSON(data) {
                self.delegate?.didUpdateWeather(self, weather: weather)
            }
        }
        task.resume()
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherAPI.self, from: weatherData)
            let weather = WeatherModel(conditionId: decodedData.weather[0].id,
                                       cityName: decodedData.name,
                                       temperature: decodedData.main.temp)
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            print("Ошибка в методе parseJSON")
            return nil
        }
    }
}
