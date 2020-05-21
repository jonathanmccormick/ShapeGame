//
//  Colors.swift
//  TouchGestureSandbox
//
//  Created by Jonathan McCormick on 5/20/20.
//  Copyright © 2020 Jonathan McCormick. All rights reserved.
//

import Foundation
import UIKit

class Colors {
    public static let colors: [String: UIColor] = [
        //        "black" : UIColor(red:0.00, green:0.00, blue:0.00, alpha:1.00),
        //        "grey" : UIColor(red:0.83, green:0.83, blue:0.83, alpha:1.00),
        "red" : UIColor(red:0.75, green:0.11, blue:0.09, alpha:1.00),
        "orage" : UIColor(red:0.92, green:0.52, blue:0.16, alpha:1.00),
        "green" : UIColor(red:0.27, green:0.58, blue:0.27, alpha:1.00),
        "blue" : UIColor(red:0.06, green:0.31, blue:0.71, alpha:1.00),
        "pink" : UIColor(red:0.85, green:0.36, blue:0.54, alpha:1.00),
        //        "yellow" : UIColor(red:1.00, green:0.92, blue:0.27, alpha:1.00),
        "Pelorous" : UIColor(red:0.21, green:0.64, blue:0.71, alpha:1.00),
        "Byzantium" : UIColor(red:0.45, green:0.11, blue:0.44, alpha:1.00),
    ]
    
    public static var colorSortedKeys: [String] = Array(colors.keys).sorted(by: <)
    
    public static func random() -> UIColor {
        return colors.randomElement()!.value
    }
}
