//
//  DiscoverTableViewController.swift
//  FoodPin
//
//  Created by Nimbus IoT Solutions on 4/26/20.
//  Copyright © 2020 Nimbus IoT Solutions. All rights reserved.
//

import UIKit
import CloudKit

class DiscoverTableViewController: UITableViewController {

    var restaurants: [CKRecord] = []
    var spinner = UIActivityIndicatorView()
    private var imageCache = NSCache<CKRecord.ID, NSURL>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.cellLayoutMarginsFollowReadableWidth = true
        navigationController?.navigationBar.prefersLargeTitles = true

        // Configure navigation bar appearance
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        if let customFont = UIFont(name: "Rubik-Medium", size: 40.0) {
            navigationController?.navigationBar.largeTitleTextAttributes = [ NSAttributedString.Key.foregroundColor: UIColor(red: 231, green: 76, blue: 60), NSAttributedString.Key.font: customFont ]
        }
        
        //async fetech records
        fetchRecordsFromCloud()
        
        
        //show a spinner while data is loading
        spinner.style = .medium
        spinner.hidesWhenStopped = true
        view.addSubview(spinner)

        // Define layout constraints for the spinner
        spinner.translatesAutoresizingMaskIntoConstraints = false //This tells iOS not to create any auto layout constraints for the spinner view. We will do it manually
        NSLayoutConstraint.activate([ spinner.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150.0),
                                      spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor)])

        // Activate the spinner
        spinner.startAnimating()
        
        

        // Pull To Refresh Control
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor.white
        refreshControl?.tintColor = UIColor.gray
        refreshControl?.addTarget(self, action: #selector(fetchRecordsFromCloud), for: UIControl.Event.valueChanged) //if tab is pulled down far enough, engage the refresh
        
        
    }

    
    // Convenience API implementation
//    func fetchRecordsFromCloud() {
//        // Fetch data using Convenience API
//        let cloudContainer = CKContainer.default()
//        let publicDatabase = cloudContainer.publicCloudDatabase
//        let predicate = NSPredicate(value: true)
//        let query = CKQuery(recordType: "Restaurant", predicate: predicate)
//        publicDatabase.perform(query, inZoneWith: nil, completionHandler: {
//            (results, error) -> Void in
//
//            if let error = error {
//                print(error)
//                return
//            }
//
//            if let results = results {
//                print("Completed the download of Restaurant data")
//                self.restaurants = results
//                DispatchQueue.main.async { //use async to free up the handler to run frontend refresh
//                    self.tableView.reloadData()
//                }
//            }
//        })
//    }
    
    // Operational API implementation
    @objc func fetchRecordsFromCloud() {

        // Remove existing records before refreshing
        restaurants.removeAll()
        tableView.reloadData()
        
        // Fetch data using Convenience API
        let cloudContainer = CKContainer.default()
        let publicDatabase = cloudContainer.publicCloudDatabase
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Restaurant", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        // Create the query operation with the query
        let queryOperation = CKQueryOperation(query: query)
//        queryOperation.desiredKeys = ["name", "image"]
        queryOperation.desiredKeys = ["name","type","location","phone","description"] //lazy loading the image
        queryOperation.queuePriority = .veryHigh
        queryOperation.resultsLimit = 50
        queryOperation.recordFetchedBlock = { (record) -> Void in //every record returned is append to restaurants.
            self.restaurants.append(record)
        }
        // after all records are returned , output a note and reload the table
        queryOperation.queryCompletionBlock = { [unowned self] (cursor, error) -> Void in
            if let error = error {
                print("Failed to get data from iCloud - \(error.localizedDescription)")
                return
            }

            print("Successfully retrieve the data from iCloud")
            DispatchQueue.main.async {
                self.spinner.stopAnimating() //stop the spinner and hide it
                self.tableView.reloadData()
                //hide if needed the pull-to-refresh control
                if let refreshControl = self.refreshControl {
                    if refreshControl.isRefreshing {
                        refreshControl.endRefreshing()
                    }
                }
            }
            

            
        }

        // Execute the query
        publicDatabase.add(queryOperation)

    }
    
    //next 3 methods are used to display retrieved records
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiscoverCell", for: indexPath) as! DiscoverTableViewCell

        // Configure the cell...
        let restaurant = restaurants[indexPath.row]
        cell.nameLabel?.text = restaurant.object(forKey: "name") as? String
        cell.typeLabel?.text = restaurant.object(forKey: "type") as? String
        cell.phoneLabel?.text = restaurant.object(forKey: "phone") as? String
        cell.locationLabel?.text = restaurant.object(forKey: "location") as? String
        cell.summaryLabel?.text = restaurant.object(forKey: "description") as? String
//        cell.heartImageView.isHidden = true
        print("nameLabel is \(String(describing: cell.nameLabel?.text))")
        print("type is \(String(describing: cell.typeLabel?.text))")
        print("locationLabel is \(String(describing: cell.locationLabel?.text))")
        // Set the default image
        cell.thumbnailImageView?.image = UIImage(named: "photo")
        
        // Check if the image is stored in cache
        if let imageFileURL = imageCache.object(forKey: restaurant.recordID) {
            // Fetch image from cache
            print("Get image from cache")
            if let imageData = try? Data.init(contentsOf: imageFileURL as URL) {
                cell.thumbnailImageView?.image = UIImage(data: imageData)
            }

        } else {
        // Fetch Image from Cloud in background
        let publicDatabase = CKContainer.default().publicCloudDatabase
        let fetchRecordsImageOperation = CKFetchRecordsOperation(recordIDs: [restaurant.recordID])
        fetchRecordsImageOperation.desiredKeys = ["image"]
        fetchRecordsImageOperation.queuePriority = .veryHigh

        fetchRecordsImageOperation.perRecordCompletionBlock = { (record, recordID, error) -> Void in
            if let error = error {
                print("Failed to get restaurant image: \(error.localizedDescription)")
                return
            }

                if let restaurantRecord = record,
                    let image = restaurantRecord.object(forKey: "image"),
                    let imageAsset = image as? CKAsset {

                    if let imageData = try? Data.init(contentsOf: imageAsset.fileURL!) {

                        // Replace the placeholder image with the restaurant image
                        DispatchQueue.main.async {
                            cell.thumbnailImageView?.image = UIImage(data: imageData)
                            cell.setNeedsLayout() //ask the cell to lay out the view again
                        }
                    }
                }
            }

            publicDatabase.add(fetchRecordsImageOperation)
        }

        return cell
    }
}
