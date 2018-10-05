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

        // TODO: make this prettier
        textView.text = "App by Sylvan Martin and Madhava Paliyam \n\nAttributions:\n\nSettings Icon: \"Settings\" by Bharat from thenounproject.com\nMenu Icon: \"menu\" by Nawicon Studio from thenounproject.com\nInfo Icon: \"Info\" by Antony from thenounproject.com\nRoute Icon: \"route\" by Royyan Razka from thenounproject.com\nRefresh Icon: \"Refresh\" by Vectors Market from thenounproject.com"

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
