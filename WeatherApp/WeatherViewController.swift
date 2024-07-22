//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Евгений Бухарев on 22.07.2024.
//

import UIKit

class WeatherViewController: UIViewController {

    let weatherTypes = [
        ("Sunny", NSLocalizedString("Sunny", comment: ""), "sun.max.fill", UIColor.yellow),
        ("Rainy", NSLocalizedString("Rainy", comment: ""), "drop.fill", UIColor.blue),
        ("Stormy", NSLocalizedString("Stormy", comment: ""), "cloud.bolt.rain.fill", UIColor.gray),
        ("Foggy", NSLocalizedString("Foggy", comment: ""), "cloud.fog.fill", UIColor.lightGray),
        ("Snowy", NSLocalizedString("Snowy", comment: ""), "snowflake", UIColor.cyan),
        ("Windy", NSLocalizedString("Windy", comment: ""), "wind", UIColor.green),
        ("Thunderstorm", NSLocalizedString("Thunderstorm", comment: ""), "cloud.bolt.fill", UIColor.darkGray)
    ]

    var selectedWeatherIndexPath: IndexPath?
    let selectionIndicator = UIView()

    let weatherCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    let weatherAnimationView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCollectionView()
        setupWeatherAnimationView()
        setupSelectionIndicator()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        displayRandomWeather()
    }

    private func setupCollectionView() {
        view.addSubview(weatherCollectionView)
        weatherCollectionView.dataSource = self
        weatherCollectionView.delegate = self
        weatherCollectionView.register(WeatherCell.self, forCellWithReuseIdentifier: "WeatherCell")
        
        NSLayoutConstraint.activate([
            weatherCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            weatherCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weatherCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            weatherCollectionView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }

    private func setupWeatherAnimationView() {
        view.addSubview(weatherAnimationView)
        
        NSLayoutConstraint.activate([
            weatherAnimationView.topAnchor.constraint(equalTo: weatherCollectionView.bottomAnchor),
            weatherAnimationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weatherAnimationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            weatherAnimationView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupSelectionIndicator() {
        selectionIndicator.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        selectionIndicator.layer.cornerRadius = 20
        selectionIndicator.layer.borderWidth = 2
        selectionIndicator.layer.borderColor = UIColor.white.cgColor
        selectionIndicator.translatesAutoresizingMaskIntoConstraints = false
        weatherCollectionView.addSubview(selectionIndicator)
    }

    private func displayRandomWeather() {
        let randomIndex = Int(arc4random_uniform(UInt32(weatherTypes.count)))
        let randomWeather = weatherTypes[randomIndex]
        selectedWeatherIndexPath = IndexPath(item: randomIndex, section: 0)
        weatherCollectionView.selectItem(at: selectedWeatherIndexPath, animated: false, scrollPosition: .centeredHorizontally)
        updateSelectionIndicator()
        displayWeatherAnimation(weather: randomWeather.0, color: randomWeather.3)
    }

    private func displayWeatherAnimation(weather: String, color: UIColor) {

        weatherAnimationView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        weatherAnimationView.subviews.forEach { $0.removeFromSuperview() }

        view.backgroundColor = color.withAlphaComponent(0.1)
        weatherCollectionView.backgroundColor = color.withAlphaComponent(0.02)

        switch weather {
        case "Sunny":
            createFallingEmojiAnimation(imageName: "sun.max.fill", color: .yellow)
        case "Rainy":
            createFallingEmojiAnimation(imageName: "drop.fill", color: .blue)
        case "Stormy":
            createFallingEmojiAnimation(imageName: "cloud.bolt.rain.fill", color: .gray)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.createFallingEmojiAnimation(imageName: "drop.fill", color: .blue)
            }
        case "Foggy":
            createFallingEmojiAnimation(imageName: "cloud.fog.fill", color: .lightGray)
        case "Snowy":
            createFallingEmojiAnimation(imageName: "snowflake", color: .cyan)
        case "Windy":
            createFallingEmojiAnimation(imageName: "wind", color: .green)
        case "Thunderstorm":
            createFallingEmojiAnimation(imageName: "bolt.fill", color: .yellow)
        default:
            break
        }
    }

    private func createFallingEmojiAnimation(imageName: String, color: UIColor) {
        guard let image = UIImage(systemName: imageName)?.withTintColor(color, renderingMode: .alwaysOriginal),
              let coloredImage = imageWithColor(image: image, color: color) else {
            return
        }

        let emitterLayer = CAEmitterLayer()
        emitterLayer.emitterShape = .line
        emitterLayer.emitterPosition = CGPoint(x: weatherAnimationView.bounds.width / 2, y: -50)
        emitterLayer.emitterSize = CGSize(width: weatherAnimationView.bounds.width, height: 1)

        let cell = CAEmitterCell()
        cell.contents = coloredImage.cgImage
        cell.birthRate = 10
        cell.lifetime = 5.0
        cell.velocity = 150
        cell.velocityRange = 30
        cell.emissionLongitude = .pi
        cell.scale = 0.2
        cell.scaleRange = 0.05

        emitterLayer.emitterCells = [cell]
        weatherAnimationView.layer.addSublayer(emitterLayer)
    }

    private func imageWithColor(image: UIImage, color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        color.setFill()

        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: image.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(.normal)

        let rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        context?.clip(to: rect, mask: image.cgImage!)
        context?.fill(rect)

        let coloredImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return coloredImage
    }

    private func updateSelectionIndicator() {
        guard let selectedIndexPath = selectedWeatherIndexPath,
              let selectedCell = weatherCollectionView.cellForItem(at: selectedIndexPath) else {
            selectionIndicator.isHidden = true
            return
        }

        selectionIndicator.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.selectionIndicator.frame = selectedCell.frame.insetBy(dx: -10, dy: -10)
        }

        weatherCollectionView.scrollToItem(at: selectedIndexPath, at: .centeredHorizontally, animated: true)
    }
}

extension WeatherViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath) as! WeatherCell
        let weatherType = weatherTypes[indexPath.item]
        cell.weatherLabel.text = NSLocalizedString(weatherType.0, comment: "")
        cell.weatherImageView.image = UIImage(systemName: weatherType.2)?.withTintColor(weatherType.3, renderingMode: .alwaysOriginal)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedWeatherIndexPath = indexPath
        updateSelectionIndicator()
        let selectedWeather = weatherTypes[indexPath.item]
        displayWeatherAnimation(weather: selectedWeather.0, color: selectedWeather.3)
    }
}
