//
//  WeatherLocation.swift
//  WeatherGift
//
//  Created by Patrick Calabrese on 4/1/17.
//  Copyright © 2017 Patrick Calabrese. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class WeatherLocation {
    
    struct DailyForecast {
        var dailyMaxTemp: Double
        var dailyMinTemp: Double
        var dailySummary: String
        var dailyDate: Double
        var dailyIcon: String
    }
    
    
    var name = ""
    var coordinates = ""
    var currentTemp = -999.9
    var dailySummary = ""
    var currentIcon = ""
    var currentTime = 0.0
    var timeZone = ""
    var dailyForecastArray = [DailyForecast]()
    
    func getWeather(completed: @escaping () -> ()) {
        let weatherURL = urlBase + urlAPIKey + coordinates
        print(weatherURL)
        
        Alamofire.request(weatherURL).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if let temperature = json["currently"]["temperature"].double {
                    print("TEMP inside getWeather = \(temperature)")
                    self.currentTemp = temperature
                } else {
                    print("Could not return a temperature")
                }
                if let summary = json["daily"]["summary"].string {
                    print("SUMMARY inside getWeather = \(summary)")
                    self.dailySummary = summary
                } else {
                    print("Could not return a daily summary")
                }
                if let icon = json["currently"]["icon"].string {
                    print("ICON inside getWeather = \(icon)")
                    self.currentIcon = icon
                } else {
                    print("Could not return an icon")
                }
                if let time = json["currently"]["time"].double {
                    print("TIME inside getWeather = \(time)")
                    self.currentTime = time
                } else {
                    print("Could not return a time")
                }
                if let timeZone = json["timezone"].string {
                    print("TIMEZONE inside getWeather = \(timeZone)")
                    self.timeZone = timeZone
                } else {
                    print("Could not return a timezone")
                }
                let dailyDataArray = json["daily"]["data"]
                for day in 0...dailyDataArray.count-1 {
                    let maxTemp = json["daily"]["data"][day]["temperatureMax"].doubleValue
                    let minTemp = json["daily"]["data"][day]["temperatureMin"].doubleValue
                    let dailySummary = json["daily"]["data"][day]["summary"].stringValue
                    let dateValue = json["daily"]["data"][day]["time"].doubleValue
                    let icon = json["daily"]["data"][day]["icon"].stringValue
                    self.dailyForecastArray.append(DailyForecast(dailyMaxTemp: maxTemp, dailyMinTemp: minTemp, dailySummary: dailySummary, dailyDate: dateValue, dailyIcon: icon))
                    print("dailyForecastArray = ***** \(self.dailyForecastArray)")
                }
            case .failure(let error):
                print(error)
            }
            completed()
        }
    }
    
}
