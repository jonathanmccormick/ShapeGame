//
//  ViewController.swift
//  TouchGestureSandbox
//
//  Created by Jonathan McCormick on 5/14/20.
//  Copyright © 2020 Jonathan McCormick. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController {
    
    var bricks: [Brick] = []
    
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
        addBrick()
    }
    
    @IBAction func addBrickLongPressed(_ sender: Any) {
        colorPicker.layer.zPosition = .greatestFiniteMagnitude
        canvas.isUserInteractionEnabled = false
        colorPicker.isHidden = false
    }
    
    @IBAction func DeleteTapped(_ sender: Any) {
        bricks.popLast()?.removeFromSuperview()
    }
    @IBAction func returnUserToFirstBrickIfDoubleTapped(_ sender: Any) {
        guard let firstBrick = bricks.first else { return }
        
        let xOffset = firstBrick.center.x - (scrollView.frame.width * 0.5)
        let yOffset = firstBrick.center.y - (scrollView.frame.height * 0.5)
        
        scrollView.setContentOffset(CGPoint(x: xOffset, y: yOffset), animated: true)
    }
    
    private func addBrick() {
        addBrick(color: Brick.colors.randomElement()!.value)
    }
    
    private func addBrick(color: UIColor) {
        let brick = Brick(color: color)
        positionRandomlyInMiddle(brick)
        
        brick.addPanGestureRecognizer {
            
        }
        
        brick.addTapGestureRecognizer {
            self.scrollView.bringSubviewToFront()
        }
        
        scrollView.addSubview(brick)
        bricks.append(brick)
    }
    
    private func panGesture(sender: UIPanGestureRecognizer){
        guard let brick = sender.view as? Brick else {
            return
        }
        
        view.bringSubviewToFront(brick)
        
        brick.center.x = scrollView.contentOffset.x + sender.location(in: view).x
        brick.center.y = scrollView.contentOffset.y + sender.location(in: view).y
        
        // Delete logic
        let isOverDeleteZone = brick.frame.intersects(deleteView.convert(brick.frame, from: brick))
        brick.fade(isOverDeleteZone)
        if (isOverDeleteZone && sender.state == .ended) {
            delete(brick)
        }
        
        let isOverAddZone = brick.frame.intersects(addBrickButton.convert(brick.frame, from: brick))
        
        if (isOverAddZone) {
            addBrickButton.titleLabel?.text = "Copy Brick"
        } else {
            addBrickButton.titleLabel?.text = "Add Brick"
        }
        
        if (isOverAddZone && sender.state == .ended) {
            addBrick(color: brick.color)
        }
        
        brick.hasBeenMoved = true
        brick.snapIfCloseToAny(of: bricks)
    }
    
    private func delete(_ brick: Brick) {
        brick.removeFromSuperview()
        bricks.remove(at: bricks.firstIndex(of: brick)!)
    }
    
    private func positionRandomlyInMiddle(_ brick: Brick) {
        let randomBound: CGFloat = 25
        let xOffset = CGFloat.random(in: -randomBound...randomBound)
        let yOffset = CGFloat.random(in: -randomBound...randomBound)
        brick.center.x = scrollView.contentOffset.x + (scrollView.frame.width * 0.5) + xOffset
        brick.center.y = scrollView.contentOffset.y + (scrollView.frame.height * 0.5) + yOffset
    }
}

extension CanvasViewController : UIPickerViewDelegate, UIPickerViewDataSource {
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
        canvas.isUserInteractionEnabled = true
        pickerView.selectedRow(inComponent: 0)
     }
}

