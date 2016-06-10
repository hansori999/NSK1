//
//  AppDelegate.swift
//  PhotoFeed
//
//  Created by Myoung-Wan Koo on 2016. 5. 6..
//  Copyright © 2016년 Myoung-Wan Koo. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        // RegisterDefaults
        NSUserDefaults.standardUserDefaults().registerDefaults(["PhotoFeedURLString": "https://api.flickr.com/services/feeds/photos_public.gne?tags=kitten&format=json&nojsoncallback=1"])
        return true
    }


    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        let urlString = NSUserDefaults.standardUserDefaults().stringForKey("PhotoFeedURLString")
        print(urlString)
        
        
        guard let foundURLString = urlString else {
            return
        }
        
        if let url = NSURL(string: foundURLString) {
            self.updateFeed(url, completion: { (feed) -> Void in
                let viewController = application.windows[0].rootViewController as? ImageFeedTableViewController
                viewController?.feed = feed
            })
        }
        

    }


    func updateFeed(url: NSURL, completion: (feed: Feed?) -> Void) {
        
        let dataFile = NSBundle.mainBundle().URLForResource("photos_public.gne", withExtension: ".js")!
        
        let data = NSData(contentsOfURL: dataFile)!
        
        let feed = Feed(data: data, sourceURL: url)
        
        completion(feed: feed)
        
    }

}

