//
//  BaseRoute.swift
//  SwiftDirection
//
//  Created by Hieu Tran on 10/23/14.
//  Copyright (c) 2014 Hieu Tran. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class BaseLocation: UIViewController,CLLocationManagerDelegate
{
    
    let locationManager = CLLocationManager()
    var xcurrentcord: Float = 0
    var ycurrentcord: Float = 0
    var location:CLLocation?
    
    @IBAction func getLocation()
    {
        let authStatus:CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        
        if (authStatus == .NotDetermined)
        {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        
        if authStatus == .Denied || authStatus == .Restricted {
            showLocationServicesDeniedAlert()
            return
        }
        

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    override func prepareForSegue( segue: UIStoryboardSegue,
                                  sender: AnyObject?)
    {
        
    }
    
    func saveCoordinate()
    {
        if let location = location{
            var xstring:NSString = ""
            var ystring:NSString = ""
            
            xstring = NSString(format: "%.8f", location.coordinate.longitude)
            ystring = NSString(format: "%.8f", location.coordinate.latitude)
            
            println("%y: \(ystring)")
            println("%x: \(xstring)")
            
            xcurrentcord = (xstring as NSString).floatValue
            ycurrentcord = (ystring as NSString).floatValue
            
            println("floaty:  \(ycurrentcord)")
            println("floatx:  \(xcurrentcord)")
        }
    }
    func showLocationServicesDeniedAlert()
    {
        let alert = UIAlertController(title: "Location Service Disabled",
                                    message: "Please enable location service in the app Settings",
                             preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK",
                                     style: .Default,
                                   handler: nil)
        alert.addAction(okAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    //Mark -- Delegation CLLocationManager
    func locationManager(  manager:CLLocationManager!,
            didFailWithError error: NSError!)
    {
        println("didFailWithError \(error)")
    }
    
    func locationManager(    manager: CLLocationManager!,
        didUpdateLocations locations: [AnyObject]!)
    {
        let newLocation = locations.last as CLLocation
        location = newLocation
        saveCoordinate()
        println("didUpdateLocation \(newLocation)")
    }
}