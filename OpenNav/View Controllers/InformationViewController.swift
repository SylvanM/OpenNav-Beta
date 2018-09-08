//
//  InformationViewController.swift
//  Navigate HoCo
//
//  Created by Sylvan Martin on 8/25/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import UIKit

class InformationViewController: UIViewController {

    // MARK: Properties

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var floorCountLabel: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Info"

        let settingsButton = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(goToSettingsView))
        self.navigationItem.rightBarButtonItem = settingsButton

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        do {
            activityIndicator.startAnimating()

            let building = try BuildingInfo()

            if building.name != nil {
                self.nameLabel.text = "Building name: " + building.name
            } else {
                displayNoInfoMessage()
            }

            if building.numberOfFloors != nil {
                self.floorCountLabel.text = "Floors: " + String(building.numberOfFloors)
            } else {
                displayNoInfoMessage()
            }

            activityIndicator.stopAnimating()
        } catch {
            displayNoInfoMessage(error)
            print(error)
        }
    }

    @objc
    func goToSettingsView() {
        performSegue(withIdentifier: "settingsSegue", sender: nil)
    }

    // MARK: Actions

    @IBAction func refreshInfo(_ sender: Any) {
        do {
            activityIndicator.startAnimating()

            let building = try BuildingInfo()

            if building.name != nil {
                self.nameLabel.text = "Building name: " + building.name
            } else {
                displayNoInfoMessage()
            }

            if building.numberOfFloors != nil {
                self.floorCountLabel.text = "Floors: " + String(building.numberOfFloors)
            } else {
                displayNoInfoMessage()
            }

            activityIndicator.stopAnimating()
        } catch {
            displayNoInfoMessage(error)
            print(error)
        }
    }

    func displayNoInfoMessage(_ error: Error = DataLoadingError.couldNotLoadData) {
        let alertController = UIAlertController(title: "No map available", message: "Please make sure you have configured your building info in Settings", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(confirmAction)

        present(alertController, animated: true, completion: nil)

        print(error)
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
