//
//  ViewController.swift
//  Climat
//
//  Created by Катя on 10.07.2024.
//

import UIKit
import CoreLocation
import SnapKit

class WeatherViewController: UIViewController {

    
    var weatherManager = WeatherManager()
    
    let locationManager = CLLocationManager()
   
    let backImage:UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "background")
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    let mainStackView:UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        return stack
    }()
    
    let firstStackView:UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        return stack
    }()
    
    let locationButton:UIButton = {
        let button = UIButton()
        button.setImage(.init(systemName: "location.circle.fill"), for: .normal)
        button.contentMode = .scaleToFill
        button.tintColor = .black
        button.addTarget(self, action: #selector(locationPressed), for: .touchUpInside)
        return button
    }()
    
    var searchTextField:UITextField = {
        let textField = UITextField()
        textField.text = "Search"
        textField.font = UIFont.systemFont(ofSize: 25)
        textField.backgroundColor = .lightGray
        textField.textColor = .darkGray
        textField.textAlignment = .left
        return textField
    }()
    
    let searchButton:UIButton = {
        let button = UIButton()
        button.setImage(.init(systemName: "magnifyingglass"), for: .normal)
        button.contentMode = .scaleToFill
        button.tintColor = .black
        button.addTarget(self, action: #selector(searchPressed), for: .touchUpInside)
        return button
    }()
    
    
    var conditionImageView:UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "sun.max")
        image.contentMode = .scaleAspectFit
        image.tintColor = .black
        return image
    }()
    
    let labelsStackView:UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 5
        stack.distribution = .fill
        return stack
    }()
    
    var temperatureLabel:UILabel = {
        let label = UILabel()
        label.text = "21"
        label.font = UIFont.systemFont(ofSize: 80)
        label.textColor = .black
        label.textAlignment = .right
        return label
    }()
    
    var degreesLabel:UILabel = {
        let label = UILabel()
        label.text = "°"
        label.font = UIFont.systemFont(ofSize: 100)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    var temperatureScaleLabel:UILabel = {
        let label = UILabel()
        label.text = "C"
        label.font = UIFont.systemFont(ofSize: 90)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    var cityLabel:UILabel = {
        let label = UILabel()
        label.text = "London"
        label.font = UIFont.systemFont(ofSize: 30)
        label.textColor = .black
        label.textAlignment = .right
        return label
    }()
    
    let bottomView:UIView = {
        let view = UIView()
        view.contentMode = .scaleToFill
        return view
    }()

    @objc func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    @objc func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()

        
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        
        
        searchTextField.delegate = self
        weatherManager.delegate = self
        
        // Do any additional setup after loading the view.
    }


    func initialize() {
        view.addSubview(backImage)
        view.addSubview(mainStackView)
        
        mainStackView.addArrangedSubview(firstStackView)
        firstStackView.addArrangedSubview(locationButton)
        firstStackView.addArrangedSubview(searchTextField)
        firstStackView.addArrangedSubview(searchButton)
        
        mainStackView.addArrangedSubview(conditionImageView)
        
        mainStackView.addArrangedSubview(labelsStackView)
        labelsStackView.addArrangedSubview(temperatureLabel)
        labelsStackView.addArrangedSubview(degreesLabel)
        labelsStackView.addArrangedSubview(temperatureScaleLabel)
        
        mainStackView.addArrangedSubview(cityLabel)
        mainStackView.addArrangedSubview(bottomView)
        
        backImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mainStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.trailing.leading.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        firstStackView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(10)
            
        }
        
        locationButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(40)
        }
        
        searchTextField.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        searchButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(40)
        }
        
        conditionImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.height.equalTo(120)
            make.width.equalTo(120)
            
        }
        labelsStackView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(100)
        }
        
        cityLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
        }
    }
}


extension WeatherViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else{
            textField.placeholder = "Type something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if  let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
        
    }
    
    
}

extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager:WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async{
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}


extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
}
