//
//  ImageHelper.swift
//  VK-WeatherApp
//
//  Created by Danil Antonov on 23.03.2024.
//

import Foundation

class ImageHelper {
    class func getImageNameIconForWeatherStatus(status: String) -> String {
        switch status {
        case "Clouds":
            return "cloud"
        case "Rain":
            return "cloud.rain"
        case "Snow":
            return "cloud.snow"
        case "Clear":
            return "sun.max"
        default:
            return "exclamationmark.icloud"
        }
    }
}
