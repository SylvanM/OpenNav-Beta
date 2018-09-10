//
//  MapViewController.swift
//  Navigate HoCo
//
//  Created by Sylvan Martin on 8/23/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import UIKit


class MapViewController: UIViewController, UIScrollViewDelegate {

    enum ViewType {
        case normal
        case route
    }

    // MARK: Properties
    let server = ServerCommunicator()
    var building: BuildingInfo!
    var selectedImage: Int = 0
    var viewType: ViewType = .normal

    @IBOutlet var mapImageView: UIImageView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    // MARK: View Controller

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isToolbarHidden = false
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.mapImageView
    }

    override func viewWillAppear(_ animated: Bool) {
        refresh()
    }

    // MARK: Methods

    // this just refreshes the view
    func refresh() {
        do {
            activityIndicator.startAnimating()

            building = try BuildingInfo()

            if building.acronym != nil {
                self.navigationItem.title = building.acronym + " Map"
            } else {
                displayErrorMessage()
            }

            switch viewType {
            case .normal:
                mapImageView.image = building.floorImages[selectedImage]
            case .route:
                mapImageView.image = building.mappedImages[selectedImage]
            }

            activityIndicator.stopAnimating()
        } catch {
            displayErrorMessage(error)
            print(error)
        }
    }

    // displays an error message with an error as input. This will be a popup for the user.
    func displayErrorMessage(_ error: Error = DataLoadingError.couldNotLoadData) {
        switch error {
        case DataLoadingError.couldNotLoadData:
            let alertController = UIAlertController(title: "No map available", message: "Please make sure you have configured your building info in Settings", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(confirmAction)

            present(alertController, animated: true, completion: nil)

            print(error)
        case NavigationError.noSuchRoomInBuilding:
            let alertController = UIAlertController(title: "No such room", message: "Make sure the start and destination are rooms within the building!", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(confirmAction)

            present(alertController, animated: true, completion: nil)

            print(error)
        default:
            let alertController = UIAlertController(title: "Something went wrong :P", message: "That's out fault. Sorry.", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(confirmAction)

            present(alertController, animated: true, completion: nil)

            print(error)
        }
    }
    
    // MARK: Actions

    // This will make a popup for the user to select a floor to view (because idk how to use page views)
    @IBAction func floorsButtonPressed(_ sender: Any) {
        let alertController = UIAlertController(title: "Which Floor?", message: "Choose the floor to view", preferredStyle: .actionSheet)

        for i in 1...self.building.numberOfFloors {
            let viewFloorAction = UIAlertAction(title: ("Floor " + String(i)), style: .default, handler: { (_) in
                self.selectedImage = i - 1
                self.refresh()
            })

            alertController.addAction(viewFloorAction)
        }

        let clearRouteAction = UIAlertAction(title: "Clear", style: .default, handler: { (_) in
            self.viewType = .normal
            self.refresh()
        })

        let cancelAction = UIAlertAction(title: "Nevermind", style: .cancel, handler: nil)

        alertController.addAction(clearRouteAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }

    @IBAction func refreshMapView(_ sender: Any) {
        refresh()
    }

    // makes popup for user to enter destination and starting point for a path through the layout
    @IBAction func routeButtonPressed(_ sender: Any) {
        let routePrompt = UIAlertController(title: "Make path", message: "Choose your start and destination", preferredStyle: .alert)

        routePrompt.addTextField { (textField) in textField.placeholder = "Start"; textField.keyboardType = UIKeyboardType.numberPad }
        routePrompt.addTextField { (textField) in textField.placeholder = "Destination"; textField.keyboardType = UIKeyboardType.numberPad }

        let confirmAction = UIAlertAction(title: "Go", style: .default, handler: { (_) in
            if let start = Int(routePrompt.textFields![0].text!), let destination = Int(routePrompt.textFields![1].text!) {
                let navigator = Navigator()
                do {
                    self.building.mappedImages = try navigator.makePath(start: start, end: destination, layout: self.building.layout, maps: self.building.floorImages)
                    self.viewType = .route
                    self.refresh()
                } catch {
                    self.displayErrorMessage(error)
                }
            }
        })

        let cancelAction = UIAlertAction(title: "nvm", style: .default, handler: nil)

        routePrompt.addAction(confirmAction)
        routePrompt.addAction(cancelAction)

        self.present(routePrompt, animated: true, completion: nil)
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
