//
//  StickerCell.swift
//  Estimote Stickers
//
//  Created by Jonathan Poch on 1/18/17.
//  Copyright © 2017 Jonathan Poch. All rights reserved.
//

import Foundation
import SnapKit

class StickerCell: UITableViewCell {
    
    // MARK: - Properties
    var nameView: UITextView!
    var identifierView: UITextView!
    var motionIdicatorView: UITextView!
    
    // MARK: - Initializers
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        nameView = UITextView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width - 10, 26))
        nameView.editable = false
        nameView.userInteractionEnabled = false
        nameView.font = UIFont(name: "HelveticaNeue-Bold", size: 24)
        nameView.textColor = UIColor.blackColor()
        nameView.textContainer.lineBreakMode = .ByTruncatingTail
        nameView.textContainer.maximumNumberOfLines = 1
        nameView.textContainerInset = UIEdgeInsetsMake(-1, 0, 0, 0)
        
        self.contentView.addSubview(nameView)
        
        nameView.snp_remakeConstraints { (make) -> Void in
            make.top.equalTo(5)
            make.width.equalTo(self.nameView.frame.size.width)
            make.left.equalTo(5)
            make.height.equalTo(self.nameView.frame.size.height)
        }
        
        identifierView = UITextView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width - 10, 20))
        identifierView.editable = false
        identifierView.userInteractionEnabled = false
        identifierView.font = UIFont(name: "HelveticaNeue", size: 20)
        identifierView.textColor = UIColor.blackColor()
        identifierView.textContainer.lineBreakMode = .ByTruncatingTail
        identifierView.textContainer.maximumNumberOfLines = 1
        identifierView.textContainerInset = UIEdgeInsetsMake(-1, 0, 0, 0)
        
        self.contentView.addSubview(identifierView)
        
        identifierView.snp_remakeConstraints { (make) -> Void in
            make.top.equalTo(self.nameView.snp_bottom)
            make.width.equalTo(self.identifierView.frame.size.width)
            make.left.equalTo(5)
            make.height.equalTo(self.identifierView.frame.size.height)
        }
        
        motionIdicatorView = UITextView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width - 10, 20))
        motionIdicatorView.editable = false
        motionIdicatorView.userInteractionEnabled = false
        motionIdicatorView.font = UIFont(name: "HelveticaNeue-Italic", size: 20)
        motionIdicatorView.textColor = UIColor.blackColor()
        motionIdicatorView.textContainer.lineBreakMode = .ByTruncatingTail
        motionIdicatorView.textContainer.maximumNumberOfLines = 1
        motionIdicatorView.textContainerInset = UIEdgeInsetsMake(-1, 0, 0, 0)
        
        self.contentView.addSubview(motionIdicatorView)
        
        motionIdicatorView.snp_remakeConstraints { (make) -> Void in
            make.top.equalTo(self.identifierView.snp_bottom)
            make.width.equalTo(self.motionIdicatorView.frame.size.width)
            make.left.equalTo(5)
            make.height.equalTo(self.motionIdicatorView.frame.size.height)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
