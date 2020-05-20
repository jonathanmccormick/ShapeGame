//
//  Shape.swift
//  TouchGestureSandbox
//
//  Created by Jonathan McCormick on 5/19/20.
//  Copyright © 2020 Jonathan McCormick. All rights reserved.
//

import Foundation

class Shape {
    var bricks: [Brick]
    
    init(bricks: [Brick]) {
        self.bricks = bricks
    }
    
    func moveShape(brickTouched: Brick) {
        // calculate and store x/y offset between this brick and every other brick in bricks
        // for brick in bricks move them to the new point + respective offset
    }
}
