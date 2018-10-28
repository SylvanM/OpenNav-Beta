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
    let keys = Keys()
    
    enum ViewType {
        case normal // shows regular images
        case route  // shows marked images in case of user wanting routing
    }

    // MARK: Properties
    var building: BuildingInfo!      // layout to display
    var selectedImage: Int = 0       // index of image to display
    var viewType: ViewType = .normal // determines the view
    
    @IBOutlet var infoButton: UIBarButtonItem! // button for popup to display info about the school
    @IBOutlet var mapImageView: UIImageView!   // image view for displaying image (kinda self explanatory)
    @IBOutlet var toolBar: UIToolbar!

    // MARK: View Controller

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isToolbarHidden = false // display toolbar
        
//        // enable dark mode
//        NotificationCenter.default.addObserver(self, selector: #selector(enableDarkMode), name: .darkModeEnabled, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(disableDarkMode), name: .darkModeDisabled, object: nil)
//
//        switch UserDefaults.standard.bool(forKey: keys.darkMode) {
//        case true:
//            enableDarkMode()
//        case false:
//            disableDarkMode()
//        }
    }

    // make view able to be zoomable (TODO)
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.mapImageView
    }

    override func viewWillAppear(_ animated: Bool) {
        refresh() // refresh view
    }

    // MARK: Methods

    // this just refreshes the view
    func refresh() {
        
        // dark mode
        switch UserDefaults.standard.bool(forKey: keys.darkMode) {
        case true:
            enableDarkMode()
        case false:
            disableDarkMode()
        }
        
        do {
            
            // make spinning activity indicator in top left of view in place of info button
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            let barButton = UIBarButtonItem(customView: activityIndicator)
            self.navigationItem.setLeftBarButton(barButton, animated: true)
            activityIndicator.startAnimating()

            // make new building from UserDefaults
            building = try BuildingInfo()

            // put title at top of view with the acronym of the layout
            if let acro = building.info[dict.acronym] as? String {
                self.navigationItem.title = acro + " Map"
            } else {
                displayErrorMessage()
            }

            switch viewType {
            case .normal: // if normal view type, display regular images
//                mapImageView.image = building.floorImages.first
                mapImageView.image = building.floorImages[selectedImage] // This line can result in crash sometimes
                                                                         // When the previous layout has less images and the layout switches,
                                                                         // if the selected image was of a higher index than the highest of the current layout,
                                                                         // we will get the "Index out of range" error and then crash
            case .route: // if map view type, display nmarked images
//                mapImageView.image = building.mappedImages.first
                mapImageView.image = building.mappedImages[selectedImage] // This line can result in crash sometimes <#same reason as above#>
            }

            activityIndicator.stopAnimating()

            self.navigationItem.setLeftBarButton(infoButton, animated: true) // set left bar button item back to info button
        } catch {
            displayErrorMessage(error)
            print(error)
        }
    }

    // displays an error message with an error as input. This will be a popup for the user.
    func displayErrorMessage(_ error: Error = DataLoadingError.couldNotLoadData) {
        switch error {
        case DataLoadingError.couldNotLoadData: // display 'could not load data' error in popup
            let alertController = UIAlertController(title: "No map available", message: "Please make sure you have configured your building info in Settings", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(confirmAction)

            present(alertController, animated: true, completion: nil)

            print(error)
        case NavigationError.noSuchRoomInBuilding: // display 'no such room' error in popup
            let alertController = UIAlertController(title: "No such room", message: "Make sure the start and destination are rooms within the building!", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(confirmAction)

            present(alertController, animated: true, completion: nil)

            print(error)
        default: // display misc error in popup
            let alertController = UIAlertController(title: "Something went wrong :P", message: "That's out fault. Sorry.", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(confirmAction)

            present(alertController, animated: true, completion: nil)

            print(error)
        }
    }
    
    // MARK: Actions

    @objc func userTappedBackground() { // dismiss info view
        self.dismiss(animated: true, completion: nil)
    }

    // make popup for the user to select a floor to view (because idk how to use page views)
    @IBAction func floorsButtonPressed(_ sender: Any) {
        let alertController = UIAlertController(title: "Which Floor?", message: "Choose the floor to view", preferredStyle: .actionSheet)

        // for ever image available, create a button and corresponding action for the user to press
        for i in 0..<(self.building.info[dict.floorCount] as! Int) {
            let viewFloorAction = UIAlertAction(title: self.building.imageNames[i], style: .default, handler: { (_) in
                self.selectedImage = i
                print("Trying to view image \(i)")
                self.refresh()
            })

            alertController.addAction(viewFloorAction)
        }

        // make an action/button to let the user dismiss the "route" image overlay
        let clearRouteAction = UIAlertAction(title: "Clear", style: .default, handler: { (_) in
            self.viewType = .normal
            self.refresh()
        })

        // self explanatory
        let cancelAction = UIAlertAction(title: "Nevermind", style: .cancel, handler: nil)

        alertController.addAction(clearRouteAction)
        alertController.addAction(cancelAction)

        // present the alert
        self.present(alertController, animated: true, completion: nil)
    }

    // when "refresh" button tapped, refresh teh view
    @IBAction func refreshMapView(_ sender: Any) {
        refresh()
    }

    // makes popup for user to enter destination and starting point for a path through the layout
    @IBAction func routeButtonPressed(_ sender: Any) {
        let routePrompt = UIAlertController(title: "Make path", message: "Choose your start and destination", preferredStyle: .alert)

        routePrompt.addTextField { (textField) in textField.placeholder = "Start"; textField.keyboardType = UIKeyboardType.numberPad }
        routePrompt.addTextField { (textField) in textField.placeholder = "Destination"; textField.keyboardType = UIKeyboardType.numberPad }

        // function for "route" button to take in the room numbers and overlay a path
        let confirmAction = UIAlertAction(title: "Go", style: .default, handler: { (_) in
            if let start = Int(routePrompt.textFields![0].text!), let destination = Int(routePrompt.textFields![1].text!) {
                let navigator = Navigator() // make instance of Navigator class to do the work for us
                do {
                    // pass in current images and layout of the building to the navigator class
                    let layout = self.building.layout!
                    let maps = self.building.floorImages!
                    
                    // get back 'marked' images from makePath() function
                    self.building.mappedImages = try navigator.makePath(start: start, end: destination, layout: layout, maps: maps)
                    self.viewType = .route
                    self.refresh()
                } catch {
                    self.displayErrorMessage(error)
                }
            }
        })

        // canel
        let cancelAction = UIAlertAction(title: "nvm", style: .default, handler: nil)

        routePrompt.addAction(confirmAction)
        routePrompt.addAction(cancelAction)

        // show popup
        self.present(routePrompt, animated: true, completion: nil)
    }

    @IBAction func infoButtonPressed(_ sender: Any) {

        var message: String = ""

        // make a new line for each piece of info in info dictionary, add it to "message" string
        for (key, _) in building.info {
            message += "\(key): \(building.info[key]!)\n"
        }

        // make popup to display message string
        let alertController = UIAlertController(title: (building.info[dict.name] as! String), message: message, preferredStyle: .alert)

        // present pop-up, listen for user to tap backgroumnd. When user does, dismiss pop up.
        self.present(alertController, animated: true, completion: {
            alertController.view.superview?.isUserInteractionEnabled = true
            alertController.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.userTappedBackground)))
        })
    }

    // MARK: Methods
    
    func enableDarkMode() {
        self.mapImageView.backgroundColor = UIColor.darkGray
    }
    
    func disableDarkMode() {
        self.mapImageView.backgroundColor = UIColor.white
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
