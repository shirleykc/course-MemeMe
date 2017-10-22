//
//  MemeModels.swift
//  MemeMe
//
//  Created by Shirley on 10/22/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import Foundation
import UIKit

// MARK: MemeModels

class MemeModels {
    
    // MARK: Meme struct
    
    struct Meme {
        var topText: String?
        var bottomText: String?
        var originalImage: UIImage?
        var memedImage: UIImage
        init(topText: String?, bottomText: String?, originalImage: UIImage?, memedImage: UIImage) {
            self.topText = topText
            self.bottomText = bottomText
            self.originalImage = originalImage
            self.memedImage = memedImage
        }
    }
}
