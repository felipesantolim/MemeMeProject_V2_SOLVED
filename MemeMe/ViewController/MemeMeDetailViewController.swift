//
//  MemeMeDetailViewController.swift
//  MemeMe
//
//  Created by Felipe Henrique Santolim on 1/2/17.
//  Copyright © 2017 Felipe Henrique Santolim. All rights reserved.
//

import UIKit

class MemeMeDetailViewController: UIViewController {

    var meme: Meme?
    private var mainView: MemeMeDetailView {
        return self.view as! MemeMeDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let meme = meme else { return }
        mainView.memeImage.image = meme.shareImage
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}
