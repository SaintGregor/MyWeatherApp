//
//  ViewController.swift
//  WeatherApp
//
//  Created by Георгий Старков on 27.12.2020.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startActivityIndicator()
 
        locationManager.delegate = self
        weatherManager.delegate = self
        searchTextField.delegate = self
        
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        startActivityIndicator()
    }
    
    @IBAction func findMyLocationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
        startActivityIndicator()
    }
    
    func startActivityIndicator() {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
    }
    
    func stopActivityIndicator() {
        self.activityIndicator.isHidden = true
        self.activityIndicator.stopAnimating()
    }
    
}

// MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        startActivityIndicator()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        guard (textField.text != nil) else {textField.placeholder = "Type something"; return false}
        startActivityIndicator()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            startActivityIndicator()
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
    }
}

// MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
//            self.temperatureLabel.text = String(weather.temperature)
            self.temperatureLabel.text = String(format: "%.1f", weather.temperature)
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    }
    
    func didFailWithError(error: Error) {
        print("Не получилось здагрузить погоду по городу", error)
        DispatchQueue.main.async {
            self.stopActivityIndicator()
            let alertController = UIAlertController(title: "Ошибка", message: "К сожалению, мы не можем найти погоду по данному городу.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ок", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
}

// MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
            stopActivityIndicator()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Ошибка в методе didFailWithError of CLLocation...Delegate", error)
    }
}
