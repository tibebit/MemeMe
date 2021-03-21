//
//  SentMemesTableVC.swift
//  Meme1.0-2
//
//  Created by Fabio Tiberio on 21/03/21.
//

import UIKit

class SentMemesTableVC: UITableViewController {
    
    var memes: [Meme] {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.memes
    }
}
