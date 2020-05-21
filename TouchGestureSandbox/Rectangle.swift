//
//  Rectangle.swift
//  TouchGestureSandbox
//
//  Created by Jonathan McCormick on 5/20/20.
//  Copyright © 2020 Jonathan McCormick. All rights reserved.
//

import Foundation
import UIKit

class Rectangle: Shape {
   init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
