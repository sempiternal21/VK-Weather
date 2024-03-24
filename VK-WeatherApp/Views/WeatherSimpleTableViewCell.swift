//
//  WeatherSimpleTableViewCell.swift
//  VK-WeatherApp
//
//  Created by Danil Antonov on 23.03.2024.
//

import UIKit

final class WeatherSimpleViewCell: UITableViewCell {

    var date: UILabel = {
        var dt = UILabel()
        dt.translatesAutoresizingMaskIntoConstraints = false
        
        return dt
    }()
    
    var image: UIImageView = {
        var image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        
        return image
    }()
    
    var descriptionWeather: UILabel = {
        var desc = UILabel()
        desc.translatesAutoresizingMaskIntoConstraints = false
        
        return desc
    }()
    
    var temperature: UILabel = {
        var temp = UILabel()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.font = temp.font.withSize(20)
        temp.font = .systemFont(ofSize: 20, weight: .semibold)
        
        return temp
    }()
    
    var infoStack: UIStackView = {
        var infoStack = UIStackView()
        infoStack.translatesAutoresizingMaskIntoConstraints = false
        infoStack.spacing = 20
        
        return infoStack
    }()
    
    var stack: UIStackView = {
        var stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .equalCentering
        stack.spacing = 20
        
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        infoStack.addArrangedSubview(image)
        infoStack.addArrangedSubview(descriptionWeather)
        contentView.addSubview(stack)
        stack.addArrangedSubview(date)
        stack.addArrangedSubview(infoStack)
        stack.addArrangedSubview(temperature)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
