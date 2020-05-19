//
//  GridTile.swift
//  Infinite-Grid-Swift
//
//  Created by Dave Poirier for ID Fusion Software Inc on 2018-08-10.
//  This is free and unencumbered software released into the public domain.
//
//  For countries not supporting unlicensed code:
//  Copyright (C) 2018 ID Fusion Software Inc. All rights reserved
//  Distributed under the MIT License: https://opensource.org/licenses/MIT

import UIKit

class GridTile: UIView {

    let coordinates: (Int, Int)

    init(frame: CGRect, coordinates: (Int, Int)) {
        self.coordinates = coordinates
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        self.layer.borderWidth = 0.25
        self.isOpaque = false
    }
    // Unused, not supporting Xib/Storyboard
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
}
