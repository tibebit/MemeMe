//
//  SentMemesCollectionVC.swift
//  Meme1.0-2
//
//  Created by Fabio Tiberio on 21/03/21.
//

import UIKit

class SentMemesCollectionVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    //MARK: Outlets
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    //MARK: Properties
    var memes: [Meme]! {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes
    }
    let defaultSpace: CGFloat = 3.0
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setSpacing(defaultSpace, lineSpacingConstant: 3, interitemSpacingConstant: 0)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    //MARK: Items Spacing
    func setSpacing(_ space: CGFloat, lineSpacingConstant: CGFloat, interitemSpacingConstant: CGFloat) {
        flowLayout.minimumLineSpacing = space + lineSpacingConstant
        flowLayout.minimumInteritemSpacing = space + interitemSpacingConstant
    }
    
    //MARK: Data Source
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeItem", for: indexPath) as! MemeCollectionViewCell
        
        let meme = getCurrentMeme(memes: memes, indexPath: indexPath)
        item.memedImage?.image = meme.memedImage
        
        return item
    }
    
    //MARK: Delegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let memeDetailVC = storyboard?.instantiateViewController(withIdentifier: "MemeDetailVC") as! MemeDetailVC
        memeDetailVC.meme = getCurrentMeme(memes: memes, indexPath: indexPath)
        navigationController?.pushViewController(memeDetailVC, animated: true)
    }
    
    //MARK: Flow Layout Delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalWidth = view.frame.size.width
        let width = (totalWidth - (defaultSpace * 2)) / 3
        return CGSize(width: width, height: width)
    }
    
    //MARK: Utility
    func getCurrentMeme(memes: [Meme], indexPath: IndexPath) -> Meme {
        return memes[indexPath.row]
    }
}
