//
//  SentMemesTableVC.swift
//  Meme1.0-2
//
//  Created by Fabio Tiberio on 21/03/21.
//

import UIKit

class SentMemesTableVC: UITableViewController {
    
    //MARK: Properties
    var memes: [Meme]! {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.memes
    }
    
    //MARK: Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    //MARK: Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableCell") as! MemeTableViewCell
        
        let meme = getCurrentMeme(memes: memes, indexPath: indexPath)
        cell.memedImage?.image = meme.memedImage
        cell.memeText?.text = meme.topText + " " + meme.bottomText
        return cell
    }
    //MARK: Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let memeDetailVC = storyboard?.instantiateViewController(withIdentifier: "MemeDetailVC") as! MemeDetailVC
        memeDetailVC.meme = getCurrentMeme(memes: memes, indexPath: indexPath)
        navigationController?.pushViewController(memeDetailVC, animated: true)
    }
    //MARK: Utility
    func getCurrentMeme(memes: [Meme], indexPath: IndexPath) -> Meme {
        return memes[indexPath.row]
    }
}
