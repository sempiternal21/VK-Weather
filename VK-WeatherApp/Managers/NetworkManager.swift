//
//  NetworkManager.swift
//  VK-WeatherApp
//
//  Created by Danil Antonov on 19.03.2024.
//

import Foundation

enum FirstApiResult {
    case success(response: WeatherData)
    case failure(error: Error)
}

class NetworkManager {
    let baseUrl = BaseUrl.baseWeatherMapUrl
    let token = Tokens.openWeatherToken
    let path = "/data/2.5/forecast"
    
    func fetchServerStatus(lat: String, lon: String) async -> FirstApiResult {
        var components = URLComponents()
        components.scheme = "https"
        components.host = baseUrl
        components.path = path

        components.queryItems = [
            URLQueryItem(name: "lat", value: lat),
            URLQueryItem(name: "lon", value: lon),
            URLQueryItem(name: "appid", value: token),
            URLQueryItem(name: "units", value: "metric"),
        ]
        
        do {
            let (data, _) = try await URLSession.shared.data(from: URL(string: components.string!)!)
            let result = try JSONDecoder().decode(WeatherData.self, from: data)
            return .success(response: result)
        } catch {
            return .failure(error: error)
        }
    }
}
