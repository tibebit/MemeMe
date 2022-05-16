//
//  MemeTableViewCell.swift
//  Meme1.0-2
//
//  Created by Fabio Tiberio on 22/03/21.
//

import UIKit

class MemeTableViewCell: UITableViewCell, MemeCell {
    
    static let identifier = String(describing: MemeTableViewCell.self)
    @IBOutlet weak var memedImage: UIImageView!
    @IBOutlet weak var memeText: UILabel!
    
    
    func configure(image: UIImage) {
        self.memedImage.image = image
    }
}

extension MemeCell where Self == MemeTableViewCell {
    
    func configure(image: UIImage, text: String) {
        configure(image: image)
        self.memeText.text = text
    }
}
