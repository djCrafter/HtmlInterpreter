//
//  ViewController.swift
//  HTML_Reader
//
//  Created by Crafter on 5/7/19.
//  Copyright © 2019 Crafter. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
 
    var tags: [HtmlTag] = [HtmlTag(title: "b", content: "<b></b>"),
                           HtmlTag(title: "i", content: "<i></i>"),
                           HtmlTag(title: "p", content: "<p></p>"),
                           HtmlTag(title: "div", content: "<div></div>"),
                           HtmlTag(title: "h1", content: "<h1></h1>"),
                           HtmlTag(title: "h2", content: "<h2></h2>"),
                           HtmlTag(title: "h3", content: "<h3></h3>"),
                           HtmlTag(title: "h4", content: "<h4></h4>"),
                           HtmlTag(title: "h5", content: "<h5></h5>"),
                           HtmlTag(title: "h6", content: "<h6></h6>")
    ]
    
    @IBOutlet weak var textField: UITextView!
    
    
    
    @IBAction func InterpretButton(_ sender: Any) {
        performSegue(withIdentifier: "WebViewSegue", sender: sender)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewSetting()
        
    }
    
    func collectionViewSetting() {
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        collectionView.dragInteractionEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        collectionView.collectionViewLayout = layout
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "WebViewSegue" {
            if let detaiViewController = segue.destination as? WKWebViewController {
               detaiViewController.htmlString = textField.text
            }
        }
    }
}



extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDragDelegate, UICollectionViewDropDelegate {
   
    //MARK: Drag & Drop setting
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        if let attributedString = (collectionView.cellForItem(at: indexPath) as? CollectionViewCell)?.content {
            let dragItem = UIDragItem(itemProvider: NSItemProvider(object: attributedString as NSItemProviderWriting))
            dragItem.localObject = collectionView.cellForItem(at: indexPath)
            return [dragItem]
        } else {
            return []
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSAttributedString.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if let indexPath = destinationIndexPath, indexPath.section == 1 {
            let isSelf = (session.localDragSession?.localContext as? UICollectionView) == collectionView
            return UICollectionViewDropProposal(operation: isSelf ? .move : .copy, intent: .insertAtDestinationIndexPath)
        } else {
            return UICollectionViewDropProposal(operation: .cancel)
        }
    }
    

    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        for item in coordinator.items {
            if let sourceIndexPath = item.sourceIndexPath {
                if let tag = item.dragItem.localObject as? HtmlTag {
                    collectionView.performBatchUpdates({
                                  tags.remove(at: sourceIndexPath.item)
                        tags.insert(tag, at: destinationIndexPath.item)
                    
                        collectionView.deleteItems(at: [sourceIndexPath])
                        collectionView.insertItems(at: [destinationIndexPath])
                    })                   
                    coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
            }
        }
    }
}


    // MARK: ColletionView setting
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return tags.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            if let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as? CollectionViewCell {
                let tagTitle = NSAttributedString(string: tags[indexPath.item].title)
                itemCell.tagLabel.attributedText = tagTitle
                itemCell.content = tags[indexPath.item].content
                
                return itemCell
            }
            return UICollectionViewCell()
        }
        
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
}

