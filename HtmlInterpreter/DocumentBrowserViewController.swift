//
//  DocumentBrowserViewController.swift
//  HtmlInterpreter
//
//  Created by Crafter on 5/8/19.
//  Copyright © 2019 Crafter. All rights reserved.
//

import UIKit


class DocumentBrowserViewController: UIDocumentBrowserViewController, UIDocumentBrowserViewControllerDelegate {
    
    var tempUrl: URL?
    
    var htmlTemplate: String = """
<!DOCTYPE html>
<html lang="en">
    <head>
    <meta charset="UTF-8">
    <title>Document</title>
    </head>
    <body>
    
    </body>
    </html>
"""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        allowsDocumentCreation = true
        allowsPickingMultipleItems = false
    }
    
    // MARK: UIDocumentBrowserViewControllerDelegate
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didRequestDocumentCreationWithHandler importHandler: @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void) {
        
        tempUrl = try? FileManager.default.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
            ).appendingPathComponent("empty.html")
        if tempUrl != nil {
            
            
            allowsDocumentCreation = FileManager.default.createFile(atPath: tempUrl!.path, contents: htmlTemplate.data(using: .utf8))
        }
        
         importHandler(tempUrl, .copy)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentsAt documentURLs: [URL]) {
        guard let sourceURL = documentURLs.first else { return }
        
        presentDocument(at: sourceURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didImportDocumentAt sourceURL: URL, toDestinationURL destinationURL: URL) {
        
        presentDocument(at: destinationURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, failedToImportDocumentAt documentURL: URL, error: Error?) {
    }
    
    // MARK: Document Presentation
    
    func presentDocument(at documentURL: URL) {
    
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "HtmlInterpreter")
        
        if let editorViewController = controller.contents as? ViewController {
            editorViewController.document = HtmlDocument(fileURL: documentURL)
        }
        present(controller, animated: true, completion: nil)
    }
}




