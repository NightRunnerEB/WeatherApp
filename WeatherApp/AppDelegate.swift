//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by Евгений Бухарев on 22.07.2024.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = WeatherViewController()
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        return true
    }
}

