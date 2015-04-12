//
//  ReportViewController.swift
//  DCCrimeReport
//
//  Created by Kieran Raftery on 4/12/15.
//  Copyright (c) 2015 Kieran Raftery. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let webView = UIWebView(frame: self.view.bounds)
        view.addSubview(webView)
        
        let url = NSURL (string: "http://mpdc.dc.gov/service/file-police-report-online")
        //let url = NSURL (string: "www.google.com")
        let requestObj = NSURLRequest(URL: url!)
        webView.loadRequest(requestObj)
    }
}
