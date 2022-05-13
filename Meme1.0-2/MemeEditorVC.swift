//
//  MemeEditorVC.swift
//  Meme1.0-2
//
//  Created by Fabio Tiberio on 27/02/21.
//

import UIKit

class MemeEditorVC: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: MemeMeTextField!
    @IBOutlet weak var bottomTextField: MemeMeTextField!
    @IBOutlet weak var toolbar: UIToolbar!
    
    lazy var cancelButton: UIBarButtonItem = {
        UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(resetViewState(_:)))
    }()
    
    lazy var shareButton: UIBarButtonItem = {
        UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareMeme(_:)))
    }()
    
    //MARK: Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        topTextField.delegate = self
        bottomTextField.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(resetViewState(_:)))
        navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.leftBarButtonItem = shareButton
        
        resetTextFieldsText()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        #warning("BUG->After picking the image from the camera, the share button gets set to false. This prevents the user from sending the meme to his friends")
        toggleControlState(component: shareButton, isEnabled: false)
        subscribeToKeyboardNotifications()
        
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
        // Prevent the keyborad from hiding the bottom text field
        if bottomTextField.isFirstResponder {
            view.frame.origin.y += getKeyboardHeight(notification) * (-1)
        }
    }
    
    
    @objc func keyboardWillHide(_ notification: Notification) {
        // Set the view to its original position
        view.frame.origin.y = 0
    }
    
    
    func getKeyboardY(_ notification: Notification) -> CGFloat {
        
        let keyboardSize = getKeyboardSize(notification)
        return keyboardSize.cgRectValue.origin.y
    }
    
    
    func getKeyboardSize(_ notification: Notification) -> NSValue {
        
        let userInfo = notification.userInfo
        return userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
    }
   
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        
        let keyboardSize = getKeyboardSize(notification)
        return keyboardSize.cgRectValue.size.height
    }
    
    
    //MARK: TextFields Setup
    func resetTextFieldsText() {
        topTextField.set(text: "TOP")
        bottomTextField.set(text: "BOTTOM")
    }
    
    
    //MARK: Meme Functions
    func save(_ memedImage: UIImage) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        delegate.memes.append(
            Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, image: imagePickerView.image!, memedImage: memedImage))
    }
    
    
    func generateMemedImage() -> UIImage {
        func renderImage() -> UIImage {
            UIGraphicsImageRenderer(bounds: view.bounds).image { context in
                view.layer.render(in: context.cgContext)
            }
        }
        //To avoid the toolbar and navbar to be shown in the render they are hidden
        //hideToolbarAndNavbar()
        navigationController?.navigationBar.isHidden = true
        toggleViewVisibility(component: toolbar, isHidden: true)
        
        let memedImage = renderImage()
        
        //showToolbarAndNavbar()
        navigationController?.navigationBar.isHidden = false
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
    @IBAction func resetViewState(_ sender: Any) {
        resetTextFieldsText()
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
        // The meme gets saved only if the user completes the sharing process
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


extension MemeEditorVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


extension MemeEditorVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: ImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            imagePickerView.image = image
        }
        
        toggleControlState(component: shareButton, isEnabled: true)
        
        dismiss(animated: true, completion: nil)
    }
}
