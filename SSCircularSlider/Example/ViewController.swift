//
//  ViewController.swift
//  SSCircularSlider
//
//  Created by Vatsal Tanna on 02/10/18.
//  Copyright © 2018 Vatsal Tanna. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet var circularRingSlider: SSCircularRingSlider!
    
    // MARK: - variable declaration
    let arrValues: [Int] = [Int](0...30)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        circularRingSlider.delegate = self
        self.setCircularRingSliderColor()
    }
    
    // MARK: -
    // MARK: - Circular slider setup
    fileprivate func setCircularRingSliderColor() {
        let indexOfValue = 0
        let titleColor = UIColor(red: 31.0/255.0, green: 0.0/255.0, blue: 5.0/255.0, alpha: 1.0)
        let shadowColor = UIColor.black
        circularRingSlider.setValues(initialValue: arrValues[indexOfValue].toCGFloat(), minValue: arrValues[0].toCGFloat(), maxValue: arrValues[arrValues.count-1].toCGFloat())
        circularRingSlider.setCircluarRingShadow(shadowColor: shadowColor, radius: 2)
        circularRingSlider.setShadowOfAllButtons(color: shadowColor, opacity: 0.5, offset: 0, radius: 1)
        circularRingSlider.setTextLabel(labelFont: UIFont.systemFont(ofSize: 60), textColor: titleColor)
        circularRingSlider.setValueTextFieldDelegate(viewController: self)
        circularRingSlider.setArrayValues(labelValues: arrValues, currentIndex: indexOfValue)
        circularRingSlider.setCircluarRingColor(innerCirlce: UIColor.white, outerCircle: UIColor.red)
        circularRingSlider.setBackgroundColorOfAllButtons(startPointColor: UIColor.red, endPointColor: UIColor.lightGray, knobColor: UIColor.white)
        circularRingSlider.setEndPointsImage(startPointImage: UIImage(named: "iconMinusRed")!, endPointImage: UIImage(named: "iconPlusRed")!)
        circularRingSlider.setProgressLayerColor(colors: [UIColor.red.cgColor, UIColor.red.cgColor])
        circularRingSlider.setKnobOfSlider(knobSize: 40, knonbImage: UIImage(named: "iconKnobRed")!)
        circularRingSlider.outerRingWidth = 18
        circularRingSlider.innerRingWidth = 18
    }

}

// MARK: -
// MARK: - Extensions

// MARK: - Circular sider delegate
extension ViewController: SSCircularRingSliderDelegate {
    
    // This function will be called after updating Circular Slider Control value
    func controlValueUpdated(value: Int) {
        print("current control value\(value)")
    }
    
}

// MARK: - Textfield delegate
extension ViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let str = textField.text!
        guard let number = NumberFormatter().number(from: str) else {
            return
        }
        guard let offset = circularRingSlider.getClosestElementFromArray(arrValues: arrValues, enteredValue: Int(truncating: number)) else { return }
        circularRingSlider.setCurrentIndexAndUpdate(offset)
    }

}
