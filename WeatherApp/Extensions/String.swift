//
//  String.swift
//  WeatherApp
//
//  Created by Георгий Старков on 27.12.2020.
//

import Foundation

extension String {
    
    var encodeUrl : String {
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
    
    var decodeUrl : String {
        return self.removingPercentEncoding!
    }
    
}
