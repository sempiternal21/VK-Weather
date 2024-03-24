//
//  CurrentWeatherTableViewCell.swift
//  VK-WeatherApp
//
//  Created by Danil Antonov on 23.03.2024.
//

import UIKit

final class CurrentWeatherTableViewCell: UITableViewCell {

    var image: UIImageView = {
        var image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        
        return image
    }()
    
    var temperature: UILabel = {
        var temp = UILabel()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.font = temp.font.withSize(60)
        temp.textAlignment = .center

        return temp
    }()
    
    var city: UILabel = {
        var text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textAlignment = .center
        text.font = .systemFont(ofSize: 40, weight: .medium)
        
        return text
    }()
    
    var wind: UILabel = {
        var wind = UILabel()
        wind.translatesAutoresizingMaskIntoConstraints = false
        wind.textAlignment = .center
        
        return wind
    }()
    
    var clouds: UILabel = {
        var clouds = UILabel()
        clouds.translatesAutoresizingMaskIntoConstraints = false
        clouds.textAlignment = .center
        
        return clouds
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(image)
        contentView.addSubview(city)
        contentView.addSubview(temperature)
        contentView.addSubview(wind)
        contentView.addSubview(clouds)
        
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: topAnchor),
            image.leadingAnchor.constraint(equalTo: leadingAnchor),
            image.trailingAnchor.constraint(equalTo: trailingAnchor),
            image.bottomAnchor.constraint(equalTo: temperature.topAnchor),
            
            temperature.topAnchor.constraint(equalTo: image.bottomAnchor),
            temperature.bottomAnchor.constraint(equalTo: city.topAnchor),
            temperature.leadingAnchor.constraint(equalTo: leadingAnchor),
            temperature.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            city.topAnchor.constraint(equalTo: temperature.bottomAnchor),
            city.bottomAnchor.constraint(equalTo: wind.topAnchor),
            city.leadingAnchor.constraint(equalTo: leadingAnchor),
            city.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            wind.topAnchor.constraint(equalTo: city.bottomAnchor),
            wind.bottomAnchor.constraint(equalTo: clouds.topAnchor),
            wind.leadingAnchor.constraint(equalTo: leadingAnchor),
            wind.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            clouds.topAnchor.constraint(equalTo: wind.bottomAnchor),
            clouds.bottomAnchor.constraint(equalTo: bottomAnchor),
            clouds.leadingAnchor.constraint(equalTo: leadingAnchor),
            clouds.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
