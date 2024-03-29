//
//  MemeCollectionViewCell.swift
//  Meme1.0-2
//
//  Created by Fabio Tiberio on 21/03/21.
//

import UIKit

class MemeCollectionViewCell: UICollectionViewCell, MemeCell {
    static let identifier = String(describing: MemeCollectionViewCell.self)
    @IBOutlet weak var memedImage: UIImageView!
    
    func configure(image: UIImage) {
        self.memedImage.image = image
    }
}
