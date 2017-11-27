//
//  Meme.swift
//  MemeMe
//
//  Created by Shirley on 11/22/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import Foundation
import UIKit

// MARK: Meme Model

struct Meme {
    var topText: String?
    var bottomText: String?
    var originalImage: UIImage?
    var memedImage: UIImage
}

// MARK: - Meme static method

/**
 * This extension adds static method for the Meme Model.
 */

extension Meme {

    // MARK: getAllSendMemes
    
    static func getAllSentMemes() -> [Meme] {
        
        // This is the sent memes array in the Application Delegate
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        
        return appDelegate.sentMemes
    }
}
