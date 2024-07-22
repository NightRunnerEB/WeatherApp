//
//  WeatherCell.swift
//  WeatherApp
//
//  Created by Евгений Бухарев on 22.07.2024.
//


import UIKit

import UIKit

class WeatherCell: UICollectionViewCell {
    let weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let weatherLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.lineBreakMode = .byClipping
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(weatherImageView)
        contentView.addSubview(weatherLabel)
        
        NSLayoutConstraint.activate([
            weatherImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            weatherImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            weatherImageView.widthAnchor.constraint(equalToConstant: 40),
            weatherImageView.heightAnchor.constraint(equalToConstant: 40),
            
            weatherLabel.topAnchor.constraint(equalTo: weatherImageView.bottomAnchor, constant: 5),
            weatherLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            weatherLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            weatherLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
