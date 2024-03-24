//
//  ViewController.swift
//  VK-WeatherApp
//
//  Created by Danil Antonov on 19.03.2024.
//

import UIKit
import MapKit

final class MainWeatherViewController: UIViewController {
    private let weatherTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = Resources.defaultBackgroundColor
        
        return tableView
    }()
    private let changeLocationButton: UIButton = {
        let button = CapsuleButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Strings.selectOtherLocation, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = button.titleLabel?.font.withSize(20)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 30
        
        return button
    }()
    var placeDeviceLabel: UILabel = {
        var placeDevice = UILabel()
        placeDevice.translatesAutoresizingMaskIntoConstraints = false
        placeDevice.textAlignment = .center
        
        return placeDevice
    }()
    private let activityView = UIActivityIndicatorView(style: .medium)
    
    private let networkManager = NetworkManager()
    private var weatherDataResponse: WeatherData!
    private var dataWeatherTableView = [List]()
    
    private let mainCellIdentifier = "mainCellIdentifier"
    private let secondaryCellIdentifier = "secondaryCellIdentifier"
    
    private var location: (String, String)!

    //MARK: viewDidLoad
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(changeLabelText), name: Notification.Name("closeChangeLocationVC"), object: nil)
        DispatchQueue.main.async {
            if !LocationManager.shared.haveAccessToLocation() {
                let alert = UIAlertController(title: Strings.giveLocationAccess, message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: Strings.ok, style: .default))
                self.present(alert, animated: true, completion: nil)
            }
        }
        LocationManager.shared.getCurrentLocation { location in
            
            self.location = (location.coordinate.latitude.description, location.coordinate.longitude.description)
            
            self.reverseGeocoding(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            
            Task {
                let responseApiResult = await self.networkManager.fetchServerStatus(lat: self.location.0, lon: self.location.1)
                
                switch responseApiResult {
                case .success(response: let response):
                    self.dataWeatherTableView = response.list
                    self.weatherDataResponse = response
                    self.weatherDataResponse.list = response.list
                    self.dataWeatherTableView = ApiResponseTransformHelper.getWeeklyWeatherLise(r: response)
                    self.dataWeatherTableView = ApiResponseTransformHelper.getFormattingDataList(arr: self.dataWeatherTableView)
                    var toSave = self.weatherDataResponse
                    toSave?.list = self.dataWeatherTableView
                    self.save(data: toSave!)
                    DispatchQueue.main.async { [self] in
                        self.weatherTableView.reloadData()
                        weatherTableView.backgroundView = nil
                    }
                case .failure(error: let e):
                    self.weatherDataResponse = self.load()
                    self.dataWeatherTableView = self.weatherDataResponse.list
                    if self.dataWeatherTableView.count > 0 {
                        self.weatherTableView.reloadData()
                        self.weatherTableView.backgroundView = nil
                    } else {
                        print(e.localizedDescription)
                    }
                }
            }
        }
        super.viewDidLoad()
        setupUI()
        
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
        weatherTableView.register(WeatherSimpleViewCell.self, forCellReuseIdentifier: mainCellIdentifier)
        weatherTableView.register(CurrentWeatherTableViewCell.self, forCellReuseIdentifier: secondaryCellIdentifier)
        
        changeLocationButton.addTarget(self, action: #selector(openFindPlaceVC), for: .touchUpInside)
    }
    
    private func setupUI() {
        view.addSubview(weatherTableView)
        view.addSubview(changeLocationButton)
        view.addSubview(placeDeviceLabel)
        
        NSLayoutConstraint.activate([
            weatherTableView.topAnchor.constraint(equalTo: view.topAnchor),
            weatherTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weatherTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            weatherTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            changeLocationButton.heightAnchor.constraint(equalToConstant: 50),
            changeLocationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            changeLocationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            changeLocationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            placeDeviceLabel.bottomAnchor.constraint(equalTo: changeLocationButton.topAnchor, constant: -10),
            placeDeviceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            placeDeviceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func getLocation() {
        LocationManager.shared.getCurrentLocation { location in
            self.location = (location.coordinate.latitude.description, location.coordinate.longitude.description)
            self.reverseGeocoding(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
    }
    
    func reverseGeocoding(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
            let geocoder = CLGeocoder()
            let location = CLLocation(latitude: latitude, longitude: longitude)
            geocoder.reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
                if error != nil {
                    print("Failed to retrieve address")
                    return
                }
                if let placemarks = placemarks, let placemark = placemarks.first {
                    self.placeDeviceLabel.text = Strings.devicePlace + (placemark.administrativeArea ?? "")
                }
                else {
                    print("No Matching Address Found")
                }
            })
        }
    
    @objc func changeLabelText(notification: NSNotification) {
        self.dismiss(animated: true, completion: nil)

        let dataDict = notification.object as! FindModel

        let alert = UIAlertController(title: Strings.changePlaceAlertTitle, message: "\(Strings.changePlaceAlertDescription) \(dataDict.place)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Strings.ok, style: .default))
        self.present(alert, animated: true, completion: nil)
        Task {
            self.weatherTableView.backgroundView = activityView
            activityView.startAnimating()
            let responseApiResult = await networkManager.fetchServerStatus(lat: dataDict.lat, lon: dataDict.lon)
            switch responseApiResult {
            case .success(response: let response):
                dataWeatherTableView = response.list
                weatherDataResponse = response
                dataWeatherTableView = ApiResponseTransformHelper.getWeeklyWeatherLise(r: response)
                dataWeatherTableView = ApiResponseTransformHelper.getFormattingDataList(arr: dataWeatherTableView)
                var toSave = weatherDataResponse
                toSave?.list = dataWeatherTableView
                save(data: toSave!)
                
                DispatchQueue.main.async { [self] in
                    self.weatherTableView.reloadData()
                    weatherTableView.backgroundView = nil
                }
            case .failure(error: let e):
                weatherDataResponse = load()
                dataWeatherTableView = weatherDataResponse.list
                self.weatherTableView.reloadData()
                weatherTableView.backgroundView = nil
                print(e.localizedDescription)
            }
        }
    }
    
    @objc func openFindPlaceVC() {
        show(FindPlaceViewController(), sender: self)
    }
}

//MARK: UITableViewDataSource
extension MainWeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataWeatherTableView.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            var height:CGFloat = CGFloat()
            if indexPath.row == 0 {
                height = 250
            }
            else {
                height = 50
            }
            return height
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: secondaryCellIdentifier, for: indexPath) as! CurrentWeatherTableViewCell
            if weatherDataResponse.list.first!.main.temp > 0 {
                cell.temperature.text = "+" + String(format: "%.1f", weatherDataResponse.list.first!.main.temp)
            } else {
                cell.temperature.text = String(format: "%.1f", weatherDataResponse.list.first!.main.temp)
            }

            cell.image.image = UIImage(systemName: ImageHelper.getImageNameIconForWeatherStatus(status: dataWeatherTableView[indexPath.row].weather.first!.main))
            cell.city.text = weatherDataResponse.city.name != "" ? weatherDataResponse.city.name : "No data place"
            cell.wind.text = Strings.windSpeed + String(weatherDataResponse.list.first!.wind!.speed) + " km/h"
            cell.clouds.text = Strings.cloudy + String(weatherDataResponse.list.first!.clouds!.all) + " %"
            
            
            cell.backgroundColor = Resources.defaultBackgroundColor
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: mainCellIdentifier, for: indexPath) as! WeatherSimpleViewCell
            cell.date.text = String(dataWeatherTableView[indexPath.row].dtTxt)

            cell.image.image = UIImage(systemName: ImageHelper.getImageNameIconForWeatherStatus(status: dataWeatherTableView[indexPath.row].weather.first!.main))
            cell.descriptionWeather.text = dataWeatherTableView[indexPath.row].weather.first!.main
            if dataWeatherTableView[indexPath.row].main.temp > 0 {
                cell.temperature.text = "+" + String(format: "%.1f", dataWeatherTableView[indexPath.row].main.temp)
            } else {
                cell.temperature.text = String(format: "%.1f", dataWeatherTableView[indexPath.row].main.temp)
            }
            
            cell.backgroundColor = Resources.defaultBackgroundColor
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }
    }
}

//MARK: UITableViewDelegate
extension MainWeatherViewController: UITableViewDelegate {
    // Для автонастройки layout таблицы
}
