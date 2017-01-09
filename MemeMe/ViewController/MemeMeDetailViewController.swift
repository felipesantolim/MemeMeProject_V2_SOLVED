//
//  MemeMeDetailViewController.swift
//  MemeMe
//
//  Created by Felipe Henrique Santolim on 1/2/17.
//  Copyright © 2017 Felipe Henrique Santolim. All rights reserved.
//

import UIKit

class MemeMeDetailViewController: UIViewController {

    //MARK: properties
    var meme: Meme?
    private let editMemeMeIdentifier: String = "MemeMeViewController"
    private var mainView: MemeMeDetailView {
        return self.view as! MemeMeDetailView
    }
    
    //MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        
        guard let meme = meme else { return }
        mainView.memeImage.image = meme.shareImage
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: actions
    @IBAction func editMemeMe () {
        
        let memeMeVC = self.storyboard?.instantiateViewController(withIdentifier: editMemeMeIdentifier) as! MemeMeViewController
        memeMeVC.isCancel = true
        memeMeVC.isEditMemeMe = true
        memeMeVC.meme = meme
        
        present(memeMeVC, animated: true, completion: nil)
    }
}
