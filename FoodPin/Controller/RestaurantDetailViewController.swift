//
//  RestaurantDetailViewController.swift
//  FoodPin
//
//  Created by Nimbus IoT Solutions on 4/13/20.
//  Copyright © 2020 Nimbus IoT Solutions. All rights reserved.
//

import UIKit

class RestaurantDetailViewController: UIViewController {

    
//    @IBOutlet var restaurantImageView: UIImageView!
//    @IBOutlet var restaurantNameLabel: UILabel!
//    @IBOutlet var restaurantLocationLabel: UILabel!
//    @IBOutlet var restaurantTypeLabel: UILabel!
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var headerView: RestaurantDetailHeaderView!
    
    var restaurant = Restaurant()
        
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never

        // Configure header view
        headerView.nameLabel.text = restaurant.name
        headerView.typeLabel.text = restaurant.type
        headerView.headerImageView.image = UIImage(named: restaurant.image)
        headerView.heartImageView.isHidden = (restaurant.isVisited) ? false : true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
