//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Abdullah Alsalman on 11/25/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewController: UITableViewController {

    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell")!
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        cell.imageView?.image = meme.memedImage
        cell.textLabel?.text = meme.topText + " ... " + meme.bottomText
     
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
         let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        
        detailController.meme = memes[(indexPath as NSIndexPath).row]
    navigationController?.pushViewController(detailController, animated: true)

    }

    
}

