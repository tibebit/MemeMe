//
//  MemeEditorVC.swift
//  Meme1.0-2
//
//  Created by Fabio Tiberio on 27/02/21.
//

import UIKit

class MemeEditorVC: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var pickedImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: MemeMeTextField!
    @IBOutlet weak var bottomTextField: MemeMeTextField!
    @IBOutlet weak var toolbar: UIToolbar!
    
    var memeImageObserver: NSKeyValueObservation?
    
    lazy var cancelButton: UIBarButtonItem = {
        UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(popViewController))
    }()
    
    lazy var shareButton: UIBarButtonItem = {
        let shareButton =
        UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareMeme(_:)))
        shareButton.isEnabled = false
        return shareButton
    }()
    
    func setupNavigationView() {
        navigationItem.rightBarButtonItem = cancelButton
        navigationItem.leftBarButtonItem = shareButton
        navigationItem.setHidesBackButton(true, animated: false)
    }
    
    //MARK: Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        topTextField.delegate = self
        bottomTextField.delegate = self
    
        setupNavigationView()
        resetViewState()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
        toggleViewVisibility(component: tabBarController!.tabBar, isHidden: true)
        
        observePickedImage()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        
        resetViewState()
        toggleViewVisibility(component: tabBarController!.tabBar, isHidden: false)
        
        memeImageObserver = nil
    }
    
    //MARK: - Observation
    func observePickedImage() {
        memeImageObserver = pickedImageView.observe(\.image) { [weak self] imageView, observer in
            guard let self = self else { return }
            guard observer.newValue != nil else {
                
                self.toggleBarItemState(component: self.shareButton, isEnabled: false)
                return
            }
            self.toggleBarItemState(component: self.shareButton, isEnabled: true)
            self.topTextField.toggle(isEnabled: true)
            self.bottomTextField.toggle(isEnabled: true)
        }
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
        // Prevent the keyboard from hiding the bottom text field
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
    func resetTextFields() {
        topTextField.set(text: "TOP")
        bottomTextField.set(text: "BOTTOM")
        topTextField.toggle(isEnabled: false)
        bottomTextField.toggle(isEnabled: false)
    }
    
    
    //MARK: Meme Functions
    func save(_ memedImage: UIImage) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        delegate.memes.append(
            Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, image: pickedImageView.image!, memedImage: memedImage))
    }
    
    
    func generateMemedImage() -> UIImage {
        func renderImage() -> UIImage {
            UIGraphicsImageRenderer(bounds: view.bounds).image { context in
                view.layer.render(in: context.cgContext)
            }
        }
        
        func prepareUIBeforeScreenshot() {
            toggleViewVisibility(component: navigationController!.navigationBar, isHidden: true)
            toggleViewVisibility(component: toolbar, isHidden: true)
        }
        
        func restoreUIAfterScreenshot() {
            toggleViewVisibility(component: navigationController!.navigationBar, isHidden: false)
            toggleViewVisibility(component: toolbar, isHidden: false)
        }
        
        prepareUIBeforeScreenshot()
        
        let memedImage = renderImage()
        
        restoreUIAfterScreenshot()
        
        return memedImage
    }
    
    

    //MARK: Image Picking
    func pickAnImage(from source: UIImagePickerController.SourceType) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    //MARK: Actions
    private func resetViewState() {
        resetTextFields()
        pickedImageView.image = nil
    }
    
    @objc func popViewController() {
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
        activityViewController.completionWithItemsHandler = { [weak self]
            (_ , completed, _, _) in
            guard let self = self else { return }
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

//MARK: ImagePickerControllerDelegate
extension MemeEditorVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            pickedImageView.image = image
        }
        
        dismiss(animated: true, completion: nil)
    }
}
