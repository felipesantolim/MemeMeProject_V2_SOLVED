//
//  MemeMeViewController.swift
//  MemeMe
//
//  Created by Felipe Henrique Santolim on 12/18/16.
//  Copyright © 2016 Felipe Henrique Santolim. All rights reserved.
//

import UIKit

private typealias SaveResult = () -> ()

class MemeMeViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var isCancel: Bool = false
    var isEditMemeMe: Bool = false
    var meme: Meme?
    
    //MARK: private properties
    private enum SourceType: Int { case Camera = 0, Album }
    private let memeSegueIdentifier: String = "sentMemesSegue"
    private var mainView: MemeMeView {
        return self.view as! MemeMeView
    }
    
    //MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.shareButton.isEnabled = false
        mainView.cancelButton.isEnabled = isCancel
        
        if isEditMemeMe { changeMemeMe() }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeToKeyboardDelegates()
        subscribeToKeyboardNotifications()
        mainView.cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK: actions
    @IBAction func openCameraOrAlbum (_ sender: UIButton) {
        
        let pickerController = UIImagePickerController()
        
        pickerController.delegate = self
        
        switch (SourceType(rawValue: sender.tag)!) {
            
        case .Camera:
            pickerController.sourceType = .camera
            break
            
        case .Album:
            pickerController.sourceType = .photoLibrary
            break
        }
        
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func openShareController (_ sender: UIButton) {
        
        guard let image = mainView.memeImage.image else {
            return
        }
        
        save(image) {
            
            let shareController = UIActivityViewController(activityItems: [meme!.shareImage], applicationActivities: nil)
            present(shareController, animated: true, completion: nil)
            
            shareController.completionWithItemsHandler = { activity, success, items, error in
                
                if success {
                    
                    guard let me = self.meme else { return }
                    
                    (UIApplication.shared.delegate as! AppDelegate).memes.append(me)
                    self.performSegue(withIdentifier: self.memeSegueIdentifier, sender: nil)
                }
            }
        }
    }
    
    @IBAction func cancelMemeMe (_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: UIImagePickerController delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            mainView.memeImage.image = image
            mainView.shareButton.isEnabled = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: UITextField delegates
    private func subscribeToKeyboardDelegates () {
        mainView.memeDescriptionTopText.delegate = self
        mainView.memeDescriptionBotText.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        mainView.memeDescriptionTopText.resignFirstResponder()
        mainView.memeDescriptionBotText.resignFirstResponder()
        
        return true
    }
    
    //MARK: Notification observers
    private func subscribeToKeyboardNotifications () {
        NotificationCenter.default.addObserver(self, selector: #selector(MemeMeViewController.keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MemeMeViewController.keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    private func unsubscribeFromKeyboardNotifications () {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc private func keyboardWillShow (_ notification: Notification) {
        if mainView.memeDescriptionBotText.isEditing {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc private func keyboardWillHide (_ notification: Notification) {
        if mainView.memeDescriptionBotText.resignFirstResponder() {
            view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    private func getKeyboardHeight (_ notification: Notification) -> CGFloat {
        
        let info = notification.userInfo
        let keyboardSize = info?[UIKeyboardFrameEndUserInfoKey] as! NSValue
        
        return keyboardSize.cgRectValue.height
    }
    
    //MARK: Private functions 
    private func save(_ image: UIImage, _ completion: SaveResult) {
        
        meme = Meme(
            bottomDescription: mainView.memeDescriptionBotText.text!,
            topDescription: mainView.memeDescriptionTopText.text!,
            originalImage: image,
            shareImage: generateMemedImage()
        )
        
        completion()
    }
    
    private func generateMemedImage () -> UIImage {
        
        navigationAndToolbarNonAvailable(true)
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        navigationAndToolbarNonAvailable(false)
        
        return memedImage
    }
    
    private func navigationAndToolbarNonAvailable (_ isAvailable: Bool) {
        mainView.memeTolbarControl.isHidden = isAvailable
        mainView.memeNavigationBar.isHidden = isAvailable
    }
    
    private func changeMemeMe () {
        
        guard let meme = meme else { return }
        
        mainView.memeDescriptionTopText.text = meme.topDescription
        mainView.memeDescriptionBotText.text = meme.bottomDescription
        mainView.memeImage.image = meme.originalImage
    }
}

