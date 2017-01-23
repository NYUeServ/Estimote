//
//  StickerDetailViewController.swift
//  Estimote Stickers
//
//  Created by Jonathan Poch on 1/18/17.
//  Copyright © 2017 Jonathan Poch. All rights reserved.
//

import SnapKit
import Darwin
import UIKit

class StickerDetailViewController: UIViewController {
    
    // MARK: - Properties
    let sticker: Sticker
    
    // MARK: - UI Elements
    lazy var nameView: UITextView = {
        var name: UITextView = UITextView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width - 20, 26))
        name.editable = false
        name.userInteractionEnabled = false
        name.font = UIFont.init(name: "HelveticaNeue-Bold", size: 24)
        name.textColor = UIColor.blackColor()
        name.textContainer.lineBreakMode = .ByTruncatingTail
        name.textContainer.maximumNumberOfLines = 1
        name.textContainerInset = UIEdgeInsetsMake(-1, 0, 0, 0)
        
        return name
    }()
    
    lazy var identifierView: UITextView = {
        var idView: UITextView = UITextView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width - 20, 20))
        idView.editable = false
        idView.userInteractionEnabled = false
        idView.font = UIFont.init(name: "HelveticaNeue", size: 20)
        idView.textColor = UIColor.blackColor()
        idView.textContainer.lineBreakMode = .ByTruncatingTail
        idView.textContainer.maximumNumberOfLines = 1
        idView.textContainerInset = UIEdgeInsetsMake(-1, 0, 0, 0)
        
        return idView
    }()
    
    lazy var motionIndicatorView: UITextView = {
        var motionView: UITextView = UITextView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width - 20, 20))
        motionView.editable = false
        motionView.userInteractionEnabled = false
        motionView.font = UIFont.init(name: "HelveticaNeue-Italic", size: 20)
        motionView.textColor = UIColor.blackColor()
        motionView.textContainer.lineBreakMode = .ByTruncatingTail
        motionView.textContainer.maximumNumberOfLines = 1
        motionView.textContainerInset = UIEdgeInsetsMake(-1, 0, 0, 0)
        
        return motionView
    }()
    
    lazy var currentStateDurationView: UITextView = {
        var currentState: UITextView = UITextView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width - 20, 20))
        currentState.editable = false
        currentState.userInteractionEnabled = false
        currentState.font = UIFont.init(name: "HelveticaNeue", size: 20)
        currentState.textColor = UIColor.blackColor()
        currentState.textContainer.lineBreakMode = .ByTruncatingTail
        currentState.textContainer.maximumNumberOfLines = 1
        currentState.textContainerInset = UIEdgeInsetsMake(-1, 0, 0, 0)
        
        return currentState
    }()
    
    lazy var previousStateDurationView: UITextView = {
        var previousState: UITextView = UITextView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width - 20, 20))
        previousState.editable = false
        previousState.userInteractionEnabled = false
        previousState.font = UIFont.init(name: "HelveticaNeue", size: 20)
        previousState.textColor = UIColor.blackColor()
        previousState.textContainer.lineBreakMode = .ByTruncatingTail
        previousState.textContainer.maximumNumberOfLines = 1
        previousState.textContainerInset = UIEdgeInsetsMake(-1, 0, 0, 0)
        
        return previousState
    }()
    
    lazy var totalAccelerationView: UITextView = {
        var total: UITextView = UITextView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width - 20, 20))
        total.editable = false
        total.userInteractionEnabled = false
        total.font = UIFont.init(name: "HelveticaNeue-Bold", size: 20)
        total.textColor = UIColor.blackColor()
        total.textContainer.lineBreakMode = .ByTruncatingTail
        total.textContainer.maximumNumberOfLines = 1
        total.textContainerInset = UIEdgeInsetsMake(-1, 0, 0, 0)
        
        return total
    }()
    
    lazy var xAccelerationView: UITextView = {
        var x: UITextView = UITextView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width - 20, 20))
        x.editable = false
        x.userInteractionEnabled = false
        x.font = UIFont.init(name: "HelveticaNeue", size: 20)
        x.textColor = UIColor.blackColor()
        x.textContainer.lineBreakMode = .ByTruncatingTail
        x.textContainer.maximumNumberOfLines = 1
        x.textContainerInset = UIEdgeInsetsMake(-1, 0, 0, 0)
        
        return x
    }()
    
    lazy var yAccelerationView: UITextView = {
        var y: UITextView = UITextView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width - 20, 20))
        y.editable = false
        y.userInteractionEnabled = false
        y.font = UIFont.init(name: "HelveticaNeue", size: 20)
        y.textColor = UIColor.blackColor()
        y.textContainer.lineBreakMode = .ByTruncatingTail
        y.textContainer.maximumNumberOfLines = 1
        y.textContainerInset = UIEdgeInsetsMake(-1, 0, 0, 0)
        
        return y
    }()
    
    lazy var zAccelerationView: UITextView = {
        var z: UITextView = UITextView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width - 20, 20))
        z.editable = false
        z.userInteractionEnabled = false
        z.font = UIFont.init(name: "HelveticaNeue", size: 20)
        z.textColor = UIColor.blackColor()
        z.textContainer.lineBreakMode = .ByTruncatingTail
        z.textContainer.maximumNumberOfLines = 1
        z.textContainerInset = UIEdgeInsetsMake(-1, 0, 0, 0)
        
        return z
    }()
    
    lazy var temperatureView: UITextView = {
        var temperature: UITextView = UITextView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width - 20, 20))
        temperature.editable = false
        temperature.userInteractionEnabled = false
        temperature.font = UIFont.init(name: "HelveticaNeue", size: 20)
        temperature.textColor = UIColor.blackColor()
        temperature.textContainer.lineBreakMode = .ByTruncatingTail
        temperature.textContainer.maximumNumberOfLines = 1
        temperature.textContainerInset = UIEdgeInsetsMake(-1, 0, 0, 0)
        
        return temperature
    }()
    
    // MARK: - Initializers
    init(sticker: Sticker) {
        self.sticker = sticker
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController methods
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let systemVersion = CFloat(UIDevice.currentDevice().systemVersion)
        if systemVersion >= 7.0 {
            self.navigationController?.navigationBar.translucent = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.title = "NYU Estimote Stickers"
        self.edgesForExtendedLayout = .None
        self.view.backgroundColor = UIColor.whiteColor()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(motionUpdate),name:"motionIndicator", object: nil)

        
        self.nameView.text = sticker.name
        self.identifierView.text = "Identifier: \(sticker.identifier)"
        self.motionIndicatorView.text = "In motion: \(sticker.isMoving)"
        self.currentStateDurationView.text = "Current State: \(timeFormatted(Int(sticker.currentState)!))"
        self.previousStateDurationView.text = "Previous State: \(timeFormatted(Int(sticker.previousState)!))"
        self.totalAccelerationView.text = "Acceleration: \(round(sqrt(Double(sticker.xAcceleration * sticker.xAcceleration + sticker.yAcceleration * sticker.yAcceleration + sticker.zAcceleration * sticker.zAcceleration))*1000)/1000)"
        self.xAccelerationView.text = "X Acceleration: \(sticker.xAcceleration)"
        self.yAccelerationView.text = "Y Acceleration: \(sticker.yAcceleration)"
        self.zAccelerationView.text = "Z Acceleration: \(sticker.zAcceleration)"
        self.temperatureView.text = "Temperature: \(sticker.temperature)°C"
        
        self.view.addSubview(nameView)
        self.view.addSubview(identifierView)
        self.view.addSubview(motionIndicatorView)
        self.view.addSubview(totalAccelerationView)
        self.view.addSubview(currentStateDurationView)
        self.view.addSubview(previousStateDurationView)
        self.view.addSubview(xAccelerationView)
        self.view.addSubview(yAccelerationView)
        self.view.addSubview(zAccelerationView)
        self.view.addSubview(temperatureView)


    }
    
    override func viewDidLayoutSubviews() {
        nameView.snp_remakeConstraints{ (make) -> Void in
            make.top.equalTo(self.view.snp_top).offset(20)
            make.left.equalTo(self.view.snp_left).offset(5)
            make.width.equalTo(self.nameView.frame.size.width)
            make.height.equalTo(self.nameView.frame.size.height)
        }
        identifierView.snp_remakeConstraints{ (make) -> Void in
            make.top.equalTo(self.nameView.snp_bottom).offset(10)
            make.left.equalTo(self.view.snp_left).offset(5)
            make.width.equalTo(self.identifierView.frame.size.width)
            make.height.equalTo(self.identifierView.frame.size.height)
        }
        motionIndicatorView.snp_remakeConstraints{ (make) -> Void in
            make.top.equalTo(self.identifierView.snp_bottom).offset(10)
            make.left.equalTo(self.view.snp_left).offset(5)
            make.width.equalTo(self.motionIndicatorView.frame.size.width)
            make.height.equalTo(self.motionIndicatorView.frame.size.height)
        }
        currentStateDurationView.snp_remakeConstraints{ (make) -> Void in
            make.top.equalTo(self.motionIndicatorView.snp_bottom).offset(10)
            make.left.equalTo(self.view.snp_left).offset(5)
            make.width.equalTo(self.currentStateDurationView.frame.size.width)
            make.height.equalTo(self.currentStateDurationView.frame.size.height)
        }
        previousStateDurationView.snp_remakeConstraints{ (make) -> Void in
            make.top.equalTo(self.currentStateDurationView.snp_bottom).offset(10)
            make.left.equalTo(self.view.snp_left).offset(5)
            make.width.equalTo(self.previousStateDurationView.frame.size.width)
            make.height.equalTo(self.previousStateDurationView.frame.size.height)
        }
        totalAccelerationView.snp_remakeConstraints{ (make) -> Void in
            make.top.equalTo(self.previousStateDurationView.snp_bottom).offset(10)
            make.left.equalTo(self.view.snp_left).offset(5)
            make.width.equalTo(self.totalAccelerationView.frame.size.width)
            make.height.equalTo(self.totalAccelerationView.frame.size.height)
        }
        xAccelerationView.snp_remakeConstraints{ (make) -> Void in
            make.top.equalTo(self.totalAccelerationView.snp_bottom).offset(10)
            make.left.equalTo(self.view.snp_left).offset(5)
            make.width.equalTo(self.xAccelerationView.frame.size.width)
            make.height.equalTo(self.xAccelerationView.frame.size.height)
        }
        yAccelerationView.snp_remakeConstraints{ (make) -> Void in
            make.top.equalTo(self.xAccelerationView.snp_bottom).offset(10)
            make.left.equalTo(self.view.snp_left).offset(5)
            make.width.equalTo(self.yAccelerationView.frame.size.width)
            make.height.equalTo(self.yAccelerationView.frame.size.height)
        }
        zAccelerationView.snp_remakeConstraints{ (make) -> Void in
            make.top.equalTo(self.yAccelerationView.snp_bottom).offset(10)
            make.left.equalTo(self.view.snp_left).offset(5)
            make.width.equalTo(self.zAccelerationView.frame.size.width)
            make.height.equalTo(self.zAccelerationView.frame.size.height)
        }
        temperatureView.snp_remakeConstraints{ (make) -> Void in
            make.top.equalTo(self.zAccelerationView.snp_bottom).offset(10)
            make.left.equalTo(self.view.snp_left).offset(5)
            make.width.equalTo(self.temperatureView.frame.size.width)
            make.height.equalTo(self.temperatureView.frame.size.height)
        }
        super.updateViewConstraints()
    }
    
    // MARK: - Selector methods
    /*
     0: isMoving
     1: currentState
     2: previousState
     3: xAcceleration
     4: yAcceleration
     5: zAcceleration
     6: temperature
    */
    func motionUpdate(notification: NSNotification) {
        if let updateDict: [String: [AnyObject]] = notification.object as? [String: [AnyObject]] {
            if let arr: [AnyObject] = updateDict[self.sticker.identifier] {
                self.motionIndicatorView.text = "In motion: \(arr[0] as! Bool)"
                self.currentStateDurationView.text = "Current State: \(timeFormatted(Int(arr[1] as! String)!))"
                self.previousStateDurationView.text = "Previous State: \(timeFormatted(Int(arr[2] as! String)!))"
                self.totalAccelerationView.text = "Acceleration : \(round(sqrt(Double((arr[3] as! Int) * (arr[3] as! Int) + (arr[4] as! Int) * (arr[4] as! Int) + (arr[5] as! Int) * (arr[5] as! Int)))*1000)/1000)"
                self.xAccelerationView.text = "X Acceleration: \(arr[3] as! Int)"
                self.yAccelerationView.text = "Y Acceleration: \(arr[4] as! Int)"
                self.zAccelerationView.text = "Z Acceleration: \(arr[5] as! Int)"
                self.temperatureView.text = "Temperature: \(arr[6] as! Double)°C"

            }
            
        }
    }
    
    // MARK: - Helper methods
    func timeFormatted(totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
}
