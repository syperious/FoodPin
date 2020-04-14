//
//  RestaurantDetailViewController.swift
//  FoodPin
//
//  Created by Nimbus IoT Solutions on 4/13/20.
//  Copyright © 2020 Nimbus IoT Solutions. All rights reserved.
//

import UIKit

class RestaurantDetailViewController: UIViewController {

    
    @IBOutlet var restaurantImageView: UIImageView!
    @IBOutlet var restaurantNameLabel: UILabel!
    @IBOutlet var restaurantLocationLabel: UILabel!
    @IBOutlet var restaurantTypeLabel: UILabel!
    
    var restaurantImageName = ""
    var restaurantNameName = ""
    var restaurantTypeName = ""
    var restaurantLocationName = ""
        
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // OPTIONAL disable large title for all detail pages
        navigationItem.largeTitleDisplayMode = .never
        
        restaurantImageView.image = UIImage(named: restaurantImageName)
        restaurantNameLabel.text = restaurantNameName
        restaurantLocationLabel.text = restaurantLocationName
        restaurantTypeLabel.text = restaurantTypeName

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
