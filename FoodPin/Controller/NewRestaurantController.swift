//
//  NewRestaurantControllerTableViewController.swift
//  FoodPin
//
//  Created by Nimbus IoT Solutions on 4/18/20.
//  Copyright © 2020 Nimbus IoT Solutions. All rights reserved.
//

import UIKit
import CoreData
import CloudKit

class NewRestaurantController: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    
    @IBOutlet var photoImageView: UIImageView!
    
    var restaurant: RestaurantMO!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = .none
        
        // Configure navigation bar appearance
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        if let customFont = UIFont(name: "Rubik-Medium", size: 35.0) {
            navigationController?.navigationBar.largeTitleTextAttributes = [ NSAttributedString.Key.foregroundColor: UIColor(red: 231, green: 76, blue: 60), NSAttributedString.Key.font: customFont ]
        }
    }

// MARK: - Table view data source
    @IBOutlet var nameTextField: RoundedTextField! {
        didSet {
            nameTextField.tag = 1
            nameTextField.becomeFirstResponder()
            nameTextField.delegate = self
        }
    }

    @IBOutlet var typeTextField: RoundedTextField! {
        didSet {
            typeTextField.tag = 2
            typeTextField.delegate = self
        }
    }

    @IBOutlet var addressTextField: RoundedTextField! {
        didSet {
            addressTextField.tag = 3
            addressTextField.delegate = self
        }
    }

    @IBOutlet var phoneTextField: RoundedTextField! {
        didSet {
            phoneTextField.tag = 4
            phoneTextField.delegate = self
        }
    }

    @IBOutlet var descriptionTextView: UITextView! {
        didSet {
            descriptionTextView.tag = 5
            descriptionTextView.layer.cornerRadius = 5.0
            descriptionTextView.layer.masksToBounds = true
        }
    }
    
    
    
    
    
    // For when pressing the "save" button on the new restaurant
    @IBAction func saveButtonTapped(sender: AnyObject) {
        if nameTextField.text == "" || typeTextField.text == "" || addressTextField.text == "" || phoneTextField.text == "" || descriptionTextView.text == "" {
            let alertController = UIAlertController(title: "Oops", message: "We can't proceed because one of the fields is blank. Please note that all fields are required.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
            
            return
        }
        
        print("Name: \(nameTextField.text ?? "")")
        print("Type: \(typeTextField.text ?? "")")
        print("Location: \(addressTextField.text ?? "")")
        print("Phone: \(phoneTextField.text ?? "")")
        print("Description: \(descriptionTextView.text ?? "")")
        
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            restaurant = RestaurantMO(context: appDelegate.persistentContainer.viewContext)
            restaurant.name = nameTextField.text
            restaurant.type = typeTextField.text
            restaurant.location = addressTextField.text
            restaurant.phone = phoneTextField.text
            restaurant.summary = descriptionTextView.text
            restaurant.isVisited = false

            if let restaurantImage = photoImageView.image {
                restaurant.image = restaurantImage.pngData()
            }

            print("Saving data to context ...")
            appDelegate.saveContext()
        }
        
        //save to cloud
        saveRecordToCloud(restaurant: restaurant)
        
        dismiss(animated: true, completion: nil)
    }
    

    
    
    
    
    
    // MARK: - Table view data source

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = view.viewWithTag(textField.tag + 1) {
            textField.resignFirstResponder()
            nextTextField.becomeFirstResponder()
        }

        return true
    }
    
    
    
    //if user clicks on the photo of this page (element 0)
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {

            let photoSourceRequestController = UIAlertController(title: "", message: "Choose your photo source", preferredStyle: .actionSheet)

            // Create Camera option
            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { (action) in
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self //Added when delagate is added
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .camera

                    self.present(imagePicker, animated: true, completion: nil)
                }
            })
            
            // Create load from Photo Library option
            let photoLibraryAction = UIAlertAction(title: "Photo library", style: .default, handler: { (action) in
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self //Added when delagate is added
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .photoLibrary

                    self.present(imagePicker, animated: true, completion: nil)
                }
            })

            
            
            photoSourceRequestController.addAction(cameraAction)
            photoSourceRequestController.addAction(photoLibraryAction)

            // For iPad
            if let popoverController = photoSourceRequestController.popoverPresentationController {
                if let cell = tableView.cellForRow(at: indexPath) {
                    popoverController.sourceView = cell
                    popoverController.sourceRect = cell.bounds
                }
            }

            present(photoSourceRequestController, animated: true, completion: nil)

        }
    }
    
    // for after a picture is selected from photo library and needed to be passed back to the image cell
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            photoImageView.image = selectedImage
            photoImageView.contentMode = .scaleAspectFill
            photoImageView.clipsToBounds = true
        }

        let leadingConstraint = NSLayoutConstraint(item: photoImageView as Any, attribute: .leading, relatedBy: .equal, toItem: photoImageView.superview, attribute: .leading, multiplier: 1, constant: 0)
        leadingConstraint.isActive = true

        let trailingConstraint = NSLayoutConstraint(item: photoImageView as Any, attribute: .trailing, relatedBy: .equal, toItem: photoImageView.superview, attribute: .trailing, multiplier: 1, constant: 0)
        trailingConstraint.isActive = true

        let topConstraint = NSLayoutConstraint(item: photoImageView as Any, attribute: .top, relatedBy: .equal, toItem: photoImageView.superview, attribute: .top, multiplier: 1, constant: 0)
        topConstraint.isActive = true

        let bottomConstraint = NSLayoutConstraint(item: photoImageView as Any, attribute: .bottom, relatedBy: .equal, toItem: photoImageView.superview, attribute: .bottom, multiplier: 1, constant: 0)
        bottomConstraint.isActive = true

        dismiss(animated: true, completion: nil)
    }
    
    
    // when saving a new restaurant, save it to the cloud
    func saveRecordToCloud(restaurant:RestaurantMO!) -> Void {

        // Prepare the record to save
        let record = CKRecord(recordType: "Restaurant")
        record.setValue(restaurant.name, forKey: "name")
        record.setValue(restaurant.type, forKey: "type")
        record.setValue(restaurant.location, forKey: "location")
        record.setValue(restaurant.phone, forKey: "phone")
        record.setValue(restaurant.summary, forKey: "description")

        let imageData = restaurant.image! as Data

        // Resize the image
        let originalImage = UIImage(data: imageData)!
        let scalingFactor = (originalImage.size.width > 1024) ? 1024 / originalImage.size.width : 1.0
        let scaledImage = UIImage(data: imageData, scale: scalingFactor)!

        // Write the image to local file for temporary use
        let imageFilePath = NSTemporaryDirectory() + restaurant.name!
        let imageFileURL = URL(fileURLWithPath: imageFilePath)
        try? scaledImage.jpegData(compressionQuality: 0.8)?.write(to: imageFileURL)

        // Create image asset for upload
        let imageAsset = CKAsset(fileURL: imageFileURL)
        record.setValue(imageAsset, forKey: "image")

        // Get the Public iCloud Database
        let publicDatabase = CKContainer.default().publicCloudDatabase

        // Save the record to iCloud
        publicDatabase.save(record, completionHandler: { (record, error) -> Void  in
            // Remove temp file
            try? FileManager.default.removeItem(at: imageFileURL)
        })
    }
    
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
