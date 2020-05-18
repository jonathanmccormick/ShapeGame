//
//  ViewController.swift
//  TouchGestureSandbox
//
//  Created by Jonathan McCormick on 5/14/20.
//  Copyright © 2020 Jonathan McCormick. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var brickContainer: UIView!
    @IBOutlet weak var colorPicker: UIPickerView!
    @IBOutlet weak var deleteView: UIView!
    @IBAction func addBrickTapped(_ sender: Any) {
        addBrick(color: Brick.colors.randomElement()!.value)
    }
    @IBAction func addBrickLongPressed(_ sender: Any) {
        colorPicker.layer.zPosition = .greatestFiniteMagnitude
        brickContainer.isUserInteractionEnabled = false
        colorPicker.isHidden = false
    }
    
    @IBOutlet var recognizer: UIPanGestureRecognizer!
    
    private func addBrick(color: UIColor) {
        // Make brick a type
        // keep track of bricks and if multiple bricks are created on top of eachother offset them
        let brick = Brick(color: color, center: self.view.center)
        
        // if (lastBrick.center == self.view.center) {
        //      newBrick.center = self.view.center + 5
        // }
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panGesture))
        brick.addGestureRecognizer(panGesture)
        
        brickContainer.addSubview(brick)
    }
    
    @objc func panGesture(sender: UIPanGestureRecognizer){
        let point = sender.location(in: view)
        let panGesture = sender.view
        panGesture?.center = point
        
        let isOverDeleteZone = deleteView.frame.intersects(sender.view!.frame)
        
        UIView.animate(withDuration: 0.25, animations: {
            if (isOverDeleteZone) {
                sender.view?.backgroundColor = sender.view?.backgroundColor?.withAlphaComponent(0.5)
            } else {
                sender.view?.backgroundColor = sender.view?.backgroundColor?.withAlphaComponent(1)
            }
        })
        
        if (sender.state == .ended) {
            if (isOverDeleteZone) {
                sender.view?.removeFromSuperview()
            }
        }
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        Brick.colors.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(Brick.colorSortedKeys[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        addBrick(color: Brick.colors[Brick.colorSortedKeys[row]]!)
        pickerView.isHidden = true
        brickContainer.isUserInteractionEnabled = true
        pickerView.selectedRow(inComponent: 0)
     }
}

