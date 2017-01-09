//
//  MemeMeView.swift
//  MemeMe
//
//  Created by Felipe Henrique Santolim on 12/18/16.
//  Copyright © 2016 Felipe Henrique Santolim. All rights reserved.
//

import UIKit

class MemeMeView: UIView {
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var memeNavigationBar: UINavigationBar!
    @IBOutlet weak var memeTolbarControl: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var memeImage: UIImageView!
    @IBOutlet weak var memeDescriptionTopText: UITextField!
    @IBOutlet weak var memeDescriptionBotText: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let memeTextAttributes:[String:Any] = [
            NSStrokeColorAttributeName: UIColor.black,
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "Impact", size: 35)!,
            NSStrokeWidthAttributeName: -1.0]
        
        memeDescriptionTopText.defaultTextAttributes = memeTextAttributes
        memeDescriptionBotText.defaultTextAttributes = memeTextAttributes
        
        memeDescriptionTopText.textAlignment = .center
        memeDescriptionBotText.textAlignment = .center
    }
}
