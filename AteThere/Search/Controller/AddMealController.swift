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
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var mealImage: UIImageView!
    @IBOutlet weak var addPictureButton: UIButton!
    @IBOutlet weak var mealNameTextField: CustomTextField!
    @IBOutlet weak var dateTextField: CustomTextField!
    @IBOutlet weak var commentTextView: CustomTextView!
    @IBOutlet weak var commentTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var ratingControl: RatingControl!
    
    // MARK: - Properties
    var searchVenue: SearchVenue?
    let realmService = RealmService()
    let fileManagerService = FileManagerService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureScrollView()
        registerKeyboardNotifications()
        setTextFieldDelegates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewWillLayoutSubviews() {
        commentTextViewHeightConstraint.constant = commentTextView.frame.height
    }
    
    // MARK: - IBAction
    @IBAction func dismissButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
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
        
        if self.presentedViewController != nil {
            self.dismiss(animated: false, completion: nil)
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        let meal = Meal(name: mealNameTextField.text!, date: Date(), rating: ratingControl.rating, comment: commentTextView.text)
        do {
            try realmService.add(meal: meal, forVenue: searchVenue!)
            fileManagerService.save(image: mealImage.image!, withPath: meal.photoPath)
        } catch {
            print(error)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - Helper
extension AddMealController {
    func  registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboardHeight), name: .UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboardHeight), name: .UIKeyboardWillChangeFrame, object: nil)
    }
    
    func configureScrollView() {
        self.automaticallyAdjustsScrollViewInsets = false
        self.scrollView.contentInset = UIEdgeInsets.zero
    }
    
    func setTextFieldDelegates() {
        mealNameTextField.delegate = self
        dateTextField.delegate = self
        commentTextView.delegate = self
    }
    
    func showNoCameraMessage() {
        let alertController = UIAlertController(title: "Alert", message: "Camera is not available on this device", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func adjustForKeyboardHeight(notification: Notification) {
        if let userInfo = notification.userInfo {
            let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, to: view.window)
            
            if notification.name == Notification.Name.UIKeyboardWillHide {
                scrollView.contentInset = UIEdgeInsets.zero
            } else {
                scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
            }
        }
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

// MARK: - UITextFieldDelegate
extension AddMealController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - UITextViewDelegate
extension AddMealController: UITextViewDelegate {
    func textViewDidChangeSelection(_ textView: UITextView) {
        let contentSize = commentTextView.sizeThatFits(self.commentTextView.bounds.size)
        var frame = commentTextView.frame
        frame.size.height = contentSize.height
        commentTextView.frame = frame
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

// MARK: - UIGesturesRecognizerDelegate
extension AddMealController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
