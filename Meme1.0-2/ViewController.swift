//
//  ViewController.swift
//  Meme1.0-2
//
//  Created by Fabio Tiberio on 27/02/21.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Properties
    let memeTextAttributes : [NSAttributedString.Key: Any] = [
        .strokeColor: UIColor.black,
        .foregroundColor: UIColor.white,
        .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        .strokeWidth: -3.0
    ]
    var activeTextField: UITextField?
    //MARK: Outlets
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    //MARK: Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldsSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
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
      
//        print("VIEW (show)")
//        dump(view.frame.origin.y)
//        print("TEXTFIELD (show)")
//        dump(activeTextField?.frame.origin.y)
//        print("KEYBOARD (show)")
//        dump(getKeyboardHeight(notification))
        
        //if the keyboard is going to hide the textfield the view slides up
        if activeTextField!.frame.origin.y > getKeyboardY(notification) {
            view.frame.origin.y -= getKeyboardHeight( notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
//        print("VIEW (hide)")
//        dump(view.frame.origin.y)
//        print("TEXTFIELD (hide)")
//        dump(activeTextField?.frame.origin.y)
//        print("KEYBOARD (hide)")
//        dump(getKeyboardHeight(notification))
//        print("NAVIGATION BAR (hide)")
//        dump(navigationController!.navigationBar.frame.size.height)
        //if the keyboard had shifted the view previously, the view get back to its original position
        if view.frame.origin.y < 0 {
            view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    func getKeyboardY(_ notification: Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.origin.y
    }
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.size.height
    }
    func showKeyboard() {
        
        if let activeTextField = activeTextField {
            activeTextField.becomeFirstResponder()
        }
    }
    func hideKeyboard()  {
        
        if let activeTextField = activeTextField {
            activeTextField.resignFirstResponder()
        }
    }
    //MARK: TextFields Setup
    func textFieldsSetup() {
        //Top text field setup
        topTextField.text = "TOP"
        topTextField.textAlignment = .center
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.delegate = self
        //Bottom text field setup
        bottomTextField.text = "BOTTOM"
        bottomTextField.textAlignment = .center
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.delegate = self
    }
    //MARK: Meme Stuffs
    func save(_ memedImage: UIImage) {
        
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, image: imagePickerView.image!, memedImage: memedImage)
    }
    func generateMemedImage() -> UIImage {
        
        hideToolbarAndNavbar()
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        showToolbarAndNavbar()
        
        return memedImage
    }
    
    //MARK: UI Functions
    func hideToolbarAndNavbar() {
        self.navigationController?.toolbar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
    }
    func showToolbarAndNavbar() {
        self.navigationController?.toolbar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
    }
    //MARK: Actions
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
    }
    //MARK: ImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //print("imagePickerControllerDidCancel called")
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //print("imagePickerController called")
        
        dismiss(animated: true, completion: nil)
        
        if let image = info[.originalImage] as? UIImage {
            imagePickerView.image = image
        }
    }
}
extension ViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        showKeyboard()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
    }
}
