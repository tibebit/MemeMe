//
//  SentMemesCollectionVC.swift
//  Meme1.0-2
//
//  Created by Fabio Tiberio on 21/03/21.
//

import UIKit

class SentMemesCollectionVC: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    //MARK: Properties
    var memes: [Meme]! {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes
    }
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let space: CGFloat = 3.0
        let itemWidth = (view.frame.size.width - space * 2) / 3
        let itemHeight = view.frame.size.height / 4
        //print("itemWidth: \(itemWidth)")
        //print("itemHeight: \(itemHeight)")
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        flowLayout.minimumLineSpacing = space
        flowLayout.minimumInteritemSpacing = space
    
        collectionView.layoutMargins = UIEdgeInsets(top: space, left: space, bottom: space, right: space)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    //MARK: Data Source
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeItem", for: indexPath) as! MemeCollectionViewCell
        
        let meme = memes[indexPath.item]
        item.memedImage.image = meme.memedImage
        
        return item
    }
    //MARK: Delegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let memeDetailVC = storyboard?.instantiateViewController(withIdentifier: "MemeDetailVC") as! MemeDetailVC
        memeDetailVC.meme = memes[indexPath.item]
        navigationController?.pushViewController(memeDetailVC, animated: true)
    }
}
