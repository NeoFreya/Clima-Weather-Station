//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController  {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var seacrhTextField: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherManager.delegate = self
        seacrhTextField.delegate = self
    }
    
}


// UITextFieldDelegate
extension WeatherViewController : UITextFieldDelegate{
    @IBAction func seacrhButton(_ sender: UIButton) {
        seacrhTextField.endEditing(true) // tutup keyboard
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        seacrhTextField.endEditing(true) // tutup keyboard
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = seacrhTextField.text{
            weatherManager.fecthWeather(cityName: city)
        }
        seacrhTextField.text = "" // hapus text seacrh
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        }else{
            textField.placeholder = "Wajib Isi"
            return false
        }
    }
}

// WeatherManagerDelegate
extension WeatherViewController : WeatherManagerDelegate{
    func diUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    
    func diFailWithError(error: Error) {
        print(error)
    }
    
    
}

extension WeatherViewController : CLLocationManagerDelegate{
    @IBAction func locationPressed(_  sender : UIButton){
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fecthWeather(latitude: lat, longtitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
