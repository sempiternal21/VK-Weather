//
//  CapsuleButton.swift
//  VK-WeatherApp
//
//  Created by Danil Antonov on 23.03.2024.
//

import UIKit

class CapsuleButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let height = bounds.height
        layer.cornerRadius = height / 2
    }
}
