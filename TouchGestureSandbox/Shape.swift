//
//  Shape.swift
//  TouchGestureSandbox
//
//  Created by Jonathan McCormick on 5/20/20.
//  Copyright © 2020 Jonathan McCormick. All rights reserved.
//

import Foundation
import UIKit

class Shape: UIView {
    // MARK: properties
    var color: UIColor
    let snapConstant: CGFloat = 10
    
    override init(frame: CGRect) {
        self.color = Colors.random()
        super.init(frame: frame)
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
    public func snapIfCloseToAny(of shapes: [Shape]) {
        
        // performance: loop through all the bricks and add any that are within a certain distance (300) to a working array to cut down on performance. we don't need to be checking every single brick, only those that are close by.
        // maybe later when a brick is picked up create an array of all bricks sorted by distance from this brick and loop through the closest ones but look through more if the user moves the brick a lot.
        
        for s in shapes {
            
            var xOffsets: [CGFloat?] = []
            var yOffsets: [CGFloat?] = []

            // X
                // Snap on approach from outside
                    // approach from the left
                    xOffsets.append(calculateXOffset(frame.maxX - s.frame.minX))
            
                    // approach from the right
                    xOffsets.append(calculateXOffset(frame.minX - s.frame.maxX))
            
                // Snap on approach from inside
                    // exit from left
                    xOffsets.append(calculateXOffset(frame.maxX - s.frame.maxX))
            
                    // exit from right
                    xOffsets.append(calculateXOffset(frame.minX - s.frame.minX))
            
            // Y
                // Snap on approach from outside
                    // approach from top
                    yOffsets.append(calculateYOffset(frame.maxY - s.frame.minY))
                    
                    // approach from bottom
                    yOffsets.append(calculateYOffset(frame.minY - s.frame.maxY))
            
                // Snap on approach from inside
                    // exit top
                    yOffsets.append(calculateYOffset(frame.maxY - s.frame.maxY))
                    
                    // exit bottom
                    yOffsets.append(calculateYOffset(frame.minY - s.frame.minY))
            
            xOffsets = xOffsets.filter{ $0 != nil}
            yOffsets = yOffsets.filter{ $0 != nil}
            
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
