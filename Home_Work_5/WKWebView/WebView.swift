//
//  webView.swift
//  Home_Work_5
//
//  Created by Mykhailo Romanovskyi on 03.07.2020.
//  Copyright © 2020 Mykhailo Romanovskyi. All rights reserved.
//

import Foundation
import WebKit

class WebView: UIViewController {
    var webView: WKWebView!
    var myUrl: URL?
    
    override func loadView() {
        super.loadView()
        let source = "document.body.style.background = \"#9c3310\";"
        let userScript = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        
        let userContentController = WKUserContentController()
        userContentController.addUserScript(userScript)
        
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.userContentController = userContentController
        
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let url = myUrl else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

