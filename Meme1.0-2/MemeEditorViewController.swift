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
        topTextField.delegate = self
        bottomTextField.delegate = self
        
        configureAppearance(for: topTextField, withText: "TOP")
        configureAppearance(for: bottomTextField, withText: "BOTTOM")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        toggleControlState(component: shareButton, isEnabled: false)
        subscribeToKeyboardNotifications()
        
        toggleViewVisibility(component: navigationController!.navigationBar, isHidden: true)
        toggleViewVisibility(component: tabBarController!.tabBar, isHidden: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        
        toggleViewVisibility(component: navigationController!.navigationBar, isHidden: false)
        toggleViewVisibility(component: tabBarController!.tabBar, isHidden: false)
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
    
    func getKeyboardY(_ notification: Notification) -> CGFloat {
        
        let keyboardSize = getKeyboardSize(notification)
        return keyboardSize.cgRectValue.origin.y
    }
    
    func getKeyboardSize(_ notification: Notification) -> NSValue {
        
        let userInfo = notification.userInfo
        return userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
    }
    //Gets the height of the keyboard
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        
        let keyboardSize = getKeyboardSize(notification)
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
        
        //get the instance of the AppDelegate
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        delegate.memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage {
        //To avoid the toolbar and navbar to be shown in the render they are hidden
        //hideToolbarAndNavbar()
        toggleViewVisibility(component: navbar, isHidden: true)
        toggleViewVisibility(component: toolbar, isHidden: true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        //showToolbarAndNavbar()
        toggleViewVisibility(component: navbar, isHidden: false)
        toggleViewVisibility(component: toolbar, isHidden: false)
        
        return memedImage
    }
    
    //MARK: UI Functions
    func toggleViewVisibility(component: UIView, isHidden: Bool) {
        component.isHidden = isHidden
    }
    
    func toggleControlState(component: UIBarItem, isEnabled: Bool) {
        component.isEnabled = isEnabled
    }

    //MARK: Image Picking
    func pickAnImage(from source: UIImagePickerController.SourceType) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
    }
    //MARK: Actions
    
    //Polish the UI
    @IBAction func resetDefaultContent(_ sender: Any) {
        configureAppearance(for: self.topTextField, withText: "TOP")
        configureAppearance(for: self.bottomTextField, withText: "BOTTOM")
        imagePickerView.image = nil
        toggleControlState(component: shareButton, isEnabled: false)
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        pickAnImage(from: .photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        pickAnImage(from: .camera)
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
            self.navigationController?.popViewController(animated: true)
        }
        
        present(activityViewController, animated: true)
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
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            imagePickerView.image = image
        }
        
        //enableShareButton()
        toggleControlState(component: shareButton, isEnabled: true)
        
        dismiss(animated: true, completion: nil)
    }
    
}
