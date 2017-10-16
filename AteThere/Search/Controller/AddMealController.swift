//
//  AddMealController.swift
//  AteThere
//
//  Created by Ramiro H Lopez on 10/15/17.
//  Copyright © 2017 Ramiro H Lopez. All rights reserved.
//

import Foundation
import UIKit

class AddMealController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var mealImage: UIImageView!
    @IBOutlet weak var addPictureButton: UIButton!
    
    // MARK: - Properties
    var venue: Venue?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.view.frame.width)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    @IBAction func dismissButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - IBAction
    @IBAction func addPictureButtonPressed(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            if !UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.showNoCameraMessage()
            } else {
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
                self.addPictureButton.isHidden = true
            }
        }
        
        let photoLibrayAction = UIAlertAction(title: "Photos", style: .destructive) { (action) in
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in }
        
        alert.addAction(cameraAction)
        alert.addAction(photoLibrayAction)
        alert.addAction(cancelAction)
        
        if self.presentedViewController == nil {
            self.present(alert, animated: true, completion: nil)
        }
        else {
            self.dismiss(animated: false, completion: nil)
            self.present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - Helper
extension AddMealController {
    func showNoCameraMessage() {
        let alertController = UIAlertController(title: "Alert", message: "Camera is not available on this device", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension AddMealController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            mealImage.image = image
        }
        
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UIGesturesRecognizerDelegate
extension AddMealController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
