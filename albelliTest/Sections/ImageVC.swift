//
//  ImageViewController.swift
//  albelliTest
//
//  Created by Alex Yaroshyn on 08/01/2020.
//  Copyright © 2020 albelli BV. All rights reserved.
//

import UIKit
import WebKit
import Photos

class ImageVC: UIViewController {
    
    // MARK: - Properties
    private let imageId: String
    private var webView: WKWebView!
    
    // MARK: - Inits
    init(imageId: String) {
        self.imageId = imageId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setWebView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadPage()
    }
    
    // MARK: - Helper
    private func setWebView() {
        let configuration = getWKWebViewConfiguration()
        webView = WKWebView(frame: view.bounds, configuration: configuration)
        webView.navigationDelegate = self
        view.addSubview(webView)
    }
    
    private func getWKWebViewConfiguration() -> WKWebViewConfiguration {
        let userController = WKUserContentController()
        userController.add(self, name: "observer")
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userController
        configuration.setURLSchemeHandler(ImageSchemeHandler(), forURLScheme: "photo-request")
        
        return configuration
    }
    
    private func loadPage() {
        guard let percentEncodedId = imageId.addingPercentEncoding(withAllowedCharacters: .urlUserAllowed),
            let url = URL(string: "http://localhost?imageId=\(percentEncodedId)"),
            let testPageUrl = Bundle.main.url(forResource: "testPage", withExtension: "html"),
            let html = try? String(contentsOf: testPageUrl)
            else {
                return assertionFailure("oops. not part of the test, please let us know if execution ends up here")
        }
        webView.loadHTMLString(html, baseURL: url)
    }
}

// MARK: - WKNavigationDelegate
extension ImageVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        guard let _ = navigationAction.request.url else {
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }
}

// MARK: - WKScriptMessageHandler
extension ImageVC: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if let data = message.body as? [String: String] {
            if let msg = data["messageForDone"] {
                AlertHelper.showAlert(txt: msg, cancelTapped: {
                    self.webView.evaluateJavaScript("window.actionCancel()") { (any, err) in }
                }) {
                    self.navigationController?.popViewController(animated: true)
                }
                
            } else if let msg = data["messageForCancel"] {
                AlertHelper.showInfoAlert(txt: msg)
            }
        }
    }
}
