//
//  MemeEditorViewController.swift
//  Meme1.0-2
//
//  Created by Fabio Tiberio on 27/02/21.
//

import UIKit

class MemeEditorViewController: UIViewController {
    
    //MARK: Properties
    let memeTextAttributes : [NSAttributedString.Key: Any] = [
        .strokeColor: UIColor.black,
        .foregroundColor: UIColor.white,
        .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        .strokeWidth: -3.0
    ]
    //This variable keeps track of the current textfield selected by the user
    var activeTextField: UITextField?
    //MARK: Outlets
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var navbar: UINavigationBar!
    @IBOutlet weak var toolbar: UIToolbar!
    
    //MARK: Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //TextFields Delegate setup
        self.topTextField.delegate = self
        self.bottomTextField.delegate = self
        
        //TextFields appearance properties setup
        self.configureAppearance(for: self.topTextField, withText: "TOP")
        self.configureAppearance(for: self.bottomTextField, withText: "BOTTOM")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        //Camera button is enabled only if the device has a camera
        self.cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        //share button is disabled. It is disabled until the user picks an image from the photo album or device camera
        self.disableShareButton()
        
        //listen to keyboard notifications
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    //MARK: Notifications
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: Keyboard Handling
    @objc func keyboardWillShow(_ notification:Notification) {
        //If the keyboard is going to hide the textfield which the user is working on, the view slides up. The view slides up only if it has not already been shifted up previously.
        if activeTextField!.frame.origin.y > getKeyboardY(notification) && view.frame.origin.y >= 0 {
            view.frame.origin.y -= getKeyboardHeight( notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        //if the keyboard has shifted up the view previously, the view gets back to its original position
        if view.frame.origin.y < 0 {
            view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    //Gets the y position of the keyboard
    func getKeyboardY(_ notification: Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.origin.y
    }
    
    //Gets the height of the keyboard
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.size.height
    }
    //the current text field selected becomes the first responder and makes the keyboard appear on the screen
    func showKeyboard() {
        
        if let activeTextField = activeTextField {
            activeTextField.becomeFirstResponder()
        }
    }
    //the current text field selected becomes the first responder and makes the keyboard disappear off the screen
    func hideKeyboard()  {
        
        if let activeTextField = activeTextField {
            activeTextField.resignFirstResponder()
        }
    }
    
    //MARK: TextFields Setup
    func configureAppearance(for textField: UITextField, withText text: String) {
        textField.defaultTextAttributes = memeTextAttributes
        textField.text = text
        textField.textAlignment = .center
        textField.adjustsFontSizeToFitWidth = true
        textField.clearsOnBeginEditing = true
    }
    //MARK: Meme Functions
    func save(_ memedImage: UIImage) {
        
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, image: imagePickerView.image!, memedImage: memedImage)
    }
    func generateMemedImage() -> UIImage {
        //To avoid the toolbar and navbar to be shown in the render they are hidden
        self.hideToolbarAndNavbar()
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        //Make the navbar and the toolbar visible again
        self.showToolbarAndNavbar()
        
        return memedImage
    }
    
    //MARK: UI Functions
    func hideToolbarAndNavbar() {
        self.navbar.isHidden = true
        self.toolbar.isHidden = true
    }
    
    func showToolbarAndNavbar() {
        self.navbar.isHidden = false
        self.toolbar.isHidden = false
    }
    
    func enableShareButton() {
        self.shareButton.isEnabled = true
    }
    
    func disableShareButton() {
        self.shareButton.isEnabled = false
    }
    //MARK: Actions
    
    //Polish the UI
    @IBAction func resetDefaultContent(_ sender: Any) {
        configureAppearance(for: self.topTextField, withText: "TOP")
        configureAppearance(for: self.bottomTextField, withText: "BOTTOM")
        imagePickerView.image = nil
        self.disableShareButton()
    }
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func shareMeme(_ sender: Any) {
        
        let memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        //Only if the user completes the share action the meme is saved and the meme object is created
        activityViewController.completionWithItemsHandler = {
            (_ , completed, _, _) in
            if completed {
                self.save(memedImage)
            }
            //The activity view controller is dismissed
            self.dismiss(animated: true, completion: nil)
        }
        
        self.present(activityViewController, animated: true)
    }
    
}
extension MemeEditorViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        if textField.clearsOnBeginEditing {
            textField.clearsOnBeginEditing = false
        }
        self.showKeyboard()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
    }
    
}
extension MemeEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: ImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            imagePickerView.image = image
        }
        //The user has picked an image. So the share button is enabled
        self.enableShareButton()
        
        self.dismiss(animated: true, completion: nil)
    }
}
