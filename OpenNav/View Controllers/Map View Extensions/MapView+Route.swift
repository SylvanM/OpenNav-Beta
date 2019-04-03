//
//  MapView+Route.swift
//  OpenNav
//
//  Created by Sylvan Martin on 11/11/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import Foundation
import UIKit

extension MapViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    private struct Holder {
        static var _displayChoice: (String, String) -> () = { (string, another_string) in
            // empty closure
        }
    }
    
    // closure representing what to do when the user chooses a room
    var displayChoice: (String, String) -> () {
        set (newValue) {
            Holder._displayChoice = newValue
        }
        get {
            return Holder._displayChoice
        }
    }
    
    // Picker Views for each text field in the alert controller
    var startPicker: UIPickerView {
        let temp = UIPickerView()
        temp.delegate = self
        temp.tag = 0
        return temp
    }
    
    var endPicker: UIPickerView {
        let temp = UIPickerView()
        temp.delegate = self
        temp.tag = 1
        return temp
    }
    
    func promptForRoute() {
        // picker views for start/end input
        
        if let layout = building.layout, let rooms = building.rooms {
            let alertController = UIAlertController(title: "Choose Path", message: "Choose a start room and end location", preferredStyle: .alert)

            displayChoice = { (field, room) in
                if field == "start" {
                    alertController.textFields?[0].text = room
                } else if field == "end" {
                    alertController.textFields?[1].text = room
                }
            }
            
            // add text fields to alert controller
            alertController.addTextField { (textField) in
                textField.placeholder = "Start"
                textField.inputView = self.startPicker
            }
            
            alertController.addTextField { (textField) in
                textField.placeholder = "End"
                print("End picker: ", self.endPicker)
                textField.inputView = self.endPicker
            }
            
            let goHandler: ((UIAlertAction) -> Void)? = { _ in
                // this code will execute when the user presses go
                
                if let startRoom = alertController.textFields?[0].text, let endRoom = alertController.textFields?[1].text {
                    let startIndex = rooms[startRoom] ?? rooms.first?.value
                    let endIndex = rooms[endRoom]     ?? rooms.first?.value
                    
                    // here's where we make the path and project it on the images
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let goAction     = UIAlertAction(title: "Go", style: .default, handler: goHandler)
            alertController.addAction(goAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true)
        } else {
            displayErrorMessage(NavigationError.layoutNotRoutable)
        }
    }
    
    // MARK: Picker View
    
    var pickerData: [String] {
        if let rooms = building.rooms {
            var temp: [String] = []
            for (name, _) in rooms {
                temp.append(name)
            }
            return temp
        } else {
            // no rooms
            return ["no rooms available"]
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == startPicker.tag {
            // selected start
            
            displayChoice("start", pickerData[row])
            
        } else if pickerView.tag == endPicker.tag {
            // selected end
            
            displayChoice("end", pickerData[row])
            
        } else {
            print("Selected picker: ", pickerView.tag)
        }
    }
    
}
