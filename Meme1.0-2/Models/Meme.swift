//
//  Meme.swift
//  Meme1.0-2
//
//  Created by Fabio Tiberio on 02/03/21.
//

import UIKit

struct Meme {
    
    let topText: String
    let bottomText: String
    let image: UIImage
    let memedImage: UIImage
    
    //MARK: TESTING CODE: this code has been written for layout testing concerning the collection view and table view
    //Previous code: remove all of these stuffs from here to the bottom of the file
    // This variable refers to the images added into the assets folder
    let memedImageName: String
    
    static let MemedImageName = "MemedImageName"
    static let TopText = "TopTex"
    static let BottomText = "BottomText"
    
    init(dictionary:[String:String]) {
        self.memedImageName = dictionary[Meme.MemedImageName]!
        self.bottomText = dictionary[Meme.BottomText]!
        self.topText = dictionary[Meme.TopText]!
        
        image = UIImage()
        memedImage = UIImage()
        
    }
    init(topText: String, bottomText: String, image: UIImage, memedImage: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.image = image
        self.memedImage = memedImage
        self.memedImageName = "sight"
    }
}
extension Meme {
    
    // Generate an array full of all of the villains in
    static var allMemes: [Meme] {
        
        var memesArray = [Meme]()
        
        for d in Meme.localVillainData() {
            memesArray.append(Meme(dictionary: d))
        }
        
        return memesArray
    }
    
    static func localVillainData() -> [[String : String]] {
        return [
            [Meme.TopText : "Mr. Big", Meme.BottomText : "Smuggle herion.",  Meme.MemedImageName : "original"],
            [Meme.TopText : "Ernest Blofeld", Meme.BottomText : "Many, many, schemes.",  Meme.MemedImageName : "pool"],
            [Meme.TopText : "Sir Hugo Drax", Meme.BottomText : "Nerve gass Earth, from the Moon.",  Meme.MemedImageName : "sight"],
            [Meme.TopText : "Jaws", Meme.BottomText : "Kill Bond with huge metal teeth.",  Meme.MemedImageName : "small"],
            [Meme.TopText : "Rosa Klebb", Meme.BottomText : "Humiliate MI6",  Meme.MemedImageName : "original"],
            [Meme.TopText : "Emilio Largo", Meme.BottomText : "Steal nuclear weapons", Meme.MemedImageName : "pool"],
            [Meme.TopText : "Le Chiffre", Meme.BottomText : "Beat bond at poker.",  Meme.MemedImageName : "sight"],
            [Meme.TopText : "Odd Job", Meme.BottomText : "Kill Bond with razor hat.",  Meme.MemedImageName : "sunset"],
            [Meme.TopText : "Francisco Scaramanga", Meme.BottomText : "Kill Bond after assembling a golden gun.",  Meme.MemedImageName : "small"],
            [Meme.TopText : "Raoul Silva", Meme.BottomText : "Kill M.",  Meme.MemedImageName : "original"],
            [Meme.TopText : "Alec Trevelyan", Meme.BottomText : "Nuke London, after killing Bond.",  Meme.MemedImageName : "pool"],
            [Meme.TopText : "Auric Goldfinger", Meme.BottomText : "Nuke Fort Knox.",  Meme.MemedImageName : "sight"],
            [Meme.TopText : "Max Zorin", Meme.BottomText : "Destroy Silicon Valley with an earthquake and flood.",  Meme.MemedImageName : "small"]
        ]
    }
}
//MARK: END TESTING
