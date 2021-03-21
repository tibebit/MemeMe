//
//  SentMemesCollectionVC.swift
//  Meme1.0-2
//
//  Created by Fabio Tiberio on 16/03/21.
//

import UIKit

class SentMemesCollectionVC: UIViewController {
    
    //MARK: Properties
    var memes: [Meme] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
}
