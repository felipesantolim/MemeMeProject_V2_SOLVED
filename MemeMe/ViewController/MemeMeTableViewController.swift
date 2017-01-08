//
//  MemeMeTableViewController.swift
//  MemeMe
//
//  Created by Felipe Henrique Santolim on 1/2/17.
//  Copyright © 2017 Felipe Henrique Santolim. All rights reserved.
//

import UIKit

class MemeMeTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: properties
    private var memes: [Meme] = [Meme]()
    private let cellIdentifier: String = "MemeMeTableCell"
    private let storyboardIdentifierDetail: String = "MemeMeDetailViewController"
    private let addNewMemeMeSegueIdentifier: String = "addNewMemeMeSegue"
    
    //MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.memes = appDelegate.memes
    }
    
    //MARK: actions
    @IBAction func createNewMemeMe (_ sender: UIBarButtonItem) {
        let memeMeVC = self.storyboard?.instantiateViewController(withIdentifier: "MemeMeViewController") as! MemeMeViewController
        memeMeVC.isCancel = true
    }
    
    //MARK: tableview datasource and delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MemeMeTableCell
        
        let meme = self.memes[indexPath.row]
        
        cell.memeImage.image = meme.shareImage
        cell.topDescriptionLabel.text = meme.topDescription
        cell.bottomDescriptionLabel.text = meme.bottomDescription
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let meme = self.memes[indexPath.row]
        
        let sentMemeDetailVC = self.storyboard?.instantiateViewController(withIdentifier: storyboardIdentifierDetail) as! MemeMeDetailViewController
        sentMemeDetailVC.meme = meme
        self.navigationController?.pushViewController(sentMemeDetailVC, animated: true)
    }
}
