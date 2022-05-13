//
//  SentMemesTableVC.swift
//  Meme1.0-2
//
//  Created by Fabio Tiberio on 21/03/21.
//

import UIKit

class SentMemesTableVC: UITableViewController {
    var memeCollectionViewModel = MemeCollectionViewModel()

    //MARK: Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
}

//MARK: - Data Source
extension SentMemesTableVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memeCollectionViewModel.memes.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MemeTableViewCell.identifier) as! MemeTableViewCell
        return memeCollectionViewModel.configure(cell: cell, at: indexPath)
    }
}
//MARK: - Delegate
extension SentMemesTableVC {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let memeDetailVC = storyboard?.instantiateViewController(withIdentifier: "MemeDetailVC") as! MemeDetailVC
        memeDetailVC.meme = memeCollectionViewModel.getCurrentMeme(at: indexPath)
        navigationController?.pushViewController(memeDetailVC, animated: true)
    }
}
