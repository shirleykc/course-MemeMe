//
//  SentMemeTableViewController.swift
//  MemeMe
//
//  Created by Shirley on 11/23/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit

// MARK: - SentMemeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate

class SentMemeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Properties
    
    // This is an array of sent meme instances for the collection view
    var allSentMemes = [Meme]()

    // MARK: Outlets
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet var memeTableView: UITableView!
    
    // MARK: Life Cycle
    
    // MARK: viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This is the sent memes array in the Application Delegate
        allSentMemes = Meme.getAllSentMemes()
    }
    
    // MARK: viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = false
        
        // This is the sent memes array in the Application Delegate
        allSentMemes = Meme.getAllSentMemes()
        
        memeTableView.reloadData()
    }
    
    // MARK: tableView - Table View Data Source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return allSentMemes.count
    }
    
    // MARK: tableView - Table View Cell Item

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SentMemeTableCell") as! SentMemeTableCell
        let sentMeme = allSentMemes[(indexPath as NSIndexPath).row]
        
        // Set the name and image
        cell.SentMemeLabel?.text = "\(sentMeme.topText!) ... \(sentMeme.bottomText!)"
        cell.SentMemeImage?.image = sentMeme.memedImage
        
        return cell
    }

    // MARK: tableView - Select an item in Table View
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailController = storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = allSentMemes[(indexPath as NSIndexPath).row]
        navigationController!.pushViewController(detailController, animated: true)
    }
    
    @IBAction func addMemeImage(_ sender: Any) {
        let editorController = storyboard!.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        navigationController!.pushViewController(editorController, animated: true)
    }
}
