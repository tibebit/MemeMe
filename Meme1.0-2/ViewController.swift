//
//  ViewController.swift
//  Meme1.0-2
//
//  Created by Fabio Tiberio on 27/02/21.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    
    //MARK: Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //MARK: Actions
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        let pickerController = UIImagePickerController()
        
        pickerController.delegate = self
        
        self.present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        self.present(imagePicker, animated: true, completion: nil)
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

