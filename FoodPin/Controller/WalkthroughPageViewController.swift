//
//  WalkthroughPageViewController.swift
//  FoodPin
//
//  Created by Nimbus IoT Solutions on 4/23/20.
//  Copyright © 2020 Nimbus IoT Solutions. All rights reserved.
//

import UIKit

//define a protocol to keep all controllers informed which page we are on
protocol WalkthroughPageViewControllerDelegate: class {
    func didUpdatePageIndex(currentIndex: Int)
}

class WalkthroughPageViewController: UIPageViewController, UIPageViewControllerDataSource,UIPageViewControllerDelegate {

    
    var pageHeadings = ["CREATE YOUR OWN FOOD GUIDE", "SHOW YOU THE LOCATION", "DISCOVER GREAT RESTAURANTS"]
    var pageImages = ["onboarding-1", "onboarding-2", "onboarding-3"]
    var pageSubHeadings = ["Pin your favorite restaurants and create your own food guide",
                       "Search and locate your favourite restaurant on Maps",
                       "Find restaurants shared by your friends and other foodies"]

    var currentIndex = 0
    
    
    weak var walkthroughDelegate: WalkthroughPageViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the data source to itself
        dataSource = self

        // Create the first walkthrough screen
        if let startingViewController = contentViewController(at: 0) {
            setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
        }
        
        //set delegate to self for WalkthroughPageViewControllerDelegate
        delegate = self
        
    }
    

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        var index = (viewController as! WalkthroughContentViewController).index
        index -= 1

        return contentViewController(at: index)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        var index = (viewController as! WalkthroughContentViewController).index
        index += 1

        return contentViewController(at: index)
    }
    
    //helper function to create the page content view controller on demand
    //It takes in the index parameter and creates the corresponding page content controller.
    func contentViewController(at index: Int) -> WalkthroughContentViewController? {
        if index < 0 || index >= pageHeadings.count {
            return nil
        }

        // Create a new view controller and pass suitable data.
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        if let pageContentViewController = storyboard.instantiateViewController(withIdentifier: "WalkthroughContentViewController") as? WalkthroughContentViewController {

            pageContentViewController.imageFile = pageImages[index]
            pageContentViewController.heading = pageHeadings[index]
            pageContentViewController.subHeading = pageSubHeadings[index]
            pageContentViewController.index = index

            return pageContentViewController
        }

        return nil
    }
    
    
    // MARK: - forwardPage()
    // For when user click on "next" or swipe left
    func forwardPage() {
        currentIndex += 1
        if let nextViewController = contentViewController(at: currentIndex) {
            setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    
    //to update the WalkthroughPageViewControllerDelegate after the next walkthrough screen completely shows
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

        if completed {
            if let contentViewController = pageViewController.viewControllers?.first as? WalkthroughContentViewController {

                currentIndex = contentViewController.index

                walkthroughDelegate?.didUpdatePageIndex(currentIndex: contentViewController.index)
            }

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
