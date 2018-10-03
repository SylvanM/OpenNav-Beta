//
//  AboutViewController.swift
//  OpenNav
//
//  Created by Sylvan Martin on 10/3/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    // MARK: Propeties

    @IBOutlet var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "About"

        textView.text = "App by Sylvan Martin and Madhava Paliyam \n\nAttributions:\nPLACE IMAGE CREDITS HERE"

        // Do any additional setup after loading the view.
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
