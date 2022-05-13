//
//  MemeCollectionViewModel.swift
//  Meme1.0-2
//
//  Created by Fabio Tiberio on 12/05/22.
//

import Foundation
import UIKit

public protocol MemeCell {
    var memedImage: UIImageView! { get set }
    
    func configure(image: UIImage)
}

public class MemeCollectionViewModel {
    var memes: [Meme]! {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.memes
    }
    
    public init() {
        
    }
    
    func numberOfItems() -> Int {
        memes.count
    }
    
    func configure(cell: MemeCollectionViewCell, at indexPath: IndexPath) -> MemeCollectionViewCell {
        cell.configure(image: getCurrentMeme(at: indexPath).memedImage)
        return cell
    }
    
    func configure(cell: MemeTableViewCell, at indexPath: IndexPath) -> MemeTableViewCell {
        let meme = getCurrentMeme(at: indexPath)
        cell.configure(image: meme.memedImage, text: "\(meme.topText) \(meme.bottomText)")
        return cell
    }
    
    func getCurrentMeme(at indexPath: IndexPath) -> Meme {
        return memes[indexPath.row]
    }
}
