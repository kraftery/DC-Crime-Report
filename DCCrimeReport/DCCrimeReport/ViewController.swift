//
//  ViewController.swift
//  DCCrimeReport
//
//  Created by Kieran Raftery on 4/11/15.
//  Copyright (c) 2015 Kieran Raftery. All rights reserved.
//

import UIKit

class ViewController: UIViewController, NSXMLParserDelegate {

    var parser: NSXMLParser = NSXMLParser()
    var crimes: [Crime] = []
    var reportedDateTime = String()
    var offense = String()
    var method = String()
    var blockSiteAddress = String()
    var eName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let url:NSURL = NSURL(string: "http://data.octo.dc.gov/feeds/crime_incidents/crime_incidents_current.xml")!
        parser = NSXMLParser(contentsOfURL: url)!
        parser.delegate = self
        parser.parse()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!,qualifiedName qName: String!, attributes attributeDict: [NSObject : AnyObject]!) {
        
        eName = elementName
        if(elementName == "dcst:ReportedCrime") {
            reportedDateTime = String()
            offense = String()
            method = String()
            blockSiteAddress = String()
        }
    }
    
    func parser(parser: NSXMLParser!, foundCharacters string: String!) {
        
        let data = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if(!(data.isEmpty)) {
            if(eName == "dcst:reportdatetime") {
                reportedDateTime += data
            }
            else if(eName == "dcst:offense") {
                offense += data
            }
            else if(eName == "dcst:method") {
                method += data
            }
            else if(eName == "dcst:blocksiteaddress") {
                blockSiteAddress += data
            }
        }
    }
    
    func parser(parser: NSXMLParser!, didEndElement elementName: String!, namespaceURI: String!,qualifiedName qName: String!) {
        
        if (elementName == "dcst:ReportedCrime") {
            let crime = Crime()
            crime.blockSiteAddress = blockSiteAddress
            crime.offense = offense
            crime.method = method
            crime.reportedDateTime = reportedDateTime
            crimes.append(crime)
        }
    }
}

