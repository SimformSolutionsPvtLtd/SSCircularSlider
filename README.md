# SSCircularSlider


A simple and powerful circular ring slider, written in swift and fully customizable.

[![Swift Version][swift-image]][swift-url]
[![Build Status][travis-image]][travis-url]
[![License][license-image]][license-url]
[![Platform][platform-image]][platform-url]
[![PRs Welcome][PR-image]][PR-url]

![Alt text](https://github.com/simformsolutions/SSCircularSlider/blob/master/CircularSliderDemo.gif)

# Features!
  - Circular ring slider
  - Customizable slider color
  - Costmize slider knob
  - Customizable sider end point buttons
  - Adjust slider by editing center label
  - Dynammic values of slider
  - CocoaPods

# Requirements
  - iOS 10.0+
  - Xcode 9+

# Installation
 **CocoaPods**
 
- You can use CocoaPods to install SSSpinnerButton by adding it to your Podfile:

       use_frameworks!
       pod 'SSCircularSlider'

-  
       import UIKit
       import SSCircularSlider

**Manually**
-   Download and drop **SSCircularSlider** folder in your project.
-   Congratulations you are done with installation!

# Usage example

-   In the storyboard add a UIView and change its class to SSCircularSlider
   ![Alt text](https://github.com/simformsolutions/SSCircularSlider/blob/master/CircularRingSiderStoryBoard.png)
   
    **SetValues**
        
        let arrValues: [Int] = [Int](0...30)
        circularRingSlider.setArrayValues(labelValues: arrValues, currentIndex: indexOfValue)
    
    **SetInitialValue**
        
        let arrValues: [Int] = [Int](0...30)
        indexOfValue = 0
        circularRingSlider.setValues(initialValue: arrValues[indexOfValue].toCGFloat(), minValue: arrValues[0].toCGFloat(), maxValue: arrValues[arrValues.count-1].toCGFloat())
    
    **SetKnobImage**
    
        circularRingSlider.setKnobOfSlider(knobSize: 40, knonbImage: UIImage(named: "iconKnobRed")!)
        
    **SetTextFieldDelegate**
    
        circularRingSlider.setValueTextFieldDelegate(viewController: self)
    
    **SetRingWidth**
        
        circularRingSlider.setCircularRingWidth(innerRingWidth: 18, outerRingWidth: 18)
        
    **SetBackgroundColorOfAllButtons**
    
        circularRingSlider.setBackgroundColorOfAllButtons(startPointColor: UIColor.red, endPointColor: UIColor.lightGray, knobColor: UIColor.white)
        
    **SetEndPointImages**
        
        circularRingSlider.setEndPointsImage(startPointImage: iconMinus, endPointImage: iconPlus)
        
    **SetProgressLayerColor**
        
        circularRingSlider.setProgressLayerColor(colors: [UIColor.red.cgColor, UIColor.red.cgColor])
        
    **SetCircularSliderDelegate**
        
        extension ViewController: SSCircularRingSliderDelegate {
            func controlValueUpdated(value: Int) {
                print("current control value:\(value)")
                // Your code here
            }
        }

#  Contribute
-   We would love you for the contribution to SSCircularSlider, check the LICENSE file for more info.
 
#  Meta
-    Distributed under the MIT license. See LICENSE for more information.

    
[swift-image]:https://img.shields.io/badge/swift-4.0-orange.svg
[swift-url]: https://swift.org/
[license-image]: https://img.shields.io/badge/License-MIT-blue.svg
[license-url]: LICENSE
[travis-image]: https://img.shields.io/travis/dbader/node-datadog-metrics/master.svg?style=flat-square
[travis-url]: https://travis-ci.org/dbader/node-datadog-metrics
[codebeat-image]: https://codebeat.co/assets/svg/badges/C-ffb83f-7198e9a1b7ad7f73977b0c9a5c7c3fffbfa25f262510e5681fd8f5a3188216b0.svg
[codebeat-url]: https://codebeat.co/projects/github-com-vsouza-awesomeios-com
[platform-image]:https://img.shields.io/cocoapods/p/LFAlertController.svg?style=flat
[platform-url]:http://cocoapods.org/pods/LFAlertController
[cocoa-image]:https://img.shields.io/cocoapods/v/EZSwiftExtensions.svg
[cocoa-url]:https://img.shields.io/cocoapods/v/LFAlertController.svg
[PR-image]:https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square
[PR-url]:http://makeapullrequest.com
