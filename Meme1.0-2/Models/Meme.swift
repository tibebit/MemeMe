//
//  Meme.swift
//  Meme1.0-2
//
//  Created by Fabio Tiberio on 02/03/21.
//

import Foundation
import UIKit

struct Meme {
    
    var topText: String
    var bottomText: String
    var image: UIImage
    var memedImage: UIImage
    
    init(topText: String, bottomText:String, image: UIImage, memedImage: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.image = image
        self.memedImage = memedImage
    }
    
}
