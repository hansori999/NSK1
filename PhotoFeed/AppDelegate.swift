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
            self.loadOrUpdateFeed(url, completion: { (feed) -> Void in
                let viewController = application.windows[0].rootViewController as? ImageFeedTableViewController
                viewController?.feed = feed
            })
        }
        

    }

/*
    func updateFeed(url: NSURL, completion: (feed: Feed?) -> Void) {
        
        let dataFile = NSBundle.mainBundle().URLForResource("photos_public.gne", withExtension: ".js")!
        
        let data = NSData(contentsOfURL: dataFile)!
        
        let feed = Feed(data: data, sourceURL: url)
        
        completion(feed: feed)
        
    }
*/
    
    func updateFeed(url: NSURL, completion: (feed: Feed?) -> Void) {
        let request = NSURLRequest(URL: url)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
            if error == nil && data != nil {
                let feed = Feed(data: data!, sourceURL: url)
                
                if let goodFeed = feed {
                    if self.saveFeed(goodFeed) {
                        NSUserDefaults.standardUserDefaults().setObject(NSDate(), forKey: "lastUpdate")
                    }
                }
                
                print("loaded Remote feed!")

                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    completion(feed: feed)
                })
            }
            
        }
        
        task.resume()
    }

    
    // Find Path for feedFile.plist
    func feedFilePath() -> String {
        let paths = NSFileManager.defaultManager().URLsForDirectory(.CachesDirectory, inDomains: .UserDomainMask)
        let filePath = paths[0].URLByAppendingPathComponent("feedFile.plist")
        return filePath.path!
    }
    
    func saveFeed(feed: Feed) -> Bool {
        let success = NSKeyedArchiver.archiveRootObject(feed, toFile: feedFilePath())
        assert(success, "failed to write archive")
        return success
    }
    
    func readFeed(completion: (feed: Feed?) -> Void) {
        let path = feedFilePath()
        let unarchivedObject = NSKeyedUnarchiver.unarchiveObjectWithFile(path)
        completion(feed: unarchivedObject as? Feed)
    }

    func loadOrUpdateFeed(url: NSURL, completion: (feed: Feed?) -> Void) {
        
        let lastUpdatedSetting = NSUserDefaults.standardUserDefaults().objectForKey("lastUpdate") as? NSDate
        
        var shouldUpdate = true
        if let lastUpdated = lastUpdatedSetting where NSDate().timeIntervalSinceDate(lastUpdated) < 20 {
            shouldUpdate = false
        }
        if shouldUpdate {
            self.updateFeed(url, completion: completion)
        } else {
            self.readFeed { (feed) -> Void in
                if let foundSavedFeed = feed where foundSavedFeed.sourceURL.absoluteString == url.absoluteString {
                    print("loaded saved feed!")
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        completion(feed: foundSavedFeed)
                    })
                } else {
                    self.updateFeed(url, completion: completion)
                }
                
                
            }
        }
        
        
        
    }
    
}

