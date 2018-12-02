//
//  WelcomeViewController.swift
//  AppLoginWithFirebase
//
//  Created by Ibrahima KH GUEYE on 02/12/2018.
//  Copyright © 2018 Ibrahima KH GUEYE. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class WelcomeViewController: UIViewController {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var welcomeTextField: UILabel!
    
    var databaseRef: DatabaseReference {
        return Database.database().reference()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setWelcomeViewController()
    }
    
    @IBAction func logOut(_ sender: Any) {
        
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Login")
                present(vc, animated: true, completion: nil)
            }catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
   
    func setWelcomeViewController() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        databaseRef.child("users/\(uid)").observe(.value, with: { (snapshot) in
            DispatchQueue.main.async(execute: {
                let user = UserInfo(snapshot: snapshot)
                let strWelcome = "Dear \(user.username!) \n\n Welcome to LoginWithFirebase App!"
                self.welcomeTextField.text = strWelcome
                let imag = String(user.photoUrl)
                if !imag.isEmpty {
                    let storageRef = Storage.storage().reference(forURL: imag)
                    storageRef.getData(maxSize: 1 * 1024*1024, completion: { (data, error) in
                        if error == nil {
                            self.userImage.image = UIImage(data: data!)
                        }else {
                            print("Error: \(String(describing: error?.localizedDescription))")
                        }
                    })
                }
            })
        }) { (error) in
            print("Error: \(error.localizedDescription)")
        }
    }
   
}
