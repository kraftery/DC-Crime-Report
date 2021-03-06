//
//  CrimeViewController.swift
//  DCCrimeReport
//
//  Created by Kieran Raftery on 4/12/15.
//  Copyright (c) 2015 Kieran Raftery. All rights reserved.
//

import UIKit

class CrimeViewController: UIViewController {

    @IBOutlet weak var offenseLabel: UILabel!
    @IBOutlet weak var methodLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    var phoneButton: UIBarButtonItem!
    
    var offenseText = ""
    var methodText = ""
    var locationText = ""
    var dateTimeText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        offenseLabel.text = offenseText
        methodLabel.text = methodText
        locationLabel.text = locationText
        dateTimeLabel.text = dateTimeText
        
        phoneButton = UIBarButtonItem(title: "Tip", style: UIBarButtonItemStyle.Plain, target: self, action: "tip")
        self.navigationItem.rightBarButtonItem = phoneButton
    }
    
    func tip() {
        let url:NSURL = NSURL(string: "telprompt://2027279099")!
        UIApplication.sharedApplication().openURL(url)
    }
}
