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
    public var hasBeenMoved = false
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
    
    // MARK: Snapping logic
    public func snapIfCloseToAny(of bricks: [Brick]) {
        for _brick in bricks {
            // X
                // Snap on approach from outside
                    // approach from the left
                    calculateXOffset(frame.maxX - _brick.frame.minX)
            
                    // approach from the right
                    calculateXOffset(frame.minX - _brick.frame.maxX)
            
                // Snap on approach from inside
                    // exit from left
                    calculateXOffset(frame.maxX - _brick.frame.maxX)
            
                    // exit from right
                    calculateXOffset(frame.minX - _brick.frame.minX)
            
            // Y
                // Snap on approach from outside
                    // approach from top
                    calculateYOffset(frame.maxY - _brick.frame.minY)
                    
                    // approach from bottom
                    calculateYOffset(frame.minY - _brick.frame.maxY)
            
                // Snap on approach from inside
                    // exit top
                    calculateYOffset(frame.maxY - _brick.frame.maxY)
                    
                    // exit bottom
                    calculateYOffset(frame.minY - _brick.frame.minY)
        }
    }
    
    func setBrickCenter(xOffset: CGFloat = 0, yOffset: CGFloat = 0) {
        center.x -= xOffset
        center.y -= yOffset
    }
    
    func calculateXOffset(_ offset: CGFloat) {
        if abs(offset) < snapConstant {
            let offset = offset
            setBrickCenter(xOffset: offset)
        }
    }
    
    func calculateYOffset(_ offset: CGFloat) {
        if abs(offset) < snapConstant {
            let offset = offset
            setBrickCenter(yOffset: offset)
        }
    }
}

// MARK: - Color
extension Brick {
    public static let colors: [String: UIColor] = [
        "black" : UIColor(red:0.00, green:0.00, blue:0.00, alpha:1.00),
        "grey" : UIColor(red:0.83, green:0.83, blue:0.83, alpha:1.00),
        "red" : UIColor(red:0.75, green:0.11, blue:0.09, alpha:1.00),
        "orage" : UIColor(red:0.92, green:0.52, blue:0.16, alpha:1.00),
        "green" : UIColor(red:0.27, green:0.58, blue:0.27, alpha:1.00),
        "blue" : UIColor(red:0.06, green:0.31, blue:0.71, alpha:1.00),
        "pink" : UIColor(red:0.85, green:0.36, blue:0.54, alpha:1.00),
    ]
    
    public static var colorSortedKeys: [String] = Array(colors.keys).sorted(by: <)
}
