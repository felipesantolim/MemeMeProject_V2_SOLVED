//
//  MemeMeCollectionViewController.swift
//  MemeMe
//
//  Created by Felipe Henrique Santolim on 1/2/17.
//  Copyright © 2017 Felipe Henrique Santolim. All rights reserved.
//

import UIKit

class MemeMeCollectionViewController: UICollectionViewController {
    
    //MARK: properties
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    private var memes: [Meme] = [Meme]()
    private var cellIdentifier: String = "MemeMeCollectionCell"
    private let storyboardIdentifierDetail: String = "MemeMeDetailViewController"
    private let addNewMemeMeSegueIdentifier: String = "addNewMemeMeSegue"
    
    //MARL: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        populateSentMemes()
        adjustsCollectionViewFlowLayout()
    }
    
    //MARK: actions
    @IBAction func createNewMemeMe (_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: self.addNewMemeMeSegueIdentifier, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == addNewMemeMeSegueIdentifier {
            let memeMeVC = segue.destination as! MemeMeViewController
            memeMeVC.isCancel = true
        }
    }
    
    //MARK: private methods
    private func populateSentMemes () {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.memes = appDelegate.memes
    }
    
    private func adjustsCollectionViewFlowLayout () {
        
        let space: CGFloat = 3.0
        let dimensionX = (view.frame.size.width - (2 * space)) / 3.0
        let dimensionY = (view.frame.size.height - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimensionX, height: dimensionY)
    }
    
    //MARK: collectionview datasource and delegates
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! MemeMeCollectionCell
        
        let meme = self.memes[indexPath.item]
        cell.memeImage.image = meme.shareImage
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let meme = self.memes[indexPath.item]
        
        let sentMemeDetailVC = self.storyboard?.instantiateViewController(withIdentifier: storyboardIdentifierDetail) as! MemeMeDetailViewController
        sentMemeDetailVC.meme = meme
        self.navigationController?.pushViewController(sentMemeDetailVC, animated: true)
    }
}
