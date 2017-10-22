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
    
    struct Meme {
        var topText: String?
        var bottomText: String?
        var originalImage: UIImage?
        var memedImage: UIImage
        init(topText: String?, bottomText: String?, originalImage: UIImage?, memedImage: UIImage) {
            self.topText = topText
            self.bottomText = bottomText
            self.originalImage = originalImage
            self.memedImage = memedImage
        }
    }
    
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
        
        self.topTextField.text = defaultTopText
        self.topTextField.defaultTextAttributes = memeTextAttributes
        self.topTextField.delegate = memeTextFieldDelegate

        // Botton Text Field
        
        self.bottomTextField.text = defaultBottomText
        self.bottomTextField.defaultTextAttributes = memeTextAttributes
        self.bottomTextField.delegate = memeTextFieldDelegate
        
        // Disable Share Button
        
        shareButton.isEnabled = false
    }
    
    // MARK: viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Text Alignment
        
        self.topTextField.textAlignment = NSTextAlignment.center
        self.bottomTextField.textAlignment = NSTextAlignment.center

        // Enable Camera Button only if camera is available
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
                
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
        self.dismiss(animated: true, completion: nil)
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
        
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
        
        if let memeTopText = meme.topText {
            print("Meme Top Text: \(memeTopText)")
        } else {
            print("Meme Top Text: nil")
        }
        
        if let memeBottomText = meme.bottomText {
            print("Meme Bottom Text: \(memeBottomText)")
        } else {
            print("Meme Bottom Text: nil")
        }
        
        UIImageWriteToSavedPhotosAlbum(memedImage, nil, nil, nil)
    }
    
    // MARK: resetMemeEditor
    
    func resetMemeEditor() {
        self.topTextField.text = defaultTopText
        self.bottomTextField.text = defaultBottomText
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
    
    // MARK: IBAction pickAnImageFromCamera
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: IBAction pickAnImageFromAlbum
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: IBAction shareAnMemedImage
    
    @IBAction func shareAnMemedImage(_ sender: Any) {
        let memedImage:UIImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
        
        // On activity complete, save the memed image and return to the launch state of meme editor
        
        activityViewController.completionWithItemsHandler = {
            (activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, errors: Error?) -> Void in
                if completed {
                    self.save()
                    print("Save successful")
                    self.resetMemeEditor()
                    self.dismiss(animated: true, completion: nil)
                }
            }
    }
    
    // MARK: IBAction cancelAnMemedImage
    
    @IBAction func cancelAnMemedImage(_ sender: Any) {
        self.resetMemeEditor()
        dismiss(animated: true, completion: nil)
    }
}

