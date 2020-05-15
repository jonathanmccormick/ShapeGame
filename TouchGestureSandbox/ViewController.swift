//
//  ViewController.swift
//  TouchGestureSandbox
//
//  Created by Jonathan McCormick on 5/14/20.
//  Copyright © 2020 Jonathan McCormick. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let brickColors: [String: UIColor] = [
        "black" : UIColor(red:0.00, green:0.00, blue:0.00, alpha:1.00),
        "grey" : UIColor(red:0.83, green:0.83, blue:0.83, alpha:1.00),
        "red" : UIColor(red:0.75, green:0.11, blue:0.09, alpha:1.00),
        "orage" : UIColor(red:0.92, green:0.52, blue:0.16, alpha:1.00),
        "green" : UIColor(red:0.27, green:0.58, blue:0.27, alpha:1.00),
        "blue" : UIColor(red:0.06, green:0.31, blue:0.71, alpha:1.00),
        "pink" : UIColor(red:0.85, green:0.36, blue:0.54, alpha:1.00),
    ]
    
    @IBOutlet weak var deleteView: UIView!
    @IBAction func addBrickTapped(_ sender: Any) {
        
        addBrick(color: brickColors.randomElement()!.value)
    }
    
    @IBOutlet var recognizer: UIPanGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    private func addBrick(color: UIColor) {
        let brick = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        brick.backgroundColor = color
        brick.center = self.view.center
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panGesture))
        brick.addGestureRecognizer(panGesture)
        
        view.addSubview(brick)
    }
    
    @objc func panGesture(sender: UIPanGestureRecognizer){
        let point = sender.location(in: view)
        let panGesture = sender.view
        panGesture?.center = point
        
        print(point)
        
        if (sender.state == .ended) {
            if (deleteView.frame.contains(point)) {
                sender.view?.removeFromSuperview()
            }
        }
    }
}

