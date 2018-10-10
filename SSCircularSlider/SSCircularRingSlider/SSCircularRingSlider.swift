//
//  SSCircularRingSlider.swift
//  CircularProgressTutorial
//
//  Created by Sarthak Shah on 31/07/18.
//  Copyright © 2018 Sarthak Shah. All rights reserved.
//

import UIKit

protocol SSCircularRingSliderDelegate {
    func controlValueUpdated(value: Int)
}

open class SSCircularRingSlider: UIView {

    // MARK: -
    // MARK: - Variable declaration
    var startAngle: CGFloat = 140
    var endAngle: CGFloat = 40
    var minValue: CGFloat = 0
    var maxValue: CGFloat = 120
    var initialValue: CGFloat = 0 {
        didSet {
            // should not less than minimum value.
            if initialValue < minValue {
                fatalError("Initial value should not be less than minimum value.")
            }
        }
    }
    var outerRingWidth: CGFloat = 10
    var innerRingWidth: CGFloat = 10
    var knonbImage = UIImage(named: "iconKnobRed")
    var startPointImage = UIImage(named: "iconMinusRed")
    var endPointImage = UIImage(named: "iconPlusRed")
    var labelFont = UIFont.boldSystemFont(ofSize: 40)
    var gradientColors: [CGColor] = [UIColor.red.cgColor, UIColor.red.cgColor] {
        didSet {
            if gradientColors.count < 2 {
                fatalError("Gradient layer needs two or more colors.")
            }
        }
    }
    var shouldAddEndPoints: Bool = true
    var shouldShowKnob: Bool = true
    var knobSize: CGFloat = 30
    var shouldAddTextLabel: Bool = true
    var extraOffsetOfRadius: CGFloat = 0
    var arrLabelValues: [Int] = [Int](0...100)
    var currentIndex: Int = 0
    var delegate: SSCircularRingSliderDelegate?
    
    // MARK: -
    // MARK: - Fileprivate variable declaration
    fileprivate var midViewX = CGFloat()
    fileprivate var midViewY = CGFloat()
    
    fileprivate var innerCircularRing = UIBezierPath()
    fileprivate var outerCircularRing = UIBezierPath()
    
    fileprivate var knobImageView = UIImageView()
    fileprivate var startPointButton = UIButton()
    fileprivate var endPointButton = UIButton()
    
    fileprivate var innerRingShape = CAShapeLayer()
    fileprivate var outerRingShape = CAShapeLayer()
    fileprivate let txtValue: UITextField = {
       let txtLabel = UITextField()
        txtLabel.keyboardType = .numberPad
        txtLabel.backgroundColor = .clear
        txtLabel.textAlignment = .center
        txtLabel.text = ""
        txtLabel.adjustsFontSizeToFitWidth = true
        txtLabel.addDoneButtonOnKeyboard()
        return txtLabel
    }()
    
    fileprivate var startAngleRadian: CGFloat = 0
    fileprivate var endAngleRadian: CGFloat = 0
    fileprivate var knobStartingAngleRadian: CGFloat = 0
    fileprivate var valueRange: CGFloat = 0
    fileprivate var angleRange: CGFloat = 0
    fileprivate var valuePerAngle: CGFloat = 0
    fileprivate var anglePerValue: CGFloat = 0
    fileprivate var currentValue: CGFloat = 0
    
    fileprivate var width: CGFloat = 0
    fileprivate var height: CGFloat = 0
    fileprivate var centerPoint: CGPoint = CGPoint()
    fileprivate var circularRingRadius: CGFloat = 0
    fileprivate var gradientLayer = CAGradientLayer()
    
