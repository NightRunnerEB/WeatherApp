//
//  String+Extension.swift
//  WeatherApp
//
//  Created by Евгений Бухарев on 22.07.2024.
//

import Foundation

extension String {
    
    var localized: String {
        NSLocalizedString(self, comment: self)
    }
}
