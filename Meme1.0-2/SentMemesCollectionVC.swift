//
//  SentMemesCollectionVC.swift
//  Meme1.0-2
//
//  Created by Fabio Tiberio on 16/03/21.
//

import UIKit

class SentMemesCollectionVC: UICollectionViewController {
    
    //MARK: Properties
    var memes: [Meme] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes
    }
    
    //MARK: Data Source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier identifier: "MemeItem", for indexPath: indexPath)
        return item
    }
    //MARK: Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC
    }
}
