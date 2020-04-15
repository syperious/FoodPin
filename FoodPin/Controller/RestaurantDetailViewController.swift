//
//  RestaurantDetailViewController.swift
//  FoodPin
//
//  Created by Nimbus IoT Solutions on 4/13/20.
//  Copyright © 2020 Nimbus IoT Solutions. All rights reserved.
//

import UIKit

class RestaurantDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet var restaurantImageView: UIImageView!
    @IBOutlet var restaurantNameLabel: UILabel!
    @IBOutlet var restaurantLocationLabel: UILabel!
    @IBOutlet var restaurantTypeLabel: UILabel!
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var headerView: RestaurantDetailHeaderView!
    
    var restaurant = Restaurant()
        
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //link to table view in storyboard
        tableView.delegate = self
        tableView.dataSource = self
        //remove all separators in this view
        tableView.separatorStyle = .none

        navigationItem.largeTitleDisplayMode = .never
        
        // Set nagivationBar transparent
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        //change naviBar item colors to white
        navigationController?.navigationBar.tintColor = .white

        // By default this value is .always, by setting to never we allow the conntent area to overlap with naviBar
        tableView.contentInsetAdjustmentBehavior = .never
        

        // Configure header view
        headerView.nameLabel.text = restaurant.name
        headerView.typeLabel.text = restaurant.type
        headerView.headerImageView.image = UIImage(named: restaurant.image)
        headerView.heartImageView.isHidden = (restaurant.isVisited) ? false : true
        
        
        
        
    }

    //1 body of text
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    // 3 sections of body: location, phone, description
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.row {
        case 0: // displays the phone number line
            //String(describing: RestaurantDetailIconTextCell.self) returns "RestaurantDetailIconTextCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailIconTextCell.self), for: indexPath) as! RestaurantDetailIconTextCell
            cell.iconImageView.image = UIImage(systemName: "phone")?.withTintColor(.black, renderingMode: .alwaysOriginal)
            cell.shortTextLabel.text = restaurant.phone
            cell.selectionStyle = .none

            return cell
            
        case 1: //display the map icon and the location
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailIconTextCell.self), for: indexPath) as! RestaurantDetailIconTextCell
            cell.iconImageView.image = UIImage(systemName: "map")?.withTintColor(.black, renderingMode: .alwaysOriginal)
            cell.shortTextLabel.text = restaurant.location
            cell.selectionStyle = .none

            return cell
            
        case 2: //display the description
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailTextCell.self), for: indexPath) as! RestaurantDetailTextCell
            cell.descriptionLabel.text = restaurant.description
            cell.selectionStyle = .none

            return cell

        default: //else
            fatalError("Failed to instantiate the table view cell for detail view controller")
        }
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
