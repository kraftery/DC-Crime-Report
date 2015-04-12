//
//  ViewController.swift
//  DCCrimeReport
//
//  Created by Kieran Raftery on 4/11/15.
//  Copyright (c) 2015 Kieran Raftery. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, NSXMLParserDelegate, CLLocationManagerDelegate, MKMapViewDelegate {

    var parser: NSXMLParser = NSXMLParser()
    var crimes: [Crime] = []
    var reportedDateTime = String()
    var offense = String()
    var method = String()
    var blockSiteAddress = String()
    var eName = String()
    
    var locationManager: CLLocationManager!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "Recent Crimes"
        mapView.delegate = self
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let url:NSURL = NSURL(string: "http://data.octo.dc.gov/feeds/crime_incidents/crime_incidents_current.xml")!
        parser = NSXMLParser(contentsOfURL: url)!
        parser.delegate = self
        parser.parse()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* MARK - CLLocationManagerDelegate */
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        self.locationManager.stopUpdatingLocation()
        
        let userCoordinates: CLLocationCoordinate2D = manager.location.coordinate
        let region = MKCoordinateRegion(center: userCoordinates, span: MKCoordinateSpanMake(0.05, 0.05))
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        
        println("Error while updating location " + error.localizedDescription)
    }
    
    /* MARK - NSXMLParserDelegate */
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
            
            //let s = blockSiteAddress.substringFromIndex(advance(blockSiteAddress.startIndex,7)) + " Washington, DC"
            let s = blockSiteAddress + " Washington, DC"

            CLGeocoder().geocodeAddressString(s, completionHandler: {(placemarks, error)->Void in
                if error == nil {
                    
                    let placemark = placemarks[0] as CLPlacemark
                    self.placePin(placemark.location, crime: crime)
                }
            })

        }
    }
    
    func placePin(location: CLLocation!, crime: Crime!) {
        
        let pinAnnotation = CrimePinAnnotation()
        pinAnnotation.setCoordinate(location.coordinate)
        pinAnnotation.title = crime.offense
        pinAnnotation.crime = crime
        self.mapView.addAnnotation(pinAnnotation)
    }
    
    /* MARK - MKMapViewDelegate */
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if annotation is CrimePinAnnotation {
            let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myPin")
            
            pinAnnotationView.canShowCallout = true
            pinAnnotationView.animatesDrop = true
            
            let infoButton = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as UIButton
            
            pinAnnotationView.leftCalloutAccessoryView = infoButton
            
            return pinAnnotationView
        }
        
        return nil
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        
        if let annotation = view.annotation as? CrimePinAnnotation {
            
            let vc: CrimeViewController = CrimeViewController()
            vc.offenseLabel.text = annotation.crime.offense
            vc.methodLabel.text = annotation.crime.method
            vc.locationLabel.text = annotation.crime.blockSiteAddress
            vc.dateTimeLabel.text = annotation.crime.reportedDateTime
            
            presentViewController(vc, animated: true, completion: nil)
        }
    }
}

