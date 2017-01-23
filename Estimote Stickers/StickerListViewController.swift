//
//  ViewController.swift
//  Estimote Stickers
//
//  Created by Jonathan Poch on 1/18/17.
//  Copyright © 2017 Jonathan Poch. All rights reserved.
//

import UIKit
import SnapKit

class StickerListViewController: UIViewController {
    
    // MARK: - Properties
    var stickers: [String: Sticker] = [:]
    var motionDict: [String: [AnyObject]] = [:]
    var stickerIDs: [String] = [
        "ffef5d066c5ff1dc",  
        "1efc245022695d3c",
        "8630e65d853d2aa2"
    ]
    
    lazy var nearableManager: ESTNearableManager = {
        var manager: ESTNearableManager = ESTNearableManager()
        manager.delegate = self

        return manager
    }()
    
    // MARK: - UI Element(s)
    lazy var tableView: UITableView = {
        var table: UITableView = UITableView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height))
        table.delegate = self
        table.dataSource = self
        table.registerClass(StickerCell.self, forCellReuseIdentifier: "stickerCell")

        return table
    }()
    
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
        
        for id in self.stickerIDs {
            nearableManager.startRangingForIdentifier(id)
        }
        
        self.view.addSubview(self.tableView)

    }
    
    override func viewDidLayoutSubviews() {
        tableView.snp_updateConstraints{ (make) -> Void in
            make.top.equalTo(self.view.snp_top)
            make.left.equalTo(self.view.snp_left)
            make.width.equalTo(self.view.frame.size.width)
            make.height.equalTo(self.view.frame.size.height)
        }
        super.updateViewConstraints()
    }
}

// MARK: - ESTNearableManagerDelegate
extension StickerListViewController: ESTNearableManagerDelegate {
    func nearableManager(manager: ESTNearableManager, didRangeNearable nearable: ESTNearable) {
        stickers[nearable.identifier] = Sticker(nearable: nearable)
        
        var info: [AnyObject] = []
        info.append(nearable.isMoving)
        info.append("\(nearable.currentMotionStateDuration)")
        info.append("\(nearable.previousMotionStateDuration)")
        info.append(nearable.xAcceleration)
        info.append(nearable.yAcceleration)
        info.append(nearable.zAcceleration)
        info.append(nearable.temperature)
        
        motionDict[nearable.identifier] = info
//        print("There are \(stickers.count) Sticker(s)")
//        print("\(stickers)")
        tableView.reloadData()
        
        //let sticker: Sticker = stickers[nearable.identifier]!
        
        //let acc: Double = round(sqrt(Double(sticker.xAcceleration * sticker.xAcceleration + sticker.yAcceleration * sticker.yAcceleration + sticker.zAcceleration * sticker.zAcceleration))*1000)/1000

        
        //ESAPIManager.LogStickerData(sticker.identifier, name: sticker.name, inMotion: sticker.isMoving, currentState: Int(sticker.currentState)!, previousState: Int(sticker.previousState)!, acceleration: acc)
        
        NSNotificationCenter.defaultCenter().postNotificationName("motionIndicator", object: motionDict)
    }
}

// MARK: - UITableViewDelegate/UITableViewDataSource
extension StickerListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stickers.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let sticker: Sticker = stickers[stickerIDs[indexPath.item]] {
            let nextView: StickerDetailViewController = StickerDetailViewController(sticker: sticker)
            navigationController?.pushViewController(nextView, animated: true)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let sticker: Sticker = stickers[stickerIDs[indexPath.item]] {
            let cell = tableView.dequeueReusableCellWithIdentifier("stickerCell", forIndexPath: indexPath) as! StickerCell
            cell.nameView.text = "\(sticker.name)"
            cell.identifierView.text = "Identifier: \(sticker.identifier)"
            cell.motionIdicatorView.text = "In motion: \(sticker.isMoving)"
            return cell
        }
        
        return UITableViewCell()
    }

}
