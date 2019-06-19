//
//  AppDelegate.swift
//  PropIQCreativeLabs
//
//
//  Created by Tangerine Creative on 11/05/18.
//  Developer name : - Shashank K. Atray 
//  Copyright © 2018 Tangerine Creative. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    //Crashlytics implementation
 
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // crashlyticas objects implementation
     
       
        
        
        // Reachability and internet connection check
        
        GlobalReachability.sharedInstance.reachability.whenReachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            DispatchQueue.main.async() {
                if reachability.isReachableViaWiFi {
                    // print("Reachable via WiFi")
                } else {
                    // print("Reachable via Cellular")
                }
                
                self.setNetworkStatusBarConnected(true)
            }
        }
        
        // reachability instance for the value that shows the network connection to be false
        
        GlobalReachability.sharedInstance.reachability.whenUnreachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            DispatchQueue.main.async() {
                // print("Not reachable")
                
                self.setNetworkStatusBarConnected(false)
            }
        }
        
        do
        {
            try GlobalReachability.sharedInstance.reachability.startNotifier()
        }
        catch
        {
            // print("Unable to start notifier")
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func setNetworkStatusBarConnected(_ connected:Bool)
    {
        self.removeDefaultErrorAlert()
       
        
        
        if !connected
        {
            if let _ = self.window?.viewWithTag(88)
            {
                return
            }
            
            let vNetworkBar = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 80))
            vNetworkBar.tag = 88
            vNetworkBar.backgroundColor = UIColor.black
            
            let activityIndicator = UIActivityIndicatorView()
            activityIndicator.tag = 81
            activityIndicator.tintColor = UIColor.red
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
            activityIndicator.startAnimating()
            /*activityIndicator.center = CGPoint(x: vNetworkBar.bounds.midX,
             y: vNetworkBar.bounds.midY);*/
            
            var spinnerFrame = activityIndicator.frame
            spinnerFrame.origin.x = vNetworkBar.bounds.midX
            //spinnerFrame.origin.y = ((vNetworkBar.frame.size.height - 20)/2 - spinnerFrame.size.height  / 2) + 20
            spinnerFrame.origin.y = 30
            activityIndicator.frame = spinnerFrame
            
            // vNetworkBar.addSubview(activityIndicator)
            
            // let lblTitle = UILabel(frame: CGRect(x: activityIndicator.frame.origin.x + activityIndicator.frame.size.width + 20, y: 20, width: vNetworkBar.frame.size.width - activityIndicator.frame.size.width - 60, height: vNetworkBar.frame.size.height - 20))
            let lblTitle = UILabel(frame: CGRect(x: 20, y: 20 , width: vNetworkBar.frame.size.width - 40, height: vNetworkBar.frame.size.height - 40 ))
            lblTitle.tag = 82
            lblTitle.textColor = UIColor.white
            lblTitle.textAlignment = .center
           
            lblTitle.minimumScaleFactor = 8/lblTitle.font.pointSize
            lblTitle.numberOfLines = 3
            lblTitle.text = "We can't reach our network right now. Please check your internet connection."
            //            lblTitle.textAlignment = NSTextAlignment.justified
            lblTitle.adjustsFontSizeToFitWidth = true
            vNetworkBar.addSubview(lblTitle)
            
            var frameNetworkBar = vNetworkBar.frame
            frameNetworkBar.origin.y = -frameNetworkBar.size.height
            vNetworkBar.frame = frameNetworkBar
            
            self.window?.addSubview(vNetworkBar)
            
            UIView.animate(withDuration: 1.0, animations: {
                frameNetworkBar = vNetworkBar.frame
                frameNetworkBar.origin.y = 0
                vNetworkBar.frame = frameNetworkBar
            })
        }
        else
        {
            if let vNetworkBar = self.window?.viewWithTag(88)
            {
                vNetworkBar.viewWithTag(81)?.removeFromSuperview()
                
                let lblTitle = vNetworkBar.viewWithTag(82) as! UILabel
                lblTitle.text = "We are now connected to internet."
                //                lblTitle.textColor = UIColor.black
               
                lblTitle.textAlignment = NSTextAlignment.center
                
                var labelFrame = lblTitle.frame
                labelFrame.origin.x = 0
                labelFrame.size.width = vNetworkBar.frame.size.width
                lblTitle.frame = labelFrame
                
                vNetworkBar.backgroundColor = UIColor(red: 0/255.0, green: 100.0/255.0, blue: 0/255.0, alpha: 1.0)
                
                UIView.animate(withDuration: 1.0, delay: 1.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                    
                    var frameNetworkBar = vNetworkBar.frame
                    frameNetworkBar.origin.y = -frameNetworkBar.size.height
                    vNetworkBar.frame = frameNetworkBar
                    
                }, completion: { (finished) in
                    
                    vNetworkBar.removeFromSuperview()
                })
                /*
                 UIView.animate(withDuration: 2.0, animations: {
                 
                 var frameNetworkBar = vNetworkBar.frame
                 frameNetworkBar.origin.y = -frameNetworkBar.size.height
                 vNetworkBar.frame = frameNetworkBar
                 
                 }, completion: { (finished) in
                 
                 vNetworkBar.removeFromSuperview()
                 })*/
            }
        }
    }


}





