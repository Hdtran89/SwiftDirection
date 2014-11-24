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
    @IBOutlet weak var getButton:UIButton!
    @IBOutlet weak var messageLabel:UILabel!
    
    let locationManager = CLLocationManager()
    var xcurrentcord: Float = 0
    var ycurrentcord: Float = 0
    var location:CLLocation?
    var updatingLocation = false
    var lastLocationError: NSError?

    override func viewDidLoad()
    {
        super.viewDidLoad()
        saveCoordinate()
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func getLocation()
    {
      //  println("Hello")
        let authStatus:CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        
        if authStatus == .NotDetermined{
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
        
        saveCoordinate()
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
        } else {
            var xstring:NSString = ""
            var ystring:NSString = ""
            println("%y: \(ystring)")
            println("%x: \(xstring)")
            
            var statusMessage: String
            if let error = lastLocationError{
                if error.domain == kCLErrorDomain && error.code == CLError.Denied.rawValue {
                    statusMessage = "Location Service is Disable"
                } else {
                    statusMessage = "Error Getting Location"
                }
            } else if !CLLocationManager.locationServicesEnabled() {
                statusMessage = "Location Services Disabled "
            } else if updatingLocation{
                statusMessage = "Searching..."
            } else {
                statusMessage = "Tap Get My Location to start"
            }
            messageLabel.text = statusMessage
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
    func stopLocationManager()
    {
        if updatingLocation{
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            updatingLocation = false
        }
    }
    //Mark: - CLLocationManagerDelegate
    func locationManager(  manager:CLLocationManager!,
            didFailWithError error: NSError!)
    {
        println("didFailWithError \(error)")
        if error.code == CLError.LocationUnknown.rawValue{
            return
        }
        lastLocationError = error
        stopLocationManager()
        saveCoordinate()
        
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