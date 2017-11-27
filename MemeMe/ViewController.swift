//
//  ViewController.swift
//  MemeMe
//
//  Created by Shirley on 10/8/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: Properties
    
    // MARK: Default Texts
    
    let defaultTopText = "TOP"
    let defaultBottomText = "BOTTOM"
    
    // MARK: Delegates
    
    let memeTextFieldDelegate = MemeTextFieldDelegate()
    
    // MARK: Meme Text Attributes
    
    let memeTextAttributes:[String:Any] = [
        NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
        NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
        NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedStringKey.strokeWidth.rawValue: -5.0
    ]
    
    // MARK: IBOutlet
    
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var topNavbar: UINavigationBar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    // MARK: viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Top Text Field
        
        configure(textField: topTextField, withText: defaultTopText)

        // Botton Text Field
        
        configure(textField: bottomTextField, withText: defaultBottomText)
        
        // Disable Share Button
        
        shareButton.isEnabled = false
    }
    
    // MARK: viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Top Text Field
        
        configure(textField: topTextField, withText: topTextField.text!)
        
        // Botton Text Field
        
        configure(textField: bottomTextField, withText: bottomTextField.text!)
        
        // Enable Camera Button only if camera is available
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        // Hide the top navigation bar and bottom tab bar
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
       
        // Subscribe to keyboard notifications
        
        subscribeToKeyboardNotifications()
    }

    // MARK: viewWillDisappear
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Unsubscribe from keyboard notifications
        
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: imagePickerController Delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // If an image is picked, enable Share button and dismiss image picker
        
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            imagePickerView.image = image
            shareButton.isEnabled = true
            dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: imagePickerControllerDidCancel Delegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        shareButton.isEnabled = false
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: subscribeToKeyboardNotifications
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    // MARK: unsubscribeFromKeyboardNotifications
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    // MARK: keyboardWillShow
    
    @objc func keyboardWillShow(_ notification: Notification) {
        
        // If keyboard will show for bottom text field entry, move the view frame up
        
        if bottomTextField.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    // MARK: keyboardWillHide
    
    @objc func keyboardWillHide(_ notification: Notification) {
        
        // Reset the view frame
        
        view.frame.origin.y = 0
    }
    
    // MARK: getKeyboardHeight
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    // MARK: save
    
    func save() {
        let memedImage:UIImage = generateMemedImage()
        
        // Create the meme
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.sentMemes.append(meme)
    }
    
    // MARK: configure
    
    func configure(textField: UITextField, withText text: String) {
        textField.text = text
        textField.defaultTextAttributes = memeTextAttributes
        textField.delegate = memeTextFieldDelegate
        textField.textAlignment = NSTextAlignment.center
    }
    
    // MARK: resetMemeEditor
    
    func resetMemeEditor() {
        configure(textField: topTextField, withText: defaultTopText)
        configure(textField: bottomTextField, withText: defaultBottomText)
        imagePickerView.image = nil
        shareButton.isEnabled = false
    }
    
    // MARK: generateMemedImage
    
    func generateMemedImage() -> UIImage {
        
        // hide the bottom and top tool bars before capturing memed image
        
        bottomToolbar.isHidden = true
        topNavbar.isHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // reset the bottom and top tool bars
        
        bottomToolbar.isHidden = false
        topNavbar.isHidden = false
        
        return memedImage
    }
    
    // MARK: presentImagePickerWith
    
    func presentImagePickerWith(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: IBAction pickAnImageFromCamera
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        presentImagePickerWith(sourceType: .camera)
    }
    
    // MARK: IBAction pickAnImageFromAlbum
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        presentImagePickerWith(sourceType: .photoLibrary)
    }
    
    // MARK: IBAction shareAnMemedImage
    
    @IBAction func shareAnMemedImage(_ sender: Any) {
        let memedImage:UIImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
        
        // On activity complete, save the memed image and return to the previous state of view controller
        
        activityViewController.completionWithItemsHandler = {
            (activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, errors: Error?) -> Void in
                if completed {
                    self.save()
                    self.resetMemeEditor()
                    self.navigationController?.navigationBar.isHidden = false
                    self.navigationController?.popViewController(animated: true)
                }
            }
    }
    
    // MARK: IBAction cancelAnMemedImage
    
    @IBAction func cancelAnMemedImage(_ sender: Any) {
        resetMemeEditor()
        navigationController?.navigationBar.isHidden = false
        navigationController?.popViewController(animated: true)
    }
}

