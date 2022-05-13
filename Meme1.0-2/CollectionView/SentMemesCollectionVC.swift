//
//  SentMemesCollectionVC.swift
//  Meme1.0-2
//
//  Created by Fabio Tiberio on 21/03/21.
//

import UIKit

class SentMemesCollectionVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var memeCollectionViewModel = MemeCollectionViewModel()
    let defaultSpace: CGFloat = 3.0
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setGridSpacing(defaultSpace, lineSpacingConstant: 3, interitemSpacingConstant: 0)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }

    //MARK: - Layout
    func setGridSpacing(_ space: CGFloat, lineSpacingConstant: CGFloat, interitemSpacingConstant: CGFloat) {
        flowLayout.minimumLineSpacing = space + lineSpacingConstant
        flowLayout.minimumInteritemSpacing = space + interitemSpacingConstant
    }
    
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalWidth = view.frame.size.width
        let width = (totalWidth - (defaultSpace * 2)) / 3
        return CGSize(width: width, height: width)
    }
}


//MARK: - Data Source
extension SentMemesCollectionVC {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memeCollectionViewModel.memes.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: MemeCollectionViewCell.identifier, for: indexPath) as! MemeCollectionViewCell
        return memeCollectionViewModel.configure(cell: item, at: indexPath)
    }
}


//MARK: - Delegate
extension SentMemesCollectionVC {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let memeDetailVC = storyboard?.instantiateViewController(withIdentifier: "MemeDetailVC") as! MemeDetailVC
        memeDetailVC.meme =
        memeCollectionViewModel.getCurrentMeme(at: indexPath)
        navigationController?.pushViewController(memeDetailVC, animated: true)
    }
}
