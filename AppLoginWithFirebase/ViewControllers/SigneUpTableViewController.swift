//
//  SigneUpTableViewController.swift
//  AppLoginWithFirebase
//
//  Created by Ibrahima KH GUEYE on 09/12/2017.
//  Copyright © 2017 Ibrahima KH GUEYE. All rights reserved.
//

import UIKit
import MobileCoreServices
class SigneUpTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userEmailTexfield: UITextField!
    @IBOutlet weak var userNameTexfield: UITextField!
    @IBOutlet weak var passwordTexfield: UITextField!
    
    @IBOutlet weak var expTextfield: UITextField!
    @IBOutlet weak var countryTexfield: UITextField!
    
    var countryArray = [String]()
    var pickerView = UIPickerView()
    let expArray = ["Junior", "Experienced", "Senior"]
    var exppickerView = UIPickerView()
    var networkingService = NetworkingService()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for code in NSLocale.isoCountryCodes {
            
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue : code])
            
            let name = NSLocale(localeIdentifier: "en_US").displayName(forKey: NSLocale.Key.identifier, value: id)! 
            countryArray.append(name)
            countryArray.sort(by: { (name1, name2) -> Bool in
                name1 > name2
            })
        }
        
        pickerView.delegate = self;
        pickerView.dataSource = self;
        countryTexfield.inputView = pickerView
        pickerView.tag = 0
        
        exppickerView.delegate = self;
        exppickerView.dataSource = self;
        expTextfield.inputView = exppickerView
        exppickerView.tag = 1
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissController(gesture:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func dismissController (gesture: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        
        networkingService.loginCallback = { (state) in
            switch state {
            case .failed(let error):
                self.presentAlert(With: error)
                break
            case .success:
                print("Success")
                self.presentSuccessAlert(With: "Success", message: "You successfully create your account")
                break
            }
        }
        
        let data = UIImageJPEGRepresentation(userImageView.image!, 0.8)
        networkingService.signUp(email: userEmailTexfield.text!, username: userNameTexfield.text!, password: passwordTexfield.text!, country: countryTexfield.text!, data: data! as NSData)
    }
    
    @IBAction func choosePicture(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        
        let alertController = UIAlertController(title: "Add Picture", message: "Choose from", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) {(action) in
            pickerController.sourceType = .camera
            self.present(pickerController, animated: true, completion: nil)
        }
        
        let photosLibraryAction = UIAlertAction(title: "saved Photos Album", style: .default) {(action) in
            pickerController.sourceType = .photoLibrary
            self.present(pickerController, animated: true, completion: nil)
        }
        
        let savedPhotosAlbumAction = UIAlertAction(title: "Photos Library", style: .default) {(action) in
            pickerController.sourceType = .savedPhotosAlbum
            self.present(pickerController, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "cancel", style: .destructive, handler: nil)
        
        alertController.addAction(cameraAction)
        alertController.addAction(photosLibraryAction)
        alertController.addAction(savedPhotosAlbumAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: nil)
        let image = info["UIImagePickerControllerEditedImage"] as? UIImage
        self.userImageView.image = image
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            countryTexfield.text = countryArray[row]
        }else {
            expTextfield.text = expArray[row]
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0 {
           return countryArray[row]
        }else {
           return expArray[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            return countryArray.count
        }else {
            return expArray.count
        }

    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

}

extension SigneUpTableViewController {
    private func presentAlert(With error: String) {
        let alert = UIAlertController(title: "Erreur", message: error, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    private func presentSuccessAlert(With title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { (UIAlertAction) in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
