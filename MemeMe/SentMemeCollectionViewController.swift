//
//  SentMemeCollectionViewController.swift
//  MemeMe
//
//  Created by Shirley on 11/22/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit

class SentMemeCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: Properties
    
   // This is an array of sent meme instances for the collection view
    var allSentMemes = [Meme]()

    // MARK: Outlets
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet var memeCollectionView: UICollectionView!
    
    // MARK: Life Cycle
    
    // MARK: viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This is the sent memes array in the Application Delegate
        allSentMemes = Meme.getAllSentMemes()
        
        // Implement flowLayout here.
        configure(flowLayout: flowLayout, withSpace: 0.01, withColumns: 3, withRows: 4)
    }
    
    // MARK: viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Display the tab bar for table and collection view
        tabBarController?.tabBar.isHidden = false
        
         // This is the sent memes array in the Application Delegate
        allSentMemes = Meme.getAllSentMemes()
        
        // Reload data for the collection view
        memeCollectionView.reloadData()
        
        // Implement flowLayout here.
        configure(flowLayout: flowLayout, withSpace: 0.01, withColumns: 3, withRows: 4)
    }
    
    // MARK: configure - configure the flowLayout
    
    func configure(flowLayout: UICollectionViewFlowLayout, withSpace space: CGFloat, withColumns numOfColumns: CGFloat, withRows numOfRows: CGFloat) {
        
        let width = (view.frame.size.width - ((numOfColumns + 1) * space)) / numOfColumns
        let height = (view.frame.size.height - ((numOfRows + 1) * space)) / numOfRows
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: width, height: height)
    }
    
    // MARK: collectionView - Collection View Data Source
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return allSentMemes.count
    }
    
    // MARK: collectionView - Collection View Cell Item
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SentMemeCollectionCell", for: indexPath) as! SentMemeCollectionCell
        let sentMeme = allSentMemes[(indexPath as NSIndexPath).row]
        
        // Set the image for the cell
        cell.SentMemeImage?.image = sentMeme.memedImage
        
        return cell
    }
    
    // MARK: collectionView - Select an item in Collection View
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        
        // Launch Meme Detail View
        let detailController = storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = allSentMemes[(indexPath as NSIndexPath).row]
        navigationController!.pushViewController(detailController, animated: true)
        
    }
    
    // MARK: IBAction addMemeImage
    
    @IBAction func addMemeImage(_ sender: Any) {
        let editorController = storyboard!.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        navigationController!.pushViewController(editorController, animated: true)
    }
}
