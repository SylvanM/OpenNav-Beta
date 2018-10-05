//
//  MapViewController.swift
//  Navigate HoCo
//
//  Created by Sylvan Martin on 8/23/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import UIKit


class MapViewController: UIViewController, UIScrollViewDelegate {

    let dict = BuildingInfoDictionaryItemNames()

    enum ViewType {
        case normal
        case route
    }

    // MARK: Properties
    let server = ServerCommunicator()
    var building: BuildingInfo!
    var selectedImage: Int = 0
    var viewType: ViewType = .normal
    
    @IBOutlet var infoButton: UIBarButtonItem!
    @IBOutlet var mapImageView: UIImageView!

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
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            let barButton = UIBarButtonItem(customView: activityIndicator)
            self.navigationItem.setLeftBarButton(barButton, animated: true)

            activityIndicator.startAnimating()

            building = try BuildingInfo()

            if let acro = building.info[dict.acronym] as? String {
                self.navigationItem.title = acro + " Map"
            } else {
                displayErrorMessage()
            }

            switch viewType {
            case .normal:
//                mapImageView.image = building.floorImages.first
                mapImageView.image = building.floorImages[selectedImage] // This line can result in crash sometimes
                                                                         // When the previous layout has less images and the layout switches,
                                                                         // if the selected image was of a higher index than the highest of the current layout,
                                                                         // we will get the "Index out of range" error and then crash
            case .route:
//                mapImageView.image = building.mappedImages.first
                mapImageView.image = building.mappedImages[selectedImage] // This line can result in crash sometimes <#same reason as above#>
            }

            activityIndicator.stopAnimating()

            self.navigationItem.setLeftBarButton(infoButton, animated: true)
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

    @objc func userTappedBackground() {
        self.dismiss(animated: true, completion: nil)
    }

    // This will make a popup for the user to select a floor to view (because idk how to use page views)
    @IBAction func floorsButtonPressed(_ sender: Any) {
        let alertController = UIAlertController(title: "Which Floor?", message: "Choose the floor to view", preferredStyle: .actionSheet)

        for i in 0..<(self.building.info[dict.floorCount] as! Int) {
            let viewFloorAction = UIAlertAction(title: self.building.imageNames[i], style: .default, handler: { (_) in
                self.selectedImage = i
                print("Trying to view image \(i)")
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
                    let layout = self.building.layout!
                    let maps = self.building.floorImages!
                    self.building.mappedImages = try navigator.makePath(start: start, end: destination, layout: layout, maps: maps)
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

    @IBAction func infoButtonPressed(_ sender: Any) {

        var message: String = ""

        for (key, _) in building.info {
            message += "\(key): \(building.info[key]!)\n"
        }

        let alertController = UIAlertController(title: (building.info[dict.name] as! String), message: message, preferredStyle: .alert)

        self.present(alertController, animated: true, completion: {
            alertController.view.superview?.isUserInteractionEnabled = true
            alertController.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.userTappedBackground)))
        })
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
