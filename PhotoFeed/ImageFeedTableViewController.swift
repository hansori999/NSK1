//
//  ImageFeedTableViewController.swift
//  PhotoFeed
//
//  Created by Myoung-Wan Koo on 2016. 6. 10..
//  Copyright © 2016년 Myoung-Wan Koo. All rights reserved.
//

import UIKit

class ImageFeedTableViewController: UITableViewController {

    var feed: Feed? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.feed?.items.count ?? 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ImageFeedItemTableViewCell", forIndexPath: indexPath) as! ImageFeedItemTableViewCell

        // Configure the cell...
        let item = self.feed!.items[indexPath.row]
        cell.itemTitle.text = item.title
        return cell
    }
    


}
