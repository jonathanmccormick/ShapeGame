//
//  ViewController.swift
//  TouchGestureSandbox
//
//  Created by Jonathan McCormick on 5/14/20.
//  Copyright © 2020 Jonathan McCormick. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var bricks: [Brick] = []
    
    // MARK: - Outlets
    @IBOutlet weak var canvas: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var gridView: GridView!
    @IBOutlet weak var colorPicker: UIPickerView!
    @IBOutlet weak var deleteView: UIView!
    @IBOutlet var recognizer: UIPanGestureRecognizer!
    
    // MARK: - Actions
    @IBAction func addBrickTapped(_ sender: Any) {
        addBrick(color: Brick.colors.randomElement()!.value)
    }
    
    @IBAction func addBrickLongPressed(_ sender: Any) {
        colorPicker.layer.zPosition = .greatestFiniteMagnitude
        canvas.isUserInteractionEnabled = false
        colorPicker.isHidden = false
    }
    
    @IBAction func DeleteTapped(_ sender: Any) {
        bricks.popLast()?.removeFromSuperview()
    }
    
    private func addBrick(color: UIColor) {
        let brick = Brick(color: color)
        
        brick.center.x = scrollView.contentOffset.x + (scrollView.frame.width * 0.5)
        brick.center.y = scrollView.contentOffset.y + (scrollView.frame.height * 0.5)

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panGesture))
        brick.addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.brickTapped))
        brick.addGestureRecognizer(tapGesture)
        
        scrollView.addSubview(brick)
        bricks.append(brick)
    }
    
    @objc func panGesture(sender: UIPanGestureRecognizer){
        guard let brick = sender.view as? Brick else {
            return
        }
        
        brick.center = sender.location(in: view)
        
        let isOverDeleteZone = deleteView.frame.intersects(brick.frame)
        
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
        
        brick.hasBeenMoved = true
        brick.snapIfCloseToAny(of: bricks)
    }
    
    @objc func brickTapped(sender: UITapGestureRecognizer){
        canvas.bringSubviewToFront(sender.view!)
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
        canvas.isUserInteractionEnabled = true
        pickerView.selectedRow(inComponent: 0)
     }
}

