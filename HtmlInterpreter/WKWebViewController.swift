//
//  WKWebViewController.swift
//  HTML_Reader
//
//  Created by Crafter on 5/7/19.
//  Copyright © 2019 Crafter. All rights reserved.
//
import UIKit
import WebKit

class WKWebViewController: UIViewController, WKUIDelegate {

    var webView: WKWebView!
    
    var htmlString: String  = ""
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        webView.loadHTMLString(htmlString, baseURL: nil)            
    }
    
}
