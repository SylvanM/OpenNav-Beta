//
//  EncryptionOptionsViewController.swift
//  Navigate HoCo
//
//  Created by Sylvan Martin on 8/26/18.
//  Copyright © 2018 Sylvan Martin. All rights reserved.
//

import UIKit

class EncryptionViewController: UIViewController {

    // MARK: Properties

    @IBOutlet var imageOutputView: UIImageView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    var encryptedImageData: Data!

    // MARK: View Controller

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Encryption"
        // Do any additional setup after loading the view.
    }

    // MARK: Methods

    func runDecryptionTest(key: String, iv: String) {
        if let encryptedData = encryptedImageData {
            do {
                activityIndicator.startAnimating()
                let decryptedData = try encryptedData.decrypt(key: Data(bytes: key.bytes), iv: Data(bytes: iv.bytes))

                let decryptedImage = UIImage(data: decryptedData)
                imageOutputView.image = decryptedImage

                activityIndicator.stopAnimating()
            } catch {

            }
        }
    }

    func runEncryptionTest(_ imageToEncrypt: String, key: String, iv: String) {
        // run encryption diagnostic

        do {
            if let imageData = UserDefaults.standard.data(forKey: imageToEncrypt), let image = UIImage(data: imageData) {
                // Encrypt the Image
                let dataToEncrypt = image.pngData()
                let encryptedData = try dataToEncrypt?.encrypt(key: Data(bytes: key.bytes), iv: Data(bytes: iv.bytes))
                
                print("Data to encrypt: \(String(describing: dataToEncrypt?.bytes))")
                print("Encrypted data: \(String(describing: encryptedData?.bytes))")

                encryptedImageData = encryptedData

                activityIndicator.stopAnimating()

            } else {
                print("Image not in UserDefaults")
            }
        } catch {
            print(error)
        }
    }

    // MARK: Actions

    @IBAction func testEncryptionButtonPressed(_ sender: Any) {
        let encryptionPrompt = UIAlertController(title: "Encrypt", message: "Put in the encryption settings", preferredStyle: .alert)

        encryptionPrompt.addTextField(configurationHandler: { (textField) in textField.placeholder = "image to encrypt/decrypt" })
        encryptionPrompt.addTextField(configurationHandler: { (textField) in textField.placeholder = "key" } )
        encryptionPrompt.addTextField(configurationHandler: { (textField) in textField.placeholder = "iv" } )

        let encryptAction = UIAlertAction(title: "Encrypt", style: .default, handler: { (_) in
            self.runEncryptionTest(encryptionPrompt.textFields![0].text!, key: encryptionPrompt.textFields![1].text!, iv: encryptionPrompt.textFields![2].text!)
        })

        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)

        encryptionPrompt.addAction(encryptAction)
        encryptionPrompt.addAction(cancelAction)

        self.present(encryptionPrompt, animated: true, completion: nil)
    }

    @IBAction func testDecryptionButtonPressed(_ sender: Any) {
        let decryptionPrompt = UIAlertController(title: "Decrypt", message: "Put in the encryption settings", preferredStyle: .alert)

        decryptionPrompt.addTextField(configurationHandler: { (textField) in textField.placeholder = "key" } )
        decryptionPrompt.addTextField(configurationHandler: { (textField) in textField.placeholder = "iv" } )

        let decryptAction = UIAlertAction(title: "Decrypt", style: .default, handler: { (_) in
            self.runDecryptionTest(key: decryptionPrompt.textFields![0].text!, iv: decryptionPrompt.textFields![1].text!)
        })

        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)

        decryptionPrompt.addAction(decryptAction)
        decryptionPrompt.addAction(cancelAction)

        self.present(decryptionPrompt, animated: true, completion: nil)
    }

}
