//
//  Alert.swift
//  TCP-UDP_Demo
//
//  Created by Leo Ho on 2021/7/2.
//

import Foundation
import UIKit

class Alert {
    class func showMessage(_ textView: UITextView, _ str: String) {
        textView.text = textView.text.appendingFormat("%@\n", str)
    }
}
