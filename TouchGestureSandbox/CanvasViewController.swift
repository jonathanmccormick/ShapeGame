//
//  ViewController.swift
//  TouchGestureSandbox
//
//  Created by Jonathan McCormick on 5/14/20.
//  Copyright © 2020 Jonathan McCormick. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController {
    
    var shapes: [Shape] = []
    
    // MARK: - Outlets
    @IBOutlet weak var canvas: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var gridView: GridView!
    @IBOutlet weak var colorPicker: UIPickerView!
    @IBOutlet weak var addBrickButton: UIButton!
    @IBOutlet weak var deleteView: UIView!
    @IBOutlet var recognizer: UIPanGestureRecognizer!
    
    // MARK: - Actions
    @IBAction func addBrickTapped(_ sender: Any) {
        addShape()
    }
    
    @IBAction func addBrickLongPressed(_ sender: Any) {
        colorPicker.layer.zPosition = .greatestFiniteMagnitude
        canvas.isUserInteractionEnabled = false
        colorPicker.isHidden = false
    }
    
    @IBAction func DeleteTapped(_ sender: Any) {
        shapes.popLast()?.removeFromSuperview()
    }
    @IBAction func returnUserToFirstBrickIfDoubleTapped(_ sender: Any) {
        guard let firstBrick = shapes.first else { return }
        
        let xOffset = firstBrick.center.x - (scrollView.frame.width * 0.5)
        let yOffset = firstBrick.center.y - (scrollView.frame.height * 0.5)
        
        scrollView.setContentOffset(CGPoint(x: xOffset, y: yOffset), animated: true)
    }
    
    private func addShape() {
        addShape(color: Colors.random())
    }
    
    private func addShape(color: UIColor) {
        let shape = shapes.count % 2 == 0 ? Brick() : Rectangle()
        shape.color = color
        positionRandomlyInMiddle(shape)

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panGesture))
        shape.addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.shapeTapped))
        shape.addGestureRecognizer(tapGesture)
        
        scrollView.addSubview(shape)
        shapes.append(shape)
    }
    
    @objc func panGesture(sender: UIPanGestureRecognizer){
        guard let shape = sender.view as? Shape else {
            return
        }
        
        shape.center.x = scrollView.contentOffset.x + sender.location(in: view).x
        shape.center.y = scrollView.contentOffset.y + sender.location(in: view).y
        
        // Delete logic
        let isOverDeleteZone = shape.frame.intersects(deleteView.convert(shape.frame, from: shape))
        shape.fade(isOverDeleteZone)
        if (isOverDeleteZone && sender.state == .ended) {
            delete(shape)
        }
        
        // Copy logic
        let isOverAddZone = shape.frame.intersects(addBrickButton.convert(shape.frame, from: shape))
        
        if (isOverAddZone) {
            addBrickButton.titleLabel?.text = "Copy Brick"
        } else {
            addBrickButton.titleLabel?.text = "Add Brick"
        }
        
        if (isOverAddZone && sender.state == .ended) {
            addShape(color: shape.color)
        }
        
        shape.snapIfCloseToAny(of: shapes)
    }
    
    @objc func shapeTapped(sender: UITapGestureRecognizer){
        scrollView.bringSubviewToFront(sender.view!)
    }
    
    private func delete(_ shape: Shape) {
        shape.removeFromSuperview()
        shapes.remove(at: shapes.firstIndex(of: shape)!)
    }
    
    private func positionRandomlyInMiddle(_ shape: Shape) {
        let randomBound: CGFloat = 25
        let xOffset = CGFloat.random(in: -randomBound...randomBound)
        let yOffset = CGFloat.random(in: -randomBound...randomBound)
        shape.center.x = scrollView.contentOffset.x + (scrollView.frame.width * 0.5) + xOffset
        shape.center.y = scrollView.contentOffset.y + (scrollView.frame.height * 0.5) + yOffset
    }
}

extension CanvasViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        Colors.colors.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(Colors.colorSortedKeys[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        addShape(color: Colors.colors[Colors.colorSortedKeys[row]]!)
        pickerView.isHidden = true
        canvas.isUserInteractionEnabled = true
        pickerView.selectedRow(inComponent: 0)
     }
}

