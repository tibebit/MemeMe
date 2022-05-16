//
//  MemeDetailVC.swift
//  Meme1.0-2
//
//  Created by Fabio Tiberio on 21/03/21.
//

import UIKit

class MemeDetailVC: UIViewController {
    
    var meme: Meme!
    
    @IBOutlet weak var memedImage: UIImageView!
    
    //MARK: Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        memedImage.image = meme.memedImage
    }
}
