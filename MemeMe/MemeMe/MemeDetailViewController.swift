//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Abdullah Alsalman on 11/25/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {
    
    @IBOutlet var memeImage: UIImageView!
    var meme: Meme!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
        memeImage.image = meme.memedImage
    }
}
