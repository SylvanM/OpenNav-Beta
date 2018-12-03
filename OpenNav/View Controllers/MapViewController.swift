//
//  MapViewController.swift
//  Navigate HoCo
//
//  Created by Sylvan Martin on 8/23/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import UIKit

/*
 * Class to control main view of app
 * Shows images downloaded from web service
 */

class MapViewController: UIViewController, UIScrollViewDelegate {

    // key names for items in the info dictionary
    let dict = BuildingInfoDictionaryItemNames()
    // get key names for UserDefaults
    let settings = UserSettings()
    
    enum ViewType {
        case normal // shows regular images
        case route  // shows marked images in case of user wanting routing
    }
    

    // MARK: Properties
    var building: BuildingInfo!      // layout to display
    var selectedImage: Int = 0       // index of image to display
    var viewType: ViewType = .normal // determines the view
    
    @IBOutlet var infoButton:   UIBarButtonItem! // button for popup to display info about the school
    @IBOutlet var mapImageView: UIImageView!   // image view for displaying image (kinda self explanatory)
    @IBOutlet var scrollView:   UIScrollView!

    // MARK: View Controller

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isToolbarHidden = false // display toolbar
    }

    override func viewWillAppear(_ animated: Bool) {
        refresh() // refresh view
        
        // update zoom limits
        if let minZoom = settings.get(setting: .minZoom) as? Int, let maxZoom = settings.get(setting: .maxZoom) as? Int {
            scrollView.minimumZoomScale = CGFloat(minZoom)
            scrollView.maximumZoomScale = CGFloat(maxZoom)
        } else {
            print("something went wrong")
        }
    }
    
    
    // MARK: Actions

    @objc func userTappedBackground() { // dismiss info view
        self.dismiss(animated: true, completion: nil)
    }

    // make popup for the user to select a floor to view (because idk how to use page views)
    @IBAction func floorsButtonPressed(_ sender: Any) {
        displayFloorsMenu()
    }

    // when "refresh" button tapped, refresh teh view
    @IBAction func refreshMapView(_ sender: Any) {
        refresh()
    }

    // makes popup for user to enter destination and starting point for a path through the layout
    @IBAction func routeButtonPressed(_ sender: Any) {
        promptForRoute()
    }

    @IBAction func infoButtonPressed(_ sender: Any) {
        displayInfo()
    }

    // MARK: Methods
    
    func enableDarkMode() {
        self.mapImageView.backgroundColor = UIColor.darkGray
        self.scrollView.backgroundColor   = UIColor.darkGray
    }
    
    func disableDarkMode() {
        self.mapImageView.backgroundColor = UIColor.white
        self.scrollView.backgroundColor   = UIColor.white
    }
    
    // MARK: Storyboard
    
}
