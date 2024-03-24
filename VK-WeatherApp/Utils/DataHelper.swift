//
//  DataHelper.swift
//  VK-WeatherApp
//
//  Created by Danil Antonov on 23.03.2024.
//

import Foundation

class DateHelper {
    
    /// преобразует строку вида YYYY-MM-DD -> NSDate
    ///
    /// - Parameter dateStr: строка формата  YYYY-MM-DD
    /// - Returns: NSDate
    class func dateFromString (dateStr: String) -> Date? {
        let isoDate = dateStr
          let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
          dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let date = dateFormatter.date(from:isoDate) ?? Date()
        
        return date
    }
    
    class func toString(date:Date, format:String = "EEEE, dd.MM") -> String{
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = format
        dateFormatter2.string(from: date)
        
        return dateFormatter2.string(from: date)
    }
}
