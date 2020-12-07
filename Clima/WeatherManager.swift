//
//  WeatherManager.swift
//  Clima
//
//  Created by Abdul Halim on 23/11/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func diUpdateWeather(_ weatherManager : WeatherManager, weather : WeatherModel)
    func diFailWithError(error : Error)
}

struct WeatherManager{
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=444673fbc42434ca56cae237c9fac0a5&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fecthWeather(cityName : String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        perfomsRequest(urlString: urlString)
    }
    
    func fecthWeather(latitude : CLLocationDegrees, longtitude : CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longtitude)"
        perfomsRequest(urlString: urlString)
    }
    
    //NETWORK
    
    func perfomsRequest(urlString : String){
        //1. create URL
        if let url = URL(string: urlString){
            // 2.Session Create url
            let session = URLSession(configuration: .default)
            // 3. Give Task For Session
            let task = session.dataTask(with: url) { (data, resposn, error) in
                if error != nil {
                    self.delegate?.diFailWithError(error: error!)
                    print(error!)
                    return
                }
                
                if let safeData = data{
                    if let weather = self.parseJSON(weatherData: safeData){
                        self.delegate?.diUpdateWeather(self, weather: weather)
                    }
                }
            }
            
            // 4. Var Taks
            task.resume()
        }
    }
    func parseJSON(weatherData : Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        
        do{
            let decodeData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodeData.weather[0].id
            let temp = decodeData.main.temp
            let name = decodeData.name
            
            let weather = WeatherModel(condition: id, cityName: name, temperature: temp)
            return weather
        }catch{
            delegate?.diFailWithError(error: error)
            return nil
        }
    }
}
