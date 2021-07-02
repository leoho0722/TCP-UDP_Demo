//
//  DateToString.swift
//  TCP-UDP_Demo
//
//  Created by Leo Ho on 2021/7/2.
//

import Foundation
import UIKit

class DateToString {
    class func dateString() -> String {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.string(from: now)
        return date
    }
}
