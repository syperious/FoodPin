//
//  RestaurantDetailMapCell.swift
//  FoodPin
//
//  Created by Nimbus IoT Solutions on 4/15/20.
//  Copyright © 2020 Nimbus IoT Solutions. All rights reserved.
//

import UIKit
import MapKit

class RestaurantDetailMapCell: UITableViewCell {

    @IBOutlet var mapView: MKMapView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
