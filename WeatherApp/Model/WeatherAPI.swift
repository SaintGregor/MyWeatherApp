//
//  WeatherAPI.swift
//  WeatherApp
//
//  Created by Георгий Старков on 27.12.2020.
//

import Foundation

struct WeatherAPI: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable {
    let temp: Double
}

struct Weather: Decodable {
    let description: String
    let id: Int
}
