//
//  Brick.swift
//  TouchGestureSandbox
//
//  Created by Jonathan McCormick on 5/15/20.
//  Copyright © 2020 Jonathan McCormick. All rights reserved.
//

import Foundation
import UIKit

class Brick: UIView {

    // MARK: properties
    var color: UIColor
    let snapConstant: CGFloat = 10

    init(color: UIColor) {
        self.color = color
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        backgroundColor = color
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shadowRadius = 5
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func fade(_ fade: Bool) {
        UIView.animate(withDuration: 0.25, animations: {
            if (fade) {
                self.backgroundColor = self.backgroundColor?.withAlphaComponent(0.5)
            } else {
                self.backgroundColor = self.backgroundColor?.withAlphaComponent(1)
            }
        })
    }
    
    // MARK: Snapping logic
    public func snapIfCloseToAny(of bricks: [Brick]) {
        
        // performance: loop through all the bricks and add any that are within a certain distance (300) to a working array to cut down on performance. we don't need to be checking every single brick, only those that are close by.
        // maybe later when a brick is picked up create an array of all bricks sorted by distance from this brick and loop through the closest ones but look through more if the user moves the brick a lot.
        
        for _brick in bricks {
            
            var xOffsets: [CGFloat?] = []
            var yOffsets: [CGFloat?] = []

            // X
                // Snap on approach from outside
                    // approach from the left
                    xOffsets.append(calculateXOffset(frame.maxX - _brick.frame.minX))
            
                    // approach from the right
                    xOffsets.append(calculateXOffset(frame.minX - _brick.frame.maxX))
            
                // Snap on approach from inside
                    // exit from left
                    xOffsets.append(calculateXOffset(frame.maxX - _brick.frame.maxX))
            
                    // exit from right
                    xOffsets.append(calculateXOffset(frame.minX - _brick.frame.minX))
            
            // Y
                // Snap on approach from outside
                    // approach from top
                    yOffsets.append(calculateYOffset(frame.maxY - _brick.frame.minY))
                    
                    // approach from bottom
                    yOffsets.append(calculateYOffset(frame.minY - _brick.frame.maxY))
            
                // Snap on approach from inside
                    // exit top
                    yOffsets.append(calculateYOffset(frame.maxY - _brick.frame.maxY))
                    
                    // exit bottom
                    yOffsets.append(calculateYOffset(frame.minY - _brick.frame.minY))
            
            xOffsets = xOffsets.filter{ $0 != nil}
            yOffsets = yOffsets.filter{ $0 != nil}
            
//            if (!xOffsets.isEmpty || !yOffsets.isEmpty) {
//                print("\(xOffsets), \(yOffsets)")
//            }
            
            if (!xOffsets.isEmpty && !yOffsets.isEmpty)
            {
                setBrickCenter(xOffset: xOffsets.first!!, yOffset: yOffsets.first!!)
            }
        }
    }
    
    private func setBrickCenter(xOffset: CGFloat = 0, yOffset: CGFloat = 0) {
        center.x -= xOffset
        center.y -= yOffset
    }
    
    private func calculateXOffset(_ offset: CGFloat) -> CGFloat? {
        if abs(offset) < snapConstant {
            let offset = offset
            return offset
        }
        
        return nil
    }
    
    private func calculateYOffset(_ offset: CGFloat) -> CGFloat? {
        if abs(offset) < snapConstant {
            let offset = offset
            return offset
        }
        
        return nil
    }
}

// MARK: - Color
extension Brick {
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
}
