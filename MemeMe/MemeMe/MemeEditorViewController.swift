//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Abdullah Alsalman on 11/13/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {


    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var navBar: UIToolbar!
    @IBOutlet weak var toolBar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        customizeTextField(textField: topTextField, defaultText: "TOP")
        customizeTextField(textField: bottomTextField, defaultText: "Bottom")
        imagePickerView.backgroundColor = UIColor.black
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
    }
    
    func customizeTextField(textField: UITextField, defaultText: String) {
        let memeTextAttributes = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth: -4.0,
            ] as [NSAttributedString.Key : Any]
        
        textField.defaultTextAttributes = memeTextAttributes
        textField.text = defaultText
        textField.textAlignment = .center
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
           subscribeToKeyboardNotifications()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        textField.resignFirstResponder()
        unsubscribeFromKeyboardNotifications()
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        if let _ = imagePickerView.image {
            shareButton.isEnabled = true
        } else {
            shareButton.isEnabled = false
        }
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: Selector(("keyboardWillHide:")), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name:
            UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name:
            UIResponder.keyboardWillHideNotification, object: nil)
    }
    

    @objc func keyboardWillShow(_ notification:Notification) {
        view.frame.origin.y = -getKeyboardHeight(notification)
   }
 
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
            view.frame.origin.y = 0
    }
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        imagePicker(sourceType: UIImagePickerController.SourceType.photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        imagePicker(sourceType: UIImagePickerController.SourceType.camera)
    }
    
    func imagePicker(sourceType: UIImagePickerController.SourceType){
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        self.present(imagePicker, animated: true, completion:nil)
    }
    
  
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imagePickerView.image = image
            dismiss(animated: true, completion: nil)
           
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage {
        // TODO: Hide toolbar and navbar
        barsVisiblity(visible: true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // TODO: Show toolbar and navbar
        barsVisiblity(visible: false)
    
        return memedImage
    }
    
    func barsVisiblity(visible: Bool) {
        toolBar.isHidden = visible
        navBar.isHidden = visible
    }
    
    func save(memedImage: UIImage) {
        // Create the meme
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(meme)
        
        dismiss(animated: true, completion: nil)
    }
    
  @IBAction func share(_ sender: Any) {
        let memedImage = generateMemedImage()
        let shareController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
    
    shareController.completionWithItemsHandler = { (activityType, completed, returnedItems, activityError) -> () in
        if (completed) {
        self.save(memedImage: memedImage)
        self.dismiss(animated: true, completion: nil)
        }
    }
        present(shareController, animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.imagePickerView.image = nil
        topTextField.text="TOP"
        bottomTextField.text="BOTTOM"
        self.shareButton.isEnabled = false
  
    }
    
}

