//
//  SentMemesTableVC.swift
//  Meme1.0-2
//
//  Created by Fabio Tiberio on 21/03/21.
//

import UIKit

class SentMemesTableVC: UITableViewController {
    
    //MARK: Properties
    var memes: [Meme] {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.memes
    }
    
    //MARK: Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableCell")!
        
        return cell
    }
    //MARK: Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
