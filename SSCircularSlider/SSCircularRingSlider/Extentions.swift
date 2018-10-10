//
//  Extentions.swift
//  SSCircularSlider
//
//  Created by Vatsal Tanna on 02/10/18.
//  Copyright © 2018 Vatsal Tanna. All rights reserved.
//

import Foundation
import UIKit

// MARK: -
// MARK: - Extensions

// MARK: - Textfield extensions
extension UITextField {
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        endEditing(true)
    }
    
}

// MARK: - Gradient layer extensions
extension CAGradientLayer {
    
    func removeIfAdded() {
        if self.superlayer != nil {
            self.removeFromSuperlayer()
        }
    }
    
}

// MARK: - Shapelayer extenxions
extension CAShapeLayer {
    
    func setBorder(color: UIColor, borderWidth: CGFloat) {
        self.borderColor = color.cgColor
        self.borderWidth = borderWidth
    }
    
    func setShadow(color: UIColor, opacity: Float, offset: CGFloat, radius: CGFloat) {
        shadowColor = color.cgColor
        shadowOpacity = opacity
        shadowOffset = CGSize(width: offset, height: offset)
        shadowRadius = radius
    }
    
    func removeIfAdded() {
        if self.superlayer != nil {
            self.removeFromSuperlayer()
        }
    }
    
}

// MARK: - View extension
extension UIView {
    
    func setShadow(color: UIColor, opacity: Float, offset: CGFloat, radius: CGFloat) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = CGSize(width: offset, height: offset)
        layer.shadowRadius = radius
    }
    
    func getGradientLayerOf(frame: CGRect, colors: [CGColor]) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.type = kCAGradientLayerAxial
        gradientLayer.frame = frame
        gradientLayer.colors = colors
        return gradientLayer
    }
    
    func removeIfAdded() {
        if self.superview != nil {
            self.removeFromSuperview()
        }
    }
    
}

// MARK: - Integer extension
extension Int {
    
    public func toCGFloat() -> CGFloat {
        return CGFloat(self)
    }
    
}

// MARK: - binary integer extension
extension BinaryInteger {
    public var toRadians: CGFloat { return CGFloat(Int(self)) * .pi / 180 }
}

// MARK: - Floating point extension
extension FloatingPoint {
    public var toRadians: Self { return self * .pi / 180 }
    public var toDegree: Self { return self * 180 / .pi }
}
