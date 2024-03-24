//
//  ApiResponseTransformHelper.swift
//  VK-WeatherApp
//
//  Created by Danil Antonov on 23.03.2024.
//

import Foundation

/*
 * Openweathermap для бесплатного токена предоставляет ограниченное число возможностей.
 * Я смог получить по апи только температуру на 5 дней с промежутками по 3 часа.
 * Поэтому в методе getWeeklyWeatherLise я дублирую температуру последнего дня, чтобы получить информацию температуры на 7 дней
 * Новый день сразу увеличиваю на один, чтобы имитировать корректную работу API
 */
class ApiResponseTransformHelper {
    class func getWeeklyWeatherLise(r: WeatherData) -> [List] {
        let day1 = r.list[0]
        let day2 = r.list[7]
        let day3 = r.list[15]
        let day4 = r.list[23]
        let day5 = r.list[31]
        let day6 = r.list[38]
        var day7 = r.list[39]
        
        let dayFormating6 = DateHelper.dateFromString(dateStr: day6.dtTxt)
        let dayFormating7 = Calendar.current.date(byAdding: .day, value: 1, to: dayFormating6!)
        day7.dtTxt = DateHelper.toString(date: dayFormating7!, format: "yyyy-MM-dd HH:mm:ss")

        let ar = [day1, day2, day3, day4, day5, day6, day7]
        return ar
    }
    
    class func getFormattingDataList(arr: [List]) -> [List] {
        var dateArr: [List] = []

        for var el in arr {
            let date = DateHelper.dateFromString(dateStr: el.dtTxt)
            el.dtTxt = DateHelper.toString(date: date!)
            dateArr.append(el)
        }
        
        return dateArr
    }
}
