//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Shirley on 11/22/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit

// MARK: - MemeDetailViewController: UIViewController

class MemeDetailViewController: UIViewController {
    
    // MARK: Properties
    
    var meme: Meme!
    
    // MARK: Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: Life Cycle
    
    // MARK: viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the tab bar for table or collection view
        tabBarController?.tabBar.isHidden = true
        
        // Set the image for Meme Detail view
        imageView!.image = meme.memedImage
    }
    
    // MARK: viewWillDisappear
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Display the tab bar for table or collection view
        tabBarController?.tabBar.isHidden = false
    }
}
