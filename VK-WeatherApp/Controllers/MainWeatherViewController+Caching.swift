//
//  MainWeatherViewController+Caching.swift
//  VK-WeatherApp
//
//  Created by Danil Antonov on 23.03.2024.
//

import UIKit

//MARK: Caching
extension MainWeatherViewController {
    func save(data: WeatherData) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(data)
            UserDefaults.standard.set(data, forKey: "cachedData")
        } catch let error {
            print("Error save to UserDefaults \(error.localizedDescription)")
        }
    }

    func load() -> WeatherData? {
        guard let data = UserDefaults.standard.data(forKey: "cachedData") else {
            return nil
        }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(WeatherData.self, from: data)
            return object
        } catch {
            return nil
        }
    }
}