    fileprivate var innerCircleColor = UIColor.lightGray.cgColor
    fileprivate var outerCircleColor = UIColor.red.cgColor
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        initialSetUp()
    }
    
    // MARK: -
    // MARK: - Initializer
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, startAngle: CGFloat, endAngle: CGFloat, initialValue: CGFloat, minValue: CGFloat, maxValue: CGFloat, outerRingWidth: CGFloat, innerRingWidth: CGFloat, shouldAddEndPoints: Bool, knobImageName: String, startPointImageName: String, endPointImageName: String) {
        super.init(frame: frame)
        
        self.startAngle = startAngle
        self.endAngle = endAngle
        self.initialValue = initialValue
        self.minValue = minValue
        self.maxValue = maxValue
        self.outerRingWidth = outerRingWidth
        self.innerRingWidth = innerRingWidth
        self.shouldAddEndPoints = shouldAddEndPoints
        
        if let knobImage = UIImage(named: knobImageName) {
            self.knonbImage = knobImage
        }
        if let startPointImage = UIImage(named: startPointImageName) {
            self.startPointImage = startPointImage
        }
        if let endPointImage = UIImage(named: endPointImageName) {
            self.endPointImage = endPointImage
        }
        
        initialSetUp()
    }
    
    /// Initial setup of ring slider
    fileprivate func initialSetUp() {
        width = bounds.width - max(innerRingWidth, outerRingWidth)
        height = bounds.height - max(innerRingWidth, outerRingWidth)
        
        let offSetToDraw: CGFloat = 10
        centerPoint = CGPoint(x: bounds.midX, y: bounds.midY + offSetToDraw)
        circularRingRadius = getCircularRingRadius()
        
        midViewX = self.bounds.midX
        midViewY = self.bounds.midY + offSetToDraw
        
        knobSize = outerRingWidth * 2
        valueRange = maxValue - minValue
        
        angleRange = distance(angleA: startAngle, angleB: endAngle)
        
        valuePerAngle = valueRange/angleRange
        anglePerValue = angleRange/valueRange
        valueRange += anglePerValue
        
        currentValue = round(initialValue)
        let currentAngle = (currentValue * valuePerAngle) + startAngle
        
        startAngleRadian = startAngle.toRadians
        endAngleRadian = endAngle.toRadians
        knobStartingAngleRadian = currentAngle.toRadians
        
        if shouldAddTextLabel {
            createValueTextField()
            setValueTextfield()
        }
        
        createInnerCircularRing()
        createOuterCircularRing()
        addGradientColor()
        
        if shouldAddEndPoints {
            createEndPoints()
        }
        
        // Knob
        if shouldShowKnob {
            createKnobOfSlider()
        }
        
        makeAllButtonsCircular()
    }
    
    /// Create textfield of slider
    fileprivate func createValueTextField() {
        txtValue.removeIfAdded()
        let labelOffset: CGFloat = 0
        let multiplier: CGFloat = 0.6
        txtValue.frame = CGRect(x: 0, y: 0, width: self.frame.width * multiplier -  labelOffset, height: self.frame.height * multiplier - labelOffset)
        txtValue.center = CGPoint(x: midViewX, y: midViewY)
        txtValue.font = labelFont
        self.addSubview(txtValue)
    }
    
    /// Create inner circular ring
    fileprivate func createInnerCircularRing() {
        innerRingShape.removeIfAdded()
        
        innerCircularRing = UIBezierPath(arcCenter: centerPoint, radius: circularRingRadius, startAngle: startAngleRadian, endAngle: endAngleRadian, clockwise: true)
        
        innerRingShape.path = innerCircularRing.cgPath
        innerRingShape.fillColor = UIColor.clear.cgColor
        innerRingShape.strokeColor = self.innerCircleColor
        innerRingShape.lineWidth = innerRingWidth
        innerRingShape.strokeEnd = 1
        innerRingShape.lineCap = kCALineCapButt
        self.layer.addSublayer(innerRingShape)
    }
    
    /// This func returns radious of slider ring
    ///
    /// - Returns: radius in CGFloat
    fileprivate func getCircularRingRadius() -> CGFloat {
        let outerRadius: CGFloat = min(width, height)/2
        return outerRadius
    }
    
    /// Create outer circle ring
    fileprivate func createOuterCircularRing() {
        outerRingShape.removeIfAdded()
       
        outerCircularRing = UIBezierPath(arcCenter: centerPoint, radius: circularRingRadius, startAngle: startAngleRadian, endAngle: knobStartingAngleRadian, clockwise: true)
        outerRingShape.path = outerCircularRing.cgPath
        outerRingShape.fillColor = UIColor.clear.cgColor
        outerRingShape.strokeColor = UIColor.red.cgColor
        outerRingShape.lineWidth = outerRingWidth
        
        self.layer.addSublayer(outerRingShape)
    }
    
    /// Create endpoints of slider
    fileprivate func createEndPoints() {
        let offsetDegree = 0.0
        
        // StartPoint
        startPointButton.removeIfAdded()
        
        let startPointX = centerPoint.x + cos(startAngleRadian - CGFloat(offsetDegree.toRadians))*circularRingRadius
        let startPointY = centerPoint.y + sin(startAngleRadian - CGFloat(offsetDegree.toRadians))*circularRingRadius
        
        startPointButton = UIButton(type: .custom)
        startPointButton.backgroundColor = .red
        startPointButton.frame = CGRect(x: 0, y: 0, width: knobSize, height: knobSize)
        startPointButton.center = CGPoint(x: startPointX, y: startPointY)
        startPointButton.setImage(startPointImage, for: .normal)
        startPointButton.addTarget(self, action: #selector(onStartButtonClick(_:)), for: .touchUpInside)
        self.addSubview(startPointButton)
        
        // EndPoint
        endPointButton.removeIfAdded()

        let endPointX = centerPoint.x + cos(endAngleRadian - CGFloat(offsetDegree.toRadians))*circularRingRadius
        let endPointY = centerPoint.y + sin(endAngleRadian - CGFloat(offsetDegree.toRadians))*circularRingRadius
        
        endPointButton = UIButton(type: .custom)
        endPointButton.backgroundColor = .darkGray
        endPointButton.frame = CGRect(x: 0, y: 0, width: knobSize, height: knobSize)
        endPointButton.center = CGPoint(x: endPointX, y: endPointY)
        endPointButton.setImage(endPointImage, for: .normal)
        endPointButton.addTarget(self, action: #selector(onEndButtonClick(_:)), for: .touchUpInside)
        self.addSubview(endPointButton)
    }
    
    /// Creates knob of slider
    fileprivate func createKnobOfSlider() {
        let knobPointX = centerPoint.x + cos(knobStartingAngleRadian)*circularRingRadius
        let knobPointY = centerPoint.y + sin(knobStartingAngleRadian)*circularRingRadius
        
        knobImageView.removeIfAdded()
        
        knobImageView = UIImageView()
        knobImageView.backgroundColor = .white
        knobImageView.frame = CGRect(x: 0, y: 0, width: knobSize, height: knobSize)
       
        knobImageView.contentMode = .scaleAspectFill
        knobImageView.center = CGPoint(x: knobPointX, y: knobPointY)
        knobImageView.image = knonbImage
        knobImageView.isUserInteractionEnabled = true
        knobImageView.clipsToBounds = true
        self.addSubview(knobImageView)
        
        let dragBall = UIPanGestureRecognizer(target: self, action: #selector(dragBall(recognizer:)))
        knobImageView.addGestureRecognizer(dragBall)
        
        updateKnobAngleFromValue(initialValue)
    }
    
    /// This method will find the distance between two angles and returns it.
    ///
    /// - Parameters:
    ///   - angleA: Starting angle
    ///   - angleB: Ending angle
    /// - Returns: Difference between two angle in terms of 360 degree
    fileprivate func distance(angleA: CGFloat, angleB: CGFloat) -> CGFloat {
        let a = abs(angleB-angleA).truncatingRemainder(dividingBy: 360)
        let dist = a > 180 ? 360 - a : a
        return 360 - dist
    }
    
    /// Set textfield value
    fileprivate func setValueTextfield() {
        let strValue = "\(Int(currentValue))"
        txtValue.text = strValue
    }
    
    /// This method updates slider from angle
    ///
    /// - Parameter angleRadian: angle in radians
    fileprivate func setLabel(fromAngleRadian angleRadian: CGFloat) {
        let value = calculateValue(angleRadian: angleRadian)
        if let index = getClosestElementFromArray(arrValues: arrLabelValues, enteredValue: Int(value)) {
            setCurrentIndexAndUpdate(index)
        }
    }
    
    /// This method calculates the value from given angle
    ///
    /// - Parameter angleRadian: angle in radian
    /// - Returns: return value
    fileprivate func calculateValue(angleRadian: CGFloat) -> CGFloat {
        var value: CGFloat = 0
        let currentAngle = angleRadian.toDegree
        if currentAngle >= startAngle && currentAngle <= 180 {
            let diff = (currentAngle - startAngle)
            value = diff
        } else if currentAngle >= -180 && currentAngle <= 0 {
            let diff = abs(180-startAngle) + currentAngle + 180
            value = diff
        } else if currentAngle >= 0 && currentAngle <= endAngle {
            let diff = 180 + startAngle - abs(endAngle - startAngle)
            let a = diff + currentAngle
            value = a
        }
        
        let ang = value
        let totalAngle = distance(angleA: startAngle, angleB: endAngle)
        let diff = CGFloat(totalAngle/CGFloat(arrLabelValues.count))
        
        let t1 = (ang) / diff
        let t2 = Int(t1)
        currentIndex = t2
        return CGFloat(arrLabelValues[t2])
    }
    
    /// This method updates knob angle from value
    ///
    /// - Parameter newValue: updated value
    fileprivate func updateKnobAngleFromValue(_ newValue: CGFloat) {
        if newValue >= minValue && newValue <= maxValue {
            currentValue = round(newValue)
            setValueTextfield()
            
            let newAngle = currentValue * anglePerValue + startAngle
            let circlePath2 = UIBezierPath(arcCenter: centerPoint, radius: circularRingRadius, startAngle: startAngleRadian, endAngle: newAngle.toRadians, clockwise: true)
            outerRingShape.path = circlePath2.cgPath
            let knobPointX = centerPoint.x + cos(newAngle.toRadians)*circularRingRadius
            let knobPointY = centerPoint.y + sin(newAngle.toRadians)*circularRingRadius
            
            knobImageView.center = CGPoint(x: knobPointX, y: knobPointY)
        }
    }
    
    /// Sets endpoint images
    ///
    /// - Parameter image: image
    fileprivate func setEndPointImage(image: UIImage) {
        self.endPointImage = image
        self.endPointButton.setImage(self.endPointImage, for: .normal)
    }
    
    /// Sets start point image
    ///
    /// - Parameter image: image
    fileprivate func setStartPointImage(image: UIImage) {
        self.startPointImage = image
        self.startPointButton.setImage(self.startPointImage, for: .normal)
    }
    
    /// This mehtod makes all buttons of circular shape
    fileprivate func makeAllButtonsCircular() {
        self.knobImageView.layer.cornerRadius = knobSize/2
        self.startPointButton.layer.cornerRadius = knobSize/2
        self.endPointButton.layer.cornerRadius = knobSize/2
    }
    
    /// Adds color to the gardient layer
    fileprivate func addGradientColor() {
        gradientLayer.removeIfAdded()
        
        let layer = self.getGradientLayerOf(frame: self.bounds, colors: gradientColors)
        gradientLayer = layer
        gradientLayer.colors = gradientColors
        gradientLayer.mask = self.outerRingShape
        self.layer.addSublayer(gradientLayer)
    }
    
    /// Updates the values of slider
    fileprivate func updateValues() {
        let newAngle = getNewAngleFromIndex(currentIndex)
        updatePathAndKnob(newAngle: newAngle)
        updateValueOfLabel()
        delegate?.controlValueUpdated(value: arrLabelValues[currentIndex])
    }
    
    /// Upadtes the value of label
    fileprivate func updateValueOfLabel() {
        let strValue = "\(arrLabelValues[currentIndex])"
        txtValue.text = strValue
    }
    
    /// CXalcualtes new angle form given index
    ///
    /// - Parameter newIndex: index
    /// - Returns: updated angle
    fileprivate func getNewAngleFromIndex(_ newIndex: Int) -> CGFloat {
        let totalAngle = distance(angleA: startAngle, angleB: endAngle)
        let interval = CGFloat(totalAngle/CGFloat(arrLabelValues.count - 1))
        let currentAngle = startAngle + (CGFloat(newIndex) * interval)
        if currentAngle <= 180 {
            return currentAngle
        } else {
            return round(currentAngle - 360)
        }
    }
    
    /// This method updates path and knob of slider from angle
    ///
    /// - Parameter newAngle: updated angle
    fileprivate func updatePathAndKnob(newAngle: CGFloat) {
        let circlePath2 = UIBezierPath(arcCenter: centerPoint, radius: circularRingRadius, startAngle: startAngleRadian, endAngle: newAngle.toRadians, clockwise: true)
        outerRingShape.path = circlePath2.cgPath
        let knobPointX = centerPoint.x + cos(newAngle.toRadians)*circularRingRadius
        let knobPointY = centerPoint.y + sin(newAngle.toRadians)*circularRingRadius
        knobImageView.center = CGPoint(x: knobPointX, y: knobPointY)
        updateGradientLayer()
    }
    
    
    /// This method updates gradient layer
    fileprivate func updateGradientLayer() {
        gradientLayer.frame = self.bounds
        gradientLayer.mask = outerRingShape
    }
    
    /// This method sets size of knob imagge
    fileprivate func setKnobImageSize(size: CGFloat = 30) {
        let currentAngle = getNewAngleFromIndex(currentIndex)
        let knobPointX = centerPoint.x + cos(currentAngle.toRadians)*circularRingRadius
        let knobPointY = centerPoint.y + sin(currentAngle.toRadians)*circularRingRadius
        
        self.knobImageView.center = CGPoint(x: knobPointX, y: knobPointY)
    }
    
    // MARK: -
    // MARK: - Button Action methods
    
    
    /// Performs minus action
    ///
    /// - Parameter sender: minus button
    @objc fileprivate func onStartButtonClick(_ sender: UIButton) {
        let value = currentIndex - 1
        if value >= 0 {
            currentIndex = value
            updateValues()
        }
    }
    
    /// Performs plus action
    ///
    /// - Parameter sender: plus button
    @objc fileprivate func onEndButtonClick(_ sender: UIButton) {
        let value = currentIndex + 1
        if value < arrLabelValues.count {
            currentIndex = value
            updateValues()
        }
    }
    
    // MARK: -
    // MARK: - Gesture Recognizers
    
    /// Knob gesture recognizer
    ///
    /// - Parameter recognizer: pan gesture
    @objc fileprivate func dragBall(recognizer: UIPanGestureRecognizer) {
        let point = recognizer.location(in: self);
        let earthX = Double(point.x)
        let earthY = Double(point.y)
        let midViewXDouble = Double(midViewX)
        let midViewYDouble = Double(midViewY)
        let angleX = (earthX - midViewXDouble)
        let angleY = (earthY - midViewYDouble)
        let angle = atan2(angleY, angleX)
        
        if angle.toDegree <= Double(endAngle) || angle.toDegree >= Double(startAngle) {
            let earthX2 = midViewXDouble + cos(angle)*Double(circularRingRadius)
            let earthY2 = midViewYDouble + sin(angle)*Double(circularRingRadius)
            
            knobImageView.center = CGPoint(x: earthX2, y: earthY2)
            
            let circlePath2 = UIBezierPath(arcCenter: centerPoint, radius: circularRingRadius, startAngle: startAngleRadian, endAngle: CGFloat(angle), clockwise: true)
            outerRingShape.path = circlePath2.cgPath
            
            setLabel(fromAngleRadian: CGFloat(angle))
        }
    }
    
}

// MARK: -
// MARK: - Extension
extension SSCircularRingSlider {
    
    // MARK: - Public Methods
    // MARK: -
    
    /// Reset circular slider
    public func resetCircularRingSlider() {
        initialSetUp()
    }
    
    /// This method sets text label font and color of text label
    ///
    /// - Parameters:
    ///   - labelFont: font for label
    ///   - textColor: color of text label
    public func setTextLabel(labelFont: UIFont, textColor: UIColor) {
        self.labelFont = labelFont
        self.txtValue.textColor = textColor
        self.txtValue.font = self.labelFont
    }
    
    /// Sets knob of circular slider
    ///
    /// - Parameters:
    ///   - knobSize: size of knob
    ///   - knonbImage: knob image
    public func setKnobOfSlider(knobSize: CGFloat = 30, knonbImage: UIImage) {
        self.knobSize = knobSize
        self.knonbImage = knonbImage
        self.knobImageView.image = self.knonbImage
        DispatchQueue.main.async {
            self.knobImageView.frame.size.height = knobSize
            self.knobImageView.frame.size.width = knobSize
            self.knobImageView.layer.cornerRadius = knobSize/2
            self.setKnobImageSize(size: knobSize)
        }
    }
    
    /// This method sets ring colors for circular slider
    ///
    /// - Parameters:
    ///   - innerCirlce: inner ring color
    ///   - outerCircle: outer ring color
    public func setCircluarRingColor(innerCirlce: UIColor, outerCircle: UIColor) {
        self.innerCircleColor = innerCirlce.cgColor
        self.outerCircleColor = outerCircle.cgColor
        DispatchQueue.main.async {
            self.innerRingShape.strokeColor = self.innerCircleColor
            self.outerRingShape.strokeColor = self.outerCircleColor
        }
    }
    
    /// This method sets shadow of circular ring
    ///
    /// - Parameters:
    ///   - shadowColor: shadow color
    ///   - radius: shadow radious
    public func setCircluarRingShadow(shadowColor: UIColor, radius: CGFloat) {
        self.innerRingShape.setShadow(color: shadowColor, opacity: 0.5, offset: 1.0, radius: radius)
    }
    
    /// This method sets background color of all buttons
    ///
    /// - Parameters:
    ///   - startPointColor: starting button color
    ///   - endPointColor: ending button color
    ///   - knobColor: knob color
    public func setBackgroundColorOfAllButtons(startPointColor: UIColor, endPointColor: UIColor, knobColor: UIColor) {
        DispatchQueue.main.async {
            self.startPointButton.backgroundColor = startPointColor
            self.endPointButton.backgroundColor = endPointColor
            self.knobImageView.backgroundColor = knobColor
        }
    }
    
    /// This method sets shadow for all buttons
    ///
    /// - Parameters:
    ///   - color: shadow color
    ///   - opacity: shadow opacity
    ///   - offset: shadow offset
    ///   - radius: shadow radious
    public func setShadowOfAllButtons(color: UIColor, opacity: Float, offset: CGFloat, radius: CGFloat) {
        self.startPointButton.setShadow(color: color, opacity: opacity, offset: offset, radius: radius)
        self.endPointButton.setShadow(color: color, opacity: opacity, offset: offset, radius: radius)
        self.knobImageView.setShadow(color: color, opacity: opacity, offset: offset, radius: radius)
    }
    
    /// This method sets images for both endpoints
    ///
    /// - Parameters:
    ///   - startPointImage: starting button image
    ///   - endPointImage: ending button image
    public func setEndPointsImage(startPointImage: UIImage, endPointImage: UIImage) {
        setEndPointImage(image: endPointImage)
        setStartPointImage(image: startPointImage)
    }
    
    /// This method sets textfield delegate
    ///
    /// - Parameter viewController: view controller
    public func setValueTextFieldDelegate(viewController: UIViewController) {
        self.txtValue.delegate = viewController as? UITextFieldDelegate
    }
    
    /// This method sets values for circular ring slider
    ///
    /// - Parameters:
    ///   - initialValue: initial value
    ///   - minValue: minimum value
    ///   - maxValue: maximum value
    public func setValues(initialValue: CGFloat, minValue: CGFloat, maxValue: CGFloat) {
        self.initialValue = initialValue
        self.minValue = minValue
        self.maxValue = maxValue
        
        initialSetUp()
    }
    
    /// This method sets values array for circular ring slider
    ///
    /// - Parameters:
    ///   - labelValues: array of integer values
    ///   - currentIndex: current index
    public func setArrayValues(labelValues: [Int], currentIndex: Int) {
        self.arrLabelValues = labelValues
        self.currentIndex = currentIndex
        updateValues()
    }
    
    /// This method is useful for set given index and update slider
    ///
    /// - Parameter index: index
    public func setCurrentIndexAndUpdate(_ index: Int) {
        self.currentIndex = index
        updateValues()
    }
    
    /// This method sets color of gradient layer
    ///
    /// - Parameter colors: array of CGColor it has to be consists of minimum two values
    public func setProgressLayerColor(colors: [CGColor]) {
        //        gradientLayer.frame = outerCircularRing.cgPath.boundingBoxOfPath
        gradientColors = colors
        gradientLayer.colors = gradientColors
    }
    
    /// This method returns nearest elemnt of array from entered value
    ///
    /// - Parameters:
    ///   - arrValues: array of values
    ///   - enteredValue: enetered value
    /// - Returns: returns closest element
    public func getClosestElementFromArray(arrValues: Array<Int>, enteredValue: Int) -> Int? {
        if let closest = arrValues.enumerated().min(by: { abs($0.1 - enteredValue) < abs($1.1 - enteredValue)}) {
            return closest.offset
        }
        return nil
    }
    
    /// This function sets width of inner circular ring and outer circular ring width
    ///
    /// - Parameters:
    ///   - innerRingWidth: inner ring width
    ///   - outerRingWidth: outer ring width
    public func setCircularRingWidth(innerRingWidth: CGFloat, outerRingWidth: CGFloat) {
        self.innerRingWidth = innerRingWidth
        self.outerRingWidth = outerRingWidth
        initialSetUp()
    }
    
}
