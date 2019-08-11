//
//  Networking.swift
//  OpenWeatherApp
//
//  Created by Tony Cioara on 8/11/19.
//  Copyright © 2019 Tony Cioara. All rights reserved.
//

import Foundation

enum Route {
    
    case getWeather
    
    func method() -> String {
        switch self {
        case .getWeather:
            return "GET"
        }
    }
    
    func path() -> String {
        switch self {
        case .getWeather:
            return "data/2.5/weather?q=London,uk&APPID="
        }
    }
}

class Network {
    static let shared = Network()
//    https://api.openweathermap.org/data/2.5/weather?q=London,uk&APPID=85377426bc02d6ee4f4c7d5e847a102b
    let APIKey = "85377426bc02d6ee4f4c7d5e847a102b"
    let baseURL = "https://samples.openweathermap.org/"
    let session = URLSession.shared
    
    func fetch(route: Route, completion: @escaping (Data) -> Void) {
        let fullPath = baseURL + route.path() + APIKey
        let pathURL = URL(string: fullPath)
        var request = URLRequest(url: pathURL!)
        
        request.httpMethod = route.method()
        
        session.dataTask(with: request) { (data, resp, err) in
            //                print(String(describing: data) + String(describing: resp) + String(describing: err))
            //                print(String(describing: resp))
            if let data = data {
                completion(data)
            }
            
            }.resume()
    }
}
